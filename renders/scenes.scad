// Render scenes for the README. Driven by render.sh: openscad -D 'scene="hero"' scenes.scad
scene = "hero";

HEAD = "../stl/sponge_head_26_fit0.2.stl";
JIG  = "../stl/cut_jig_26.stl";
fit  = 0.2;

// colours
C_PART = "#2b6cb0"; C_FOAM = "#f2d21b"; C_RED = "#d62828";

// ---- head (print frame: sanding face up, pocket floor at z = 1.0) ----
pocket_x0 = -5 - 0.8 - (26 - fit);
module head(alpha = 1) color(C_PART, alpha) import(HEAD);
module sponge(lift = 0) color(C_FOAM)
  translate([pocket_x0, -(20 - fit)/2, 1.0 + lift]) cube([26 - fit, 20 - fit, 5]);

// ---- jig ----
xs = 29;   // slot face nearest the stop
module jig(alpha = 1) color(C_PART, alpha) import(JIG);
module strip(x = 3) color(C_FOAM) translate([x, 3.2, 2]) cube([80, 20, 5]);

module arrow(from, to, d = 2.4) {
  v = to - from; l = norm(v);
  color(C_RED) translate(from)
    rotate([0, acos(v[2]/l), atan2(v[1], v[0])]) {
      cylinder(d = d, h = l - 6, $fn = 24);
      translate([0, 0, l - 6]) cylinder(d1 = 2.6*d, d2 = 0, h = 6, $fn = 24);
    }
}

// snap-off knife, blade in the slot plane, slanted a degrees, tip at (ty, 1.2)
module yz(x0, th) multmatrix([[0,0,1,x0],[1,0,0,0],[0,1,0,0]]) linear_extrude(th) children();
module knife(ty, alpha = 1, a = 35, L = 24, w = 9) {
  c = cos(a); s = sin(a);
  function P(t, v) = [ty + t*c - v*s, 1.2 + t*s + v*c];
  color("#555b63") yz(xs, 0.5) polygon([P(0,0), P(L,0), P(L,w), P(6,w)]);
  color("#e8731a", alpha) yz(xs - 3, 6.5) polygon([P(L,-2), P(L+30,-2), P(L+30,w+2), P(L,w+2)]);
}
module label(t, size = 4.5, col = "#333") color(col)
  linear_extrude(0.5) text(t, size = size, halign = "center", valign = "center", font = "Liberation Sans:style=Bold");

if (scene == "hero")     { head(); sponge(); }
if (scene == "bare")     head();
if (scene == "press")    { head(); sponge(14); arrow([pocket_x0 + 13, 0, 32], [pocket_x0 + 13, 0, 21]); }
if (scene == "pushout")  { head(0.55); sponge(3); arrow([pocket_x0 + 13, 0, -16], [pocket_x0 + 13, 0, 2.5], 2); }
if (scene == "back")     projection(cut = true) translate([0, 0, 0.2]) rotate([180, 0, 0]) head();
if (scene == "jig")      { jig(); strip(); }
if (scene == "jig_bare") jig();
if (scene == "jig1")     { jig(); strip(45); arrow([140, 13.2, 14], [105, 13.2, 14]); }
if (scene == "jig2")     { jig(0.5); strip(); knife(6); arrow([xs + 6, -6, 24], [xs + 6, 22, 24]); }
if (scene == "jig3") {
  jig(0.5); strip(); knife(10, 0.3);
  color(C_RED) {
    arrow([16, -7, 15], [3, -7, 15], 1.2); arrow([16, -7, 15], [29, -7, 15], 1.2);
    for (x = [3, 29]) translate([x - 0.3, -10, 15]) cube([0.6, 9, 0.5]);
  }
  translate([16, -15, 15]) label("26 mm", col = "#a4161a");
  translate([-12, 13.2, 15]) label("stop");
}
