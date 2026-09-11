$ErrorActionPreference = 'Stop'
$Root = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
Set-Location $Root
Write-Host "Cleaning icon picker in: $Root"

$itemsPath = Join-Path $Root 'items.json'
$data = Get-Content $itemsPath -Raw -Encoding UTF8 | ConvertFrom-Json

$dropSets = @('lockups','grafton')
$beforeItems = @($data.items).Count
$data.sets = @($data.sets | Where-Object { $dropSets -notcontains $_.id })
$data.items = @($data.items | Where-Object { $dropSets -notcontains $_.set })

$deletedFiles = 0
foreach ($dir in @('full','thumbs')) {
  $d = Join-Path $Root $dir
  if (-not (Test-Path $d)) { continue }
  Get-ChildItem $d -File | Where-Object {
    $_.BaseName -like 'lockups-*' -or $_.BaseName -like 'grafton-*'
  } | ForEach-Object { Remove-Item $_.FullName -Force; $script:deletedFiles++ }
}

$fullDir = Join-Path $Root 'full'
$priority = @('live','colorways','skies','lighthouse','squares','earlier')
$prio = @{}
for ($i=0; $i -lt $priority.Count; $i++) { $prio[$priority[$i]] = $i }

$byHash = @{}
$missing = New-Object System.Collections.Generic.List[string]
foreach ($it in @($data.items)) {
  $fp = $null
  foreach ($ext in @('.jpg','.png','.webp','.jpeg')) {
    $cand = Join-Path $fullDir ($it.id + $ext)
    if (Test-Path $cand) { $fp = $cand; break }
  }
  if (-not $fp) { $missing.Add($it.id) | Out-Null; continue }
  $h = (Get-FileHash -Algorithm MD5 -Path $fp).Hash
  if (-not $byHash.ContainsKey($h)) { $byHash[$h] = New-Object System.Collections.Generic.List[object] }
  $byHash[$h].Add($it) | Out-Null
}

$keep = New-Object System.Collections.Generic.List[object]
$dropIds = New-Object System.Collections.Generic.List[string]
foreach ($h in $byHash.Keys) {
  $group = @($byHash[$h] | Sort-Object `
    @{Expression={ if ($prio.ContainsKey($_.set)) { $prio[$_.set] } else { 99 } }}, `
    @{Expression='n'}, @{Expression='id'})
  $keep.Add($group[0]) | Out-Null
  for ($i=1; $i -lt $group.Count; $i++) { $dropIds.Add([string]$group[$i].id) | Out-Null }
}

# Also drop catalog rows with missing images
$keepIds = New-Object 'System.Collections.Generic.HashSet[string]'
foreach ($k in $keep) { [void]$keepIds.Add([string]$k.id) }
$data.items = @($keep | Sort-Object `
  @{Expression={ if ($prio.ContainsKey($_.set)) { $prio[$_.set] } else { 99 } }}, `
  @{Expression='n'}, @{Expression='id'})
$setIds = New-Object 'System.Collections.Generic.HashSet[string]'
foreach ($it in $data.items) { [void]$setIds.Add([string]$it.set) }
$data.sets = @($data.sets | Where-Object { $setIds.Contains([string]$_.id) })

function Write-IconJson($obj, $path) {
  $sb = New-Object System.Text.StringBuilder
  [void]$sb.AppendLine('{')
  [void]$sb.AppendLine('  "sets": [')
  $sets = @($obj.sets)
  for ($i=0; $i -lt $sets.Count; $i++) {
    $s = $sets[$i]
    $comma = if ($i -lt $sets.Count-1) { ',' } else { '' }
    $blurb = ([string]$s.blurb).Replace('\','\\').Replace('"','\"')
    $title = ([string]$s.title).Replace('\','\\').Replace('"','\"')
    [void]$sb.AppendLine(('    {{ "id": "{0}", "title": "{1}", "blurb": "{2}" }}{3}' -f $s.id, $title, $blurb, $comma))
  }
  [void]$sb.AppendLine('  ],')
  [void]$sb.AppendLine('  "items": [')
  $items = @($obj.items)
  for ($i=0; $i -lt $items.Count; $i++) {
    $it = $items[$i]
    $comma = if ($i -lt $items.Count-1) { ',' } else { '' }
    $label = ([string]$it.label).Replace('\','\\').Replace('"','\"')
    $setTitle = ([string]$it.setTitle).Replace('\','\\').Replace('"','\"')
    $file = ([string]$it.file).Replace('\','\\').Replace('"','\"')
    [void]$sb.AppendLine(('    {{ "id": "{0}", "set": "{1}", "setTitle": "{2}", "label": "{3}", "file": "{4}", "n": {5} }}{6}' -f `
      $it.id, $it.set, $setTitle, $label, $file, [int]$it.n, $comma))
  }
  [void]$sb.AppendLine('  ]')
  [void]$sb.AppendLine('}')
  $utf8 = New-Object System.Text.UTF8Encoding $false
  [System.IO.File]::WriteAllText($path, $sb.ToString(), $utf8)
}

Write-IconJson $data $itemsPath

foreach ($id in $dropIds) {
  foreach ($dir in @('full','thumbs')) {
    foreach ($ext in @('.jpg','.png','.webp','.jpeg')) {
      $p = Join-Path $Root (Join-Path $dir ($id + $ext))
      if (Test-Path $p) { Remove-Item $p -Force; $deletedFiles++ }
    }
  }
}

# Orphan sweep: files in full/thumbs whose basename is not a kept id and not needed
$kept = New-Object 'System.Collections.Generic.HashSet[string]'
foreach ($it in @($data.items)) { [void]$kept.Add([string]$it.id) }
foreach ($dir in @('full','thumbs')) {
  $d = Join-Path $Root $dir
  if (-not (Test-Path $d)) { continue }
  Get-ChildItem $d -File | ForEach-Object {
    if (-not $kept.Contains($_.BaseName)) {
      Remove-Item $_.FullName -Force
      $script:deletedFiles++
    }
  }
}

Write-Host ""
Write-Host "Done."
Write-Host ("Items: {0} -> {1}" -f $beforeItems, @($data.items).Count)
Write-Host ("Sets: {0}" -f (@($data.sets).Count))
Write-Host ("Byte-duplicate rows removed: {0}" -f $dropIds.Count)
Write-Host ("Image files deleted: {0}" -f $deletedFiles)
if ($missing.Count -gt 0) { Write-Host ("Missing images skipped: {0}" -f ($missing -join ', ')) }
if ($dropIds.Count -gt 0) { Write-Host ("Dropped ids: {0}" -f ($dropIds -join ', ')) }
Write-Host ""
Write-Host "Refresh the picker. Then commit + push in GitHub Desktop."
