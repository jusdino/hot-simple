e = 0.01;
dark_gray = [0.2, 0.2, 0.2];


box_size_4010 = 40;
box_depth_4010 = 10;

module fan_4010() {
  fan_hole_dia = box_size_4010 - 2;

  screw_hole_inner_dia = 3.6;
  screw_hole_outer_dia = 5.9;
  screw_hole_outer_depth = 3;
  screw_hole_inset = 4;

  support_width = 3;
  support_depth = 2;

  fan_cyl_dia = 25;

  color(dark_gray) {
    difference() {
      // main cube
      translate([-box_size_4010/2, -box_size_4010/2, 0]) {
        cube([box_size_4010, box_size_4010, box_depth_4010]);
      }
      // fan hole
      translate([0, 0, -e]) {
        cylinder(h=box_depth_4010+2*e, d=fan_hole_dia);
      }
      for (i = [0:3]) {
        rotate(i*90) {
          translate([box_size_4010/2 - screw_hole_inset, box_size_4010/2 - screw_hole_inset, -e]) {
            // screw holes
            cylinder(h=box_depth_4010+2*e, d=screw_hole_inner_dia);
            cylinder(h=screw_hole_outer_depth, d=screw_hole_outer_dia);
            // round corners
            difference() {
              cube([screw_hole_inset+e, screw_hole_inset+e, box_depth_4010+2*e]);
              translate([0, 0, -e]) {
                cylinder(h=box_depth_4010+4*e, r=screw_hole_inset);
              }
            }
          }
        }
      }
    }
    // fan supports
    for (i = [0:2]) {
      rotate(i*120) {
        translate([-support_width/2, 0, box_depth_4010-support_depth]) {
          cube([support_width, fan_hole_dia/2, support_depth]);
        }
      }
    }
    // fan cylinder
    cylinder(h=box_depth_4010, d=fan_cyl_dia);
  }
}
