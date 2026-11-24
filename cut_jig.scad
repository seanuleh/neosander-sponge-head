// Cutting jig for Stedi sponge strips (80 x 20 x 5 mm): every piece the same length and square.
//
// Slide the strip in from the open end until it hits the stop. Run a snap-off knife down the slot,
// keeping the blade against the slot face nearest the stop. That face is exactly piece_len from the
// stop. Lift the piece out, push the strip up to the stop again, repeat. An 80 mm strip gives three.
//
//   openscad -o stl/cut_jig_26.stl cut_jig.scad
//
// Prints floor-down, no supports.

piece_len = 26;     // match pad_len in sponge_head.scad
strip_w   = 20;
clear     = 0.4;    // channel width over the strip: slides freely, no wander
wall      = 3;
wall_h    = 14;     // tall walls guide the blade vertical, so the cut is square
floor_t   = 2;
stop_t    = 3;
slot_w    = 1.0;    // 18 mm snap-off blades are 0.5 mm, 9 mm ones 0.38 mm
groove_d  = 1.0;    // groove in the floor under the slot so the blade cuts right through
run_out   = 30;     // channel past the slot that supports the rest of the strip
label_d   = 0.6;

cw  = strip_w + clear;           // channel width
L   = stop_t + piece_len + slot_w + run_out;
W   = cw + 2*wall;
xs  = stop_t + piece_len;        // slot face nearest the stop

difference() {
  cube([L, W, wall_h]);
  // channel, open at the far end and on top
  translate([stop_t, wall, floor_t]) cube([L, cw, wall_h]);
  // knife slot through both walls, down to the floor groove
  translate([xs, -1, floor_t - groove_d]) cube([slot_w, W + 2, wall_h]);
  // length label on the outside of one wall
  translate([stop_t + piece_len/2, label_d, wall_h/2]) rotate([90, 0, 0])
    linear_extrude(label_d + 1)
      text(str(piece_len), size = 6, font = "Liberation Sans:style=Bold", halign = "center", valign = "center");
}
