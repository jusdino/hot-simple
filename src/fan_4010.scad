e = 0.01;
DARK_GRAY = [0.2, 0.2, 0.2];


BOX_SIZE_4010 = 40;
BOX_DEPTH_4010 = 10;

module fan_4010() {
  FAN_HOLE_DIA = BOX_SIZE_4010 - 2;

  SCREW_HOLE_INNER_DIA = 3.6;
  SCREW_HOLE_OUTER_DIA = 5.9;
  SCREW_HOLE_OUTER_DEPTH = 3;
  SCREW_HOLE_INSET = 4;

  SUPPORT_WIDTH = 3;
  SUPPORT_DEPTH = 2;

  FAN_CYL_DIA = 25;

  color(DARK_GRAY) {
    difference() {
      // Main cube
      translate([-BOX_SIZE_4010/2, -BOX_SIZE_4010/2, 0]) {
        cube([BOX_SIZE_4010, BOX_SIZE_4010, BOX_DEPTH_4010]);
      }
      // Fan hole
      translate([0, 0, -e]) {
        cylinder(h=BOX_DEPTH_4010+2*e, d=FAN_HOLE_DIA);
      }
      for (i = [0:3]) {
        rotate(i*90) {
          translate([BOX_SIZE_4010/2 - SCREW_HOLE_INSET, BOX_SIZE_4010/2 - SCREW_HOLE_INSET, -e]) {
            // Screw holes
            cylinder(h=BOX_DEPTH_4010+2*e, d=SCREW_HOLE_INNER_DIA);
            cylinder(h=SCREW_HOLE_OUTER_DEPTH, d=SCREW_HOLE_OUTER_DIA);
            // Round corners
            difference() {
              cube([SCREW_HOLE_INSET+e, SCREW_HOLE_INSET+e, BOX_DEPTH_4010+2*e]);
              translate([0, 0, -e]) {
                cylinder(h=BOX_DEPTH_4010+4*e, r=SCREW_HOLE_INSET);
              }
            }
          }
        }
      }
    }
    // Fan supports
    for (i = [0:2]) {
      rotate(i*120) {
        translate([-SUPPORT_WIDTH/2, 0, BOX_DEPTH_4010-SUPPORT_DEPTH]) {
          cube([SUPPORT_WIDTH, FAN_HOLE_DIA/2, SUPPORT_DEPTH]);
        }
      }
    }
    // Fan Cylinder
    cylinder(h=BOX_DEPTH_4010, d=FAN_CYL_DIA);
  }
}
