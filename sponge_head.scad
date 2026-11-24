// HOZO NeoSander head for Stedi 5 mm sanding sponges (strip 80 x 20 x 5 mm, cut to length).
//
// The plug (latch block + shaft + peg) is HOZO's own geometry, imported unchanged from their
// open-source Flat Sanding Head (head 3, the 12.4 mm paddle) and cut at x = 0 where the paddle neck
// starts. Only the part beyond the cut is new: a shallow tray that the sponge presses into.
//
// HOZO frame: x = shaft axis (plug at +x, pad at -x), y = through the pad (sanding face toward -y,
// same side as the peg), z = pad width. y = 3.17 is the flat face HOZO prints on the bed; the tray
// floor sits in that same plane, so the whole head prints flat with no supports.
//
//   openscad -o stl/sponge_head.stl sponge_head.scad

pad_len    = 26;    // nominal sponge piece length (the jig cuts 26.3, which still fits: it bows a little)
sponge_w   = 20;    // measured strip width
fit        = 0.2;   // pocket undersize per side-pair: foam squeezes in and holds
depth      = 2.2;   // pocket depth; 5 mm sponge stands ~2.8 mm proud
floor_t    = 1.0;
wall       = 0.8;   // two 0.4 mm lines
taper      = 5;     // neck length from the HOZO cut to the tray
push_hole  = 4;     // through-hole in the floor to push a worn sponge out (0 = none)
peg_grow   = 0.6;   // locking peg diameter added to HOZO's 3.0 mm, so it seats snugly in the tool's detent

y_bed  = 3.17;                 // HOZO bed face
y_top  = y_bed - floor_t - depth;
pw     = sponge_w - fit;       // pocket width  (z)
pl     = pad_len - fit;        // pocket length (x)
tw     = pw + 2*wall;          // tray width
tl     = pl + 2*wall;          // tray length
x0     = -taper;               // tray end nearest the plug
eps    = 0.01;

module hozo_plug()
  intersection() {
    import("hozo/hozo_flat_head_3.stl", convexity = 6);
    translate([0, -10, -10]) cube([30, 20, 20]);
  }

// HOZO's round locking peg (d 3.0, centre x 15.75, tip y -3.17) is slightly small in the tool, so the head
// rocks out of the detent. Widen it: same height, same centre, chamfered back to HOZO's tip diameter.
peg_x = 15.75;
peg_tip = -3.17;
module peg_widen()
  translate([peg_x, 0, 0]) rotate([90, 0, 0]) hull() {
    translate([0, 0, 1.2]) cylinder(d = 3 + peg_grow, h = -peg_tip - 1.2 - 0.3, $fn = 64);
    translate([0, 0, -peg_tip - 0.3 - eps]) cylinder(d1 = 3 + peg_grow, d2 = 3.0, h = 0.3, $fn = 64);
  }

// box in HOZO coords: x from xa to xb, y from ya to yb, z centred, width w
module slab(xa, xb, ya, yb, w)
  translate([xa, ya, -w/2]) cube([xb - xa, yb - ya, w]);

module tray()
  difference() {
    slab(x0 - tl, x0, y_top, y_bed, tw);
    slab(x0 - tl + wall, x0 - wall, y_top - 1, y_bed - floor_t, pw);   // sponge pocket
    if (push_hole > 0)
      translate([x0 - tl/2, y_bed + 1, 0]) rotate([90, 0, 0])
        cylinder(d = push_hole, h = floor_t + 2, $fn = 32);
  }

// neck: HOZO's neck section at the cut (z +-1.88, y -1.17..3.17) blended into the tray's back wall
module neck()
  hull() {
    slab(-eps, 0.3, -1.17, y_bed, 3.76);
    slab(x0 - wall, x0, y_top, y_bed, tw);
  }

module head() union() { hozo_plug(); peg_widen(); neck(); tray(); }

// print orientation, same as HOZO's 3MF: y_bed face down on z = 0
rotate([-90, 0, 0]) translate([0, -y_bed, 0]) head();
