include <functions.scad>;
include <nutsnbolts/cyl_head_bolt.scad>;
include <e3d_clamp.scad>;
include <gantry_plate.scad>;
include <connectors.scad>;


module accessory_backing(left_connector_coords) {
  e = 0.01;
  hole_2_to_1_vec2 = [hole_1_coords[0]-hole_2_coords[0], hole_1_coords[1]-hole_2_coords[1]];
  clamp_gap = 0.5;
  saddle_diff = [saddle_dx+2*clamp_gap, saddle_dy+2*clamp_gap, saddle_dz+clamp_gap+2*e];
  saddle_diff_coords = [saddle_x-saddle_diff[0]/2, saddle_y-saddle_dy-clamp_gap/2, saddle_z];

  clamp_arm_thickness = 5;
  clamp_arm_dia = saddle_dx+clamp_arm_thickness;

  color("teal") difference() {
    union() {
      screw_hole_strap();
      left_arm();
      right_arm();
      top_bar();
      u_band();
      left_connector(left_connector_coords);
    }
    // saddle subtraction from whole arm
    translate(saddle_diff_coords) {
      translate([0, 0, -e]) {
        cube(saddle_diff);
      }
    }
    translate([0, 0, strap_thickness]) {
      translate(hole_2_coords) {
        m3_screw_hole();
      }
      translate(hole_1_coords) {
        m3_screw_hole();
      }
    }
  }

  strap_thickness = 3.0;
  module screw_hole_strap() {

    hull() {
      translate(hole_1_coords) {
        screw_hole_strap_end();
      }
      translate(hole_2_coords) {
        screw_hole_strap_end();
      }
    }
  }

  module screw_hole_strap_end() {
    strap_base_dia = 10;
    strap_top_dia = 8;
    cylinder(h=strap_thickness, d1=strap_base_dia, d2=strap_top_dia);
  }

  module left_connector(left_connector_coords) {
    part_gap = 0.1;
    connector_dz = 7.5;
    backing_thickness = 1;
    difference() {
      union() {
        hull() {
          translate(hole_1_coords) {
            screw_hole_strap_end();
          }
          translate(left_connector_coords) {
            translate([0, -pin_dy, 0]) {
              pin_slot_profile(length=4);
            }
          }
        }
        translate(left_connector_coords) {
          translate([0, -pin_dy, 0]) {
            pin_slot_profile(length=connector_dz+backing_thickness+part_gap);
          }
        }
      }
      translate(left_connector_coords) {
        translate([0, 0, connector_dz+backing_thickness+part_gap+e]) {
          rotate([180, 0, 0]) {
            pin_tab(length=connector_dz);
          }
        }
      }
    }
  }

  module left_arm() {
    hull() {
      translate(hole_2_coords) {
        screw_hole_strap_end();
      }
      translate(saddle_diff_coords) {
        translate([-(clamp_arm_thickness/2-clamp_gap), saddle_diff[1]-(clamp_arm_thickness/2+clamp_gap), 0]) {
          // left arm
          cube([clamp_arm_thickness, clamp_arm_thickness, saddle_dz]);
        }
      }
    }
  }

  module right_arm() {
    back_bar_length = 25;
    translate(saddle_diff_coords) {
      translate([saddle_diff[0]-(clamp_arm_thickness/2+clamp_gap), saddle_diff[1]-(clamp_arm_thickness/2+clamp_gap), -plate_thickness-clamp_arm_thickness/2]) {
        difference() {
          cube([clamp_arm_thickness, clamp_arm_thickness, saddle_dz+plate_thickness+clamp_arm_thickness/2]);
          translate([-e, -e, -e]) {
            cube([clamp_arm_thickness/2+clamp_gap+e, clamp_arm_thickness+2*e, plate_thickness+clamp_arm_thickness/2+e]);
          }
        }
        translate([0, -(back_bar_length-clamp_arm_thickness), 0]) {
          difference() {
            cube([clamp_arm_thickness, back_bar_length, clamp_arm_thickness+plate_thickness]);
            translate([-e, -e, clamp_arm_thickness-plate_thickness]) {
              cube([clamp_arm_thickness/2+clamp_gap+e, back_bar_length+2*e, plate_thickness+e]);
            }
          }
        }
      }
    }
  }

  module top_bar() {
    translate(saddle_diff_coords) {
      translate([-(clamp_arm_thickness/2-clamp_gap), saddle_diff[1]-(clamp_arm_thickness/2+clamp_gap), 2]) {
        cube([saddle_dx+clamp_arm_thickness, clamp_arm_thickness, clamp_arm_thickness]);
      }
    }
  }

  module u_band() {
    translate([saddle_x, saddle_y+clamp_arm_thickness/2 + clamp_gap/2, e3d_z]) {
      difference() {
        rotate([90, 0, 0]) {
          difference() {
            // band around u
            cylinder(h=clamp_arm_thickness, d=saddle_dx+clamp_arm_thickness);
            translate([0, 0, -e]) {
              cylinder(h=clamp_arm_thickness/2-clamp_gap+2*e, d=saddle_dx-clamp_arm_thickness);
            }
            translate([0, 0, clamp_arm_thickness/2-clamp_gap]) {
              cylinder(h=clamp_arm_thickness/2+clamp_gap+e, d=saddle_dx+2*clamp_gap);
            }
          }
        }
        // saddle subtraction from u band
        translate([-(saddle_dx/2+clamp_arm_thickness/2+e), -clamp_arm_thickness-e, -saddle_dx-clamp_arm_thickness-e]) {
          cube([saddle_dx+clamp_arm_thickness+2*e, clamp_arm_thickness+2*e, saddle_dx+clamp_arm_thickness]);
        }
      }
    }
  }

  module m3_screw_hole() {
    cylinder(h=saddle_dz+saddle_dx, d=6);
    translate([0, 0, -(plate_thickness+strap_thickness+e)]) {
      cylinder(h=plate_thickness+strap_thickness+2*e, d=3);
    }
  }
}
