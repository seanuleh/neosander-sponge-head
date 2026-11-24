// Print plate: cutting jig + four squeeze-test heads. Export with
//   openscad -O export-3mf/color-mode=none -o print/neosander_test_plate.3mf print/plate.scad
fits = ["0", "0.2", "0.4", "0.6"];
for (i = [0:3]) translate([0, i*26, 0]) import(str("../stl/sponge_head_26_fit", fits[i], ".stl"));
translate([30, -12, 0]) import("../stl/cut_jig_26.stl");
