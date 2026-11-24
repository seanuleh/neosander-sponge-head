#!/usr/bin/env bash
# Regenerate every README image from the STLs. Needs OpenSCAD and Python 3 with Pillow.
set -euo pipefail
cd "$(dirname "$0")"
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
r() { # name scene camera [extra openscad args...]
  local name=$1 scene=$2 cam=$3; shift 3
  openscad -q -o "$name" --imgsize=900,650 --camera="$cam" --colorscheme=Tomorrow -D "scene=\"$scene\"" "$@" scenes.scad 2>/dev/null
}
r hero.png     hero     -8,0,3,55,0,28,125
r jig.png      jig      45,13,6,55,0,320,150
r "$tmp/p1.png" press    -14,0,10,62,0,32,120
r "$tmp/p2.png" pushout  -14,0,-2,118,0,32,120
r "$tmp/j1.png" jig1     55,13,5,60,0,300,230
r "$tmp/j2.png" jig2     30,12,10,58,0,290,170
r "$tmp/j3.png" jig3     33,8,0,0,0,0,200 --projection=o
python3 compose.py head_howto.png \
  "$tmp/p1.png" "1  Press the sponge in" "Grit side up. It's a light press fit into a 2.2 mm pocket; about 2.8 mm stands proud." \
  "$tmp/p2.png" "2  Push it out to swap" "When the grit wears out, push the sponge out with a pen through the hole in the back."
python3 compose.py cut_jig_howto.png \
  "$tmp/j1.png" "1  Slide the strip in" "Feed it under the guide block and push it until it touches the closed end (the stop)." \
  "$tmp/j2.png" "2  Knife in the slot, slanted" "Hold the knife at a normal cutting angle with the blade down in the slot. Pull it toward you across the strip. The guide block holds the blade straight the whole way." \
  "$tmp/j3.png" "3  Seen from above" "Slot is 26.3 mm from the stop. Blade against the stop side. Cut, remove, re-insert, cut again: the offcut is the third piece."
openscad -q -o plate.png --imgsize=1000,650 --camera=22,32,0,45,0,15,290 --colorscheme=Tomorrow ../print/plate.scad 2>/dev/null
echo "renders updated"
