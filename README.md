# NeoSander sponge head

A HOZO NeoSander head that holds a piece of Stedi 5 mm wet-and-dry sanding sponge (strip 80 × 20 × 5 mm).

- **Plug:** HOZO's own geometry, imported unchanged from their open-source Flat Sanding Head ×5
  ([MakerWorld](https://makerworld.com/en/models/2802755-hozo-neosander-flat-sanding-head-x5), head 3), cut at the
  paddle neck. HOZO's files aren't in this repo: download the 3MF from MakerWorld into `hozo/`, then run
  `python3 hozo/3mf_to_stl.py <extracted>/3D/Objects/object_3.model hozo/hozo_flat_head_3.stl` (unzip the 3MF first).
  The STLs in `stl/` are ready to print without it.
- **Pad:** cut the sponge into 26 × 20 × 5 mm pieces (three per strip). The pocket is 2.2 mm deep, so about
  2.8 mm stands proud. The foam is held by friction; push a worn piece out through the 4 mm hole in the back.
  Double-sided tape is the fallback.
- **Squeeze test variants** (`stl/sponge_head_26_fit*.stl`): the pocket is undersized by `fit` in both length and
  width. Each variant has its `fit` value engraved on the flat back. Too much squeeze makes the foam bulge.

  | Engraved | Pocket (mm) | Squeeze per side |
  |---|---|---|
  | `0`   | 26.0 × 20.0 | none (tape) |
  | `0.2` | 25.8 × 19.8 | 0.1 |
  | `0.4` | 25.6 × 19.6 | 0.2 |
  | `0.6` | 25.4 × 19.4 | 0.3 |

  About 1.7 g each. HOZO's own paddle weighs 1.2 g and they warn against heavy heads. `pad_len=40` (two pieces per
  strip, 2.2 g) is available if the 26 feels too small.
- **Cutting jig** (`stl/cut_jig_26.stl`, source `cut_jig.scad`): slide the strip in until it hits the stop, then
  run a snap-off knife down the slot with the blade against the face nearest the stop. That face is exactly 26 mm
  from the stop. Push the strip up to the stop and repeat. One strip gives three pieces. The slot is 1 mm wide, and
  the 14 mm walls keep the blade vertical so the cut is square.
- **Print:** as exported, flat face down, no supports. Same orientation as HOZO's 3MF. PETG, 5 walls, like HOZO's
  profile.

Print plate (jig + four heads): `print/neosander_test_plate.3mf`, from `print/plate.scad`. Black PETG HF,
0.16 mm Optimal, 44 min, 14 g.

Rebuild: `openscad -o stl/sponge_head_26_fit0.4.stl -D pad_len=26 -D fit=0.4 sponge_head.scad`. All parameters are at the top of
`sponge_head.scad`.

Status (2026-11-24): designed, not printed. Four squeeze variants ready to test; plug fit and grip untested.
