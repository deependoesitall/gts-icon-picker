# GTS Imagine work — towboat badge + favicons

**Where:** `C:\Users\Deepa\Documents\gts-icon-picker\TOWBOAT-PROMPTS.md`  
**Refs to attach:** your new circular badge / clay badge / lockups (the ones you remade).  
**Picker:** `index.html` filters **Cargoship** (everything already in the gallery) vs **Towboat** (new gens with `"family": "towboat"`).

---

## Index

| Section | What |
|---|---|
| Master rules | Paste above almost every app-icon variation |
| A Live rings | Staff / Sinclair shop / customer |
| B Colorways | Same badge, solid field colors |
| C Lighthouse heroes | Grafton lighthouse + big US flag |
| D Clay colorways | Jen 3D clay spruce master → field colors |
| E Lockups | Wordmark + badge |
| **F Favicons (production)** | **Remake site/app favicons — towboat, GTS green + Sinclair red** |
| After generate | File naming + picker tags |

---

## Master rules (app icons in the picker)

```
Square 1:1 mobile app icon. Use the attached GTS circular badge as the hero emblem: inland river PUSHBOAT / towboat (flat bow, push knees), white decks, blue trim, black hull, stylized sunset/sun behind the boat, ornate gold/orange circular nautical frame. Match that badge’s graphic / vector-badge look OR the clay 3D treatment when the variation asks for clay — stay consistent within a set. No readable company name text on the icon unless the variation is a lockup. No cargo container ship.
```

---

## A) Live / ring badges (staff, shop, customer)

```
[MASTER RULES]
App icon with the GTS towboat circular badge centered. Add a thick outer ring: {RING}. Soft product-shot lighting, homescreen-ready, square.
```

- `tb-live-01` — `{RING}` = split spruce green / gold ring (GTS staff)
- `tb-live-02` — `{RING}` = Sinclair red / yellow ring (shop)
- `tb-live-03` — `{RING}` = lime field behind the badge (customer)

---

## B) Colorways (field only)

```
[MASTER RULES]
Same towboat circular badge as the attached logo, centered. Solid {FIELD} background field only (no extra scenery). Square app icon, clean margins.
```

Fields: spruce, lime, forest, teal, gold, teal-gold gradient, cream, navy, olive, sage, white, yellow, turquoise, charcoal, mint, emerald, gold-sun green, cream-sun green, sky blue, green-lime gradient.

---

## C) Hero / lighthouse treatments

```
[MASTER RULES]
Same towboat badge language, but compose as a full scene inside a rounded-square app icon: towboat on water, famous Grafton IL riverside lighthouse, and a massive American flag on a tall separate flagpole (site-accurate), {SKY}. Keep the badge’s boat design language (not a different vessel).
```

Vary `{SKY}`: spruce blue, golden hour, forest sunset, teal tropic, navy twilight, cream quiet, etc.

---

## D) Clay colorways (Jen’s 3D clay)

```
3D clay / claymorphism app icon, square. Recreate the attached clay towboat badge: multi-deck inland pushboat, sculpted blue waves, orange sun + clay clouds, circular emblem on a {FIELD} rounded-square field. Soft matte clay, rounded forms, no sharp CGI. No cargo ship. No text.
```

Fields: lime, forest, teal, gold, cream, navy, Sinclair red, Sinclair yellow (keep boat white/blue/black).

---

## E) Lockups (optional)

```
Use the attached horizontal / stacked Grafton Towboat Services lockup as reference. Black background, gold wordmark, circular towboat badge. Do not invent a different boat.
```

---

## F) Favicons — remake production icons (towboat, not cargoship)

**Goal:** Replace the live favicons / PWA icons that still use the **cargo ship** with the **new towboat badge**. Two brand variants for the two apps.

Attach: circular towboat badge (vector or clay — pick one master and stick to it for both favicons so they feel like a pair).

### F1 — GTS admin / main (green)

**Suggested filenames:** `favicon-gts.png`, `admin-icon.png`, `apple-touch-gts.png` (export 32 / 180 / 512 as needed later)

```
Square favicon / PWA app icon, 1:1, flat and readable at small sizes. Replace any cargo container ship with the attached inland river PUSHBOAT / towboat badge (flat bow, push knees, white decks, blue trim, black hull). Brand this as Grafton Towboat Services: spruce / forest GREEN field or green ring (GTS green, not Sinclair red). Keep the circular badge / porthole frame if it still reads at 32px; simplify tiny details so the boat silhouette stays clear. No text, no cargo ship, no Sinclair red/yellow.
```

### F2 — Sinclair’s shop / fulfill (red)

**Suggested filenames:** `favicon-sinclair.png`, `shop-icon.png`, `apple-touch-sinclair.png`

```
Square favicon / PWA app icon, 1:1, flat and readable at small sizes. Same inland river PUSHBOAT / towboat as the attached GTS badge (not a cargo ship) — identical boat design language to the GTS green favicon so they are a matched pair. Brand this as Sinclair’s: RED / yellow ring or red field (Sinclair red), not GTS green. Circular badge frame OK if it stays crisp small. No text, no cargo ship.
```

### F3 — Matched pair checklist

- Same towboat silhouette in both  
- Only the **ring / field color** changes (green vs red)  
- Export masters at 1024×1024, then down to 512 / 180 / 32  
- Drop into the ordering app as the live admin + shop icons (separate from the picker gallery)

---

## After you generate (picker gallery)

1. Save as `full/tb-....jpg` and `thumbs/tb-....jpg` (same id).
2. Add to `items.json` with `"family": "towboat"`.
3. Picker **Towboat** filter shows them; **Cargoship** keeps the old gallery.

Favicons (section F) go into the **main GTS app** branding paths — not required in the picker unless you want Jen to heart them too (`family: towboat`, set `live`).

## Soft3D package import (2026-09-11)
Imported `Downloads\GTS_Soft3D_AppIcons_Full_Package` into the picker as `family: towboat`:
- soft3d-colorways (01�20)
- soft3d-gts-admin
- soft3d-sinclair-admin
- soft3d-base (00_* badges)
Existing icons remain `family: cargoship`. Filter chips: All / Cargoship / Towboat.
