include <functions.scad>;
include <nutsnbolts/cyl_head_bolt.scad>;
include <e3d_clamp.scad>;
include <gantry_plate.scad>;
include <connectors.scad>;


module accessory_backing(left_connector_coords) {
  e = 0.01;
  HOLE_2_TO_1_VEC2 = [HOLE_1_COORDS[0]-HOLE_2_COORDS[0], HOLE_1_COORDS[1]-HOLE_2_COORDS[1]];
  CLAMP_GAP = 0.5;
  SADDLE_DIFF = [SADDLE_DX+2*CLAMP_GAP, SADDLE_DY+2*CLAMP_GAP, SADDLE_DZ+CLAMP_GAP+2*e];
  SADDLE_DIFF_COORDS = [SADDLE_X-SADDLE_DIFF[0]/2, SADDLE_Y-SADDLE_DY-CLAMP_GAP/2, SADDLE_Z];

  CLAMP_ARM_THICKNESS = 5;
  CLAMP_ARM_DIA = SADDLE_DX+CLAMP_ARM_THICKNESS;

  color("teal") difference() {
    union() {
      screw_hole_strap();
      left_arm();
      right_arm();
      top_bar();
      u_band();
      left_connector(left_connector_coords);
    }
    // Saddle subtraction from whole arm
    translate(SADDLE_DIFF_COORDS) {
      translate([0, 0, -e]) {
        cube(SADDLE_DIFF);
      }
    }
    translate([0, 0, STRAP_THICKNESS]) {
      translate(HOLE_2_COORDS) {
        m3_screw_hole();
      }
      translate(HOLE_1_COORDS) {
        m3_screw_hole();
      }
    }
  }

  STRAP_THICKNESS = 3.0;
  module screw_hole_strap() {

    hull() {
      translate(HOLE_1_COORDS) {
        screw_hole_strap_end();
      }
      translate(HOLE_2_COORDS) {
        screw_hole_strap_end();
      }
    }
  }

  module screw_hole_strap_end() {
    STRAP_BASE_DIA = 10;
    STRAP_TOP_DIA = 8;
    cylinder(h=STRAP_THICKNESS, d1=STRAP_BASE_DIA, d2=STRAP_TOP_DIA);
  }

  module left_connector(left_connector_coords) {
    PART_GAP = 0.1;
    CONNECTOR_DZ = 7.5;
    BACKING_THICKNESS = 1;
    difference() {
      union() {
        hull() {
          translate(HOLE_1_COORDS) {
            screw_hole_strap_end();
          }
          translate(left_connector_coords) {
            translate([0, -PIN_DY, 0]) {
              pin_slot_profile(length=4);
            }
          }
        }
        translate(left_connector_coords) {
          translate([0, -PIN_DY, 0]) {
            pin_slot_profile(length=CONNECTOR_DZ+BACKING_THICKNESS+PART_GAP);
          }
        }
      }
      translate(left_connector_coords) {
        translate([0, 0, CONNECTOR_DZ+BACKING_THICKNESS+PART_GAP+e]) {
          rotate([180, 0, 0]) {
            pin_tab(length=CONNECTOR_DZ);
          }
        }
      }
    }
  }

  module left_arm() {
    hull() {
      translate(HOLE_2_COORDS) {
        screw_hole_strap_end();
      }
      translate(SADDLE_DIFF_COORDS) {
        translate([-(CLAMP_ARM_THICKNESS/2-CLAMP_GAP), SADDLE_DIFF[1]-(CLAMP_ARM_THICKNESS/2+CLAMP_GAP), 0]) {
          // Left arm
          cube([CLAMP_ARM_THICKNESS, CLAMP_ARM_THICKNESS, SADDLE_DZ]);
        }
      }
    }
  }

  module right_arm() {
    BACK_BAR_LENGTH = 25;
    translate(SADDLE_DIFF_COORDS) {
      translate([SADDLE_DIFF[0]-(CLAMP_ARM_THICKNESS/2+CLAMP_GAP), SADDLE_DIFF[1]-(CLAMP_ARM_THICKNESS/2+CLAMP_GAP), -PLATE_THICKNESS-CLAMP_ARM_THICKNESS/2]) {
        difference() {
          cube([CLAMP_ARM_THICKNESS, CLAMP_ARM_THICKNESS, SADDLE_DZ+PLATE_THICKNESS+CLAMP_ARM_THICKNESS/2]);
          translate([-e, -e, -e]) {
            cube([CLAMP_ARM_THICKNESS/2+CLAMP_GAP+e, CLAMP_ARM_THICKNESS+2*e, PLATE_THICKNESS+CLAMP_ARM_THICKNESS/2+e]);
          }
        }
        translate([0, -(BACK_BAR_LENGTH-CLAMP_ARM_THICKNESS), 0]) {
          difference() {
            cube([CLAMP_ARM_THICKNESS, BACK_BAR_LENGTH, CLAMP_ARM_THICKNESS+PLATE_THICKNESS]);
            translate([-e, -e, CLAMP_ARM_THICKNESS-PLATE_THICKNESS]) {
              cube([CLAMP_ARM_THICKNESS/2+CLAMP_GAP+e, BACK_BAR_LENGTH+2*e, PLATE_THICKNESS+e]);
            }
          }
        }
      }
    }
  }

  module top_bar() {
    translate(SADDLE_DIFF_COORDS) {
      translate([-(CLAMP_ARM_THICKNESS/2-CLAMP_GAP), SADDLE_DIFF[1]-(CLAMP_ARM_THICKNESS/2+CLAMP_GAP), 2]) {
        cube([SADDLE_DX+CLAMP_ARM_THICKNESS, CLAMP_ARM_THICKNESS, CLAMP_ARM_THICKNESS]);
      }
    }
  }

  module u_band() {
    translate([SADDLE_X, SADDLE_Y+CLAMP_ARM_THICKNESS/2 + CLAMP_GAP/2, E3D_Z]) {
      difference() {
        rotate([90, 0, 0]) {
          difference() {
            // Band around U
            cylinder(h=CLAMP_ARM_THICKNESS, d=SADDLE_DX+CLAMP_ARM_THICKNESS);
            translate([0, 0, -e]) {
              cylinder(h=CLAMP_ARM_THICKNESS/2-CLAMP_GAP+2*e, d=SADDLE_DX-CLAMP_ARM_THICKNESS);
            }
            translate([0, 0, CLAMP_ARM_THICKNESS/2-CLAMP_GAP]) {
              cylinder(h=CLAMP_ARM_THICKNESS/2+CLAMP_GAP+e, d=SADDLE_DX+2*CLAMP_GAP);
            }
          }
        }
        // Saddle subtraction from U band
        translate([-(SADDLE_DX/2+CLAMP_ARM_THICKNESS/2+e), -CLAMP_ARM_THICKNESS-e, -SADDLE_DX-CLAMP_ARM_THICKNESS-e]) {
          cube([SADDLE_DX+CLAMP_ARM_THICKNESS+2*e, CLAMP_ARM_THICKNESS+2*e, SADDLE_DX+CLAMP_ARM_THICKNESS]);
        }
      }
    }
  }

  module m3_screw_hole() {
    cylinder(h=SADDLE_DZ+SADDLE_DX, d=6);
    translate([0, 0, -(PLATE_THICKNESS+STRAP_THICKNESS+e)]) {
      cylinder(h=PLATE_THICKNESS+STRAP_THICKNESS+2*e, d=3);
    }
  }
}
