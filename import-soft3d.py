import json, re, shutil
from pathlib import Path
from PIL import Image

SRC = Path(r"C:\Users\Deepa\Downloads\GTS_Soft3D_AppIcons_Full_Package")
PICKER = Path(r"C:\Users\Deepa\Documents\gts-icon-picker")
FULL = PICKER / "full"
THUMBS = PICKER / "thumbs"
FULL.mkdir(exist_ok=True)
THUMBS.mkdir(exist_ok=True)

def slug(name: str) -> str:
    stem = Path(name).stem
    s = re.sub(r"[^a-zA-Z0-9]+", "-", stem).strip("-").lower()
    return s

def classify(name: str):
    n = name.lower()
    if n.startswith("sinclair_admin"):
        return "soft3d-sinclair-admin", "Soft3D Sinclair admin"
    if n.startswith("gts_admin"):
        return "soft3d-gts-admin", "Soft3D GTS admin"
    if n.startswith("00_"):
        return "soft3d-base", "Soft3D base badges"
    # numbered colorways 01_–20_
    if re.match(r"^\d{2}_", name):
        return "soft3d-colorways", "Soft3D colorways"
    return "soft3d-other", "Soft3D other"

data = json.loads((PICKER / "items.json").read_text(encoding="utf-8"))
# ensure cargoship family
for it in data["items"]:
    it.setdefault("family", "cargoship")

# drop prior soft3d towboat entries so re-run is clean
data["items"] = [it for it in data["items"] if not str(it.get("id","")).startswith("tb-soft3d-")]
data["sets"] = [s for s in data.get("sets", []) if not str(s.get("id","")).startswith("soft3d-")]

set_meta = {}
new_items = []
n = 0
files = sorted([p for p in SRC.iterdir() if p.suffix.lower() in {".jpg", ".jpeg", ".png"} and p.is_file()])
for p in files:
    set_id, set_title = classify(p.name)
    set_meta[set_id] = set_title
    sid = f"tb-soft3d-{slug(p.name)}"
    ext = ".jpg"
    dest_name = sid + ext
    # load, convert to RGB jpeg full + thumb
    im = Image.open(p).convert("RGB")
    # full: max edge 1024 to keep picker light
    full_im = im.copy()
    full_im.thumbnail((1024, 1024), Image.Resampling.LANCZOS)
    full_im.save(FULL / dest_name, "JPEG", quality=90, optimize=True)
    thumb = im.copy()
    thumb.thumbnail((320, 320), Image.Resampling.LANCZOS)
    thumb.save(THUMBS / dest_name, "JPEG", quality=82, optimize=True)
    n += 1
    label = Path(p.name).stem.replace("_", " ")
    new_items.append({
        "id": sid,
        "set": set_id,
        "setTitle": set_title,
        "label": label,
        "file": dest_name,
        "n": n,
        "family": "towboat",
    })

# renumber n within each set
from collections import defaultdict
by_set = defaultdict(list)
for it in new_items:
    by_set[it["set"]].append(it)
final = []
for sid, rows in by_set.items():
    for i, it in enumerate(rows, 1):
        it["n"] = i
        final.append(it)

for sid, title in set_meta.items():
    data["sets"].append({
        "id": sid,
        "title": title,
        "blurb": "New Soft3D towboat badge variants from the full package.",
    })

data["items"].extend(final)
(PICKER / "items.json").write_text(json.dumps(data, indent=2), encoding="utf-8")
cargoship = sum(1 for it in data["items"] if it.get("family")=="cargoship")
towboat = sum(1 for it in data["items"] if it.get("family")=="towboat")
print(f"done files={len(files)} cargoship={cargoship} towboat={towboat} sets={len(data['sets'])}")
