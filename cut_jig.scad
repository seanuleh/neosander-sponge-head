// Cutting jig for Stedi sponge strips (80 x 20 x 5 mm): every piece the same length and square.
//
// A mitre box. The strip slides along a low channel into the stop. A guide block bridges the channel
// at the cut, with the knife slot through it, so the blade is held for the whole stroke, not just
// where it passes through the side walls. The block's underside sits just above the foam and holds
// it flat while cutting.
//
// Use: push the strip to the stop. Put the blade in the slot, slanted like a normal cut, and pull it
// toward you across the strip, keeping it against the slot face nearest the stop (exactly piece_len
// from the stop). Slide the piece out, push the strip up to the stop, repeat. Three pieces per strip.
//
//   openscad -o stl/cut_jig_26.stl cut_jig.scad
//
// Prints floor-down, no supports: the guide block's underside is a 20.4 mm bridge, split by the slot.
// One piece on purpose: slot, wall slots, floor groove and stop stay aligned; a bolt-on guide would add slop.

piece_len  = 26;    // match pad_len in sponge_head.scad
strip_w    = 20;
strip_t    = 5;
clear      = 0.4;   // channel width over the strip: slides freely, no wander
head_clear = 1.0;   // gap between the foam and the guide block's underside (room for bridge sag)
wall       = 3;
floor_t    = 2;
stop_t     = 3;
slot_w     = 0.8;   // 18 mm snap-off blades are 0.5 mm, 9 mm ones 0.38 mm; printed slots come out a bit narrow
groove_d   = 1.0;   // groove in the floor under the slot so the blade cuts right through
guide_h    = 6;     // guide block height above the channel: the depth of slot that holds the blade
guide_near = 4;     // block on the stop side of the slot (short so the cut piece slides out)
guide_far  = 10;    // block on the far side of the slot
run_out    = 30;    // channel past the slot that supports the rest of the strip
label_d    = 0.6;
lead_in    = 0.8;   // chamfer at the top of the slot so the blade drops in
entry_ch   = 1.5;   // chamfer under the block where the strip enters, so foam doesn't catch

cw  = strip_w + clear;                 // channel width
ch  = strip_t + head_clear;            // channel height
L   = stop_t + piece_len + slot_w + run_out;
W   = cw + 2*wall;
xs  = stop_t + piece_len;              // slot face nearest the stop
zt  = floor_t + ch;                    // top of the walls / underside of the guide block
gx0 = xs - guide_near;
gx1 = xs + slot_w + guide_far;

difference() {
  union() {
    cube([L, W, zt]);
    translate([gx0, 0, 0]) cube([gx1 - gx0, W, zt + guide_h]);
  }
  // channel, open at the far end; open on top except under the guide block
  translate([stop_t, wall, floor_t]) cube([L, cw, ch]);
  translate([stop_t, wall, floor_t]) cube([gx0 - stop_t, cw, ch + guide_h + 1]);
  translate([gx1, wall, floor_t]) cube([L, cw, ch + guide_h + 1]);
  // knife slot: through the guide block and both walls, down into the floor groove
  translate([xs, -1, floor_t - groove_d]) cube([slot_w, W + 2, zt + guide_h + 1]);
  // length label on the outside of the guide block, beside the slot (the 14 mm tall face)
  translate([(xs + slot_w + gx1)/2, label_d, (zt + guide_h)/2]) rotate([90, 0, 0])
    linear_extrude(label_d + 1)
      text(str(piece_len), size = 5, font = "Liberation Sans:style=Bold", halign = "center", valign = "center");
  // slot lead-in: a small V at the top of the guide block
  ztop = zt + guide_h;
  translate([0, -1, 0]) rotate([-90, 0, 0]) linear_extrude(W + 2)
    polygon([[xs - lead_in, -ztop - 0.01], [xs + slot_w + lead_in, -ztop - 0.01],
             [xs + slot_w, -(ztop - lead_in)], [xs, -(ztop - lead_in)]]);
  // entry chamfer under the far edge of the block, across the channel only
  translate([0, wall, 0]) rotate([-90, 0, 0]) linear_extrude(cw)
    polygon([[gx1 + 0.01, -(zt - 0.01)], [gx1 - entry_ch, -(zt - 0.01)], [gx1 + 0.01, -(zt + entry_ch)]]);
}
