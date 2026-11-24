// Print plate: cutting jig + sponge head. Export with
//   openscad -O export-3mf/color-mode=none -o print/neosander_plate.3mf print/plate.scad
import("../stl/sponge_head.stl");
translate([30, -12, 0]) import("../stl/cut_jig.stl");
