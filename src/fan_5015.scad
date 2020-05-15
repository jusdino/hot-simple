include <functions.scad>;

e = 0.01;
DARK_GRAY = [0.2, 0.2, 0.2];


MAIN_DIA_5015 = 48.1;
MAIN_DY_5015 = 51.3;
MAIN_DZ_5015 = 15.0;

SCREW_HOLE_DIA_5015 = 4.5;
SCREW_MOUNT_DIA_5015 = 6.8;
SCREW_HOLE_1_COORDS_5015 = [20.0, 23.0];
SCREW_HOLE_2_COORDS_5015 = [-18.0, -20.0];
SCREW_HOLE_TOLERANCE_5015 = 0.3;

OUTLET_X_5015 = -25.4;
OUTLET_Y_5015 = 51.3-MAIN_DIA_5015/2;
OUTLET_DY_5015 = 20.0;
OUTLET_INNER_DY_5015 = 17.6;
OUTLET_INNER_DZ_5015 = 12.2;
OUTLET_TOLERANCE_5015 = 0.5;


module fan_5015() {
  INTAKE_OUTER_DIA = 31.0;
  INTAKE_INNER_DIA = 26.0;

  color(DARK_GRAY) {
    difference() {
      union() {
        // Main body
        cylinder(h=15, d=48.1);
        // Outlet box
        translate([OUTLET_X_5015, OUTLET_Y_5015-OUTLET_DY_5015, 0]) {
          difference() {
            cube([-OUTLET_X_5015, OUTLET_DY_5015, MAIN_DZ_5015]);
            translate([-e, (OUTLET_DY_5015-OUTLET_INNER_DY_5015)/2, (MAIN_DZ_5015-OUTLET_INNER_DZ_5015)/2]) {
              cube([-OUTLET_X_5015+2+e, OUTLET_INNER_DY_5015, OUTLET_INNER_DZ_5015]);
            }
          }
        }
        // Screw mounts
        for (coords=[SCREW_HOLE_1_COORDS_5015, SCREW_HOLE_2_COORDS_5015]) {
          translate(coords) {
            difference() {
              union() {
                cylinder(h=MAIN_DZ_5015, d=SCREW_MOUNT_DIA_5015);
                rotate([0, 0, to_origin_angle(coords)]) {
                  translate([-SCREW_MOUNT_DIA_5015/2, 0, 0]) {
                    cube([SCREW_MOUNT_DIA_5015, length(coords), MAIN_DZ_5015]);
                  }
                }
              }
              translate([0, 0, -e]) {
                cylinder(h=MAIN_DZ_5015+2*e, d=SCREW_HOLE_DIA_5015);
              }
            }
          }
        }
        // Fit body to outlet
        difference() {
          scale([1, OUTLET_Y_5015/(MAIN_DIA_5015/2), 1]) {
            cylinder(h=MAIN_DZ_5015, d=MAIN_DIA_5015);
          }
          translate([-MAIN_DIA_5015/2, -OUTLET_Y_5015-e, -e]) {
            cube([MAIN_DIA_5015, -OUTLET_X_5015+e, MAIN_DZ_5015+2*e]);
          }
        }
      }
      difference() {
        translate([0, 0, MAIN_DZ_5015/2]) {
          cylinder(h=MAIN_DZ_5015+e, d=INTAKE_OUTER_DIA);
        }
        translate([0, 0, MAIN_DZ_5015/2-e]) {
          cylinder(h=MAIN_DZ_5015+2*e, d=INTAKE_INNER_DIA);
        }
      }
    }
  }
}

module fan_5015_fit_test() {
  BASE_X = min([SCREW_HOLE_1_COORDS_5015[0], SCREW_HOLE_2_COORDS_5015[0], OUTLET_X_5015])-SCREW_MOUNT_DIA_5015/2;
  BASE_Y = min([SCREW_HOLE_1_COORDS_5015[1], SCREW_HOLE_2_COORDS_5015[1], OUTLET_Y_5015])-SCREW_MOUNT_DIA_5015/2;
  BASE_DX = max([SCREW_HOLE_1_COORDS_5015[0], SCREW_HOLE_2_COORDS_5015[0], OUTLET_X_5015])-BASE_X+SCREW_MOUNT_DIA_5015/2;
  BASE_DY = max([SCREW_HOLE_1_COORDS_5015[1], SCREW_HOLE_2_COORDS_5015[1], OUTLET_Y_5015])-BASE_Y+SCREW_MOUNT_DIA_5015/2;
  BASE_DZ = 0.32;

  SCREW_PEG_DIA = SCREW_HOLE_DIA_5015 - 0.4;
  OUTLET_CAP_THICKNESS = 1.5;
  OUTLET_CAP_TOLERANCE = 0.5;
  OUTLET_CAP_DY = OUTLET_DY_5015+2*OUTLET_CAP_THICKNESS+OUTLET_CAP_TOLERANCE;
  OUTLET_CAP_DZ = MAIN_DZ_5015+OUTLET_CAP_THICKNESS+OUTLET_CAP_TOLERANCE;

  color([0.8, 0.2, 0.2]) {
    // Base
    translate([BASE_X, BASE_Y, -BASE_DZ]) {
      cube([BASE_DX, BASE_DY, BASE_DZ]);
    }
    // Screw hole pegs
    translate(SCREW_HOLE_1_COORDS_5015) {
      cylinder(h=MAIN_DZ_5015, d=SCREW_PEG_DIA);
    }
    translate(SCREW_HOLE_2_COORDS_5015) {
      cylinder(h=MAIN_DZ_5015, d=SCREW_PEG_DIA);
    }
    // Outlet cap
    translate([OUTLET_X_5015-OUTLET_CAP_THICKNESS, OUTLET_Y_5015-OUTLET_DY_5015-OUTLET_CAP_THICKNESS-OUTLET_CAP_TOLERANCE/2, 0]) {
      cube([OUTLET_CAP_THICKNESS, OUTLET_CAP_DY, MAIN_DZ_5015+OUTLET_CAP_THICKNESS+OUTLET_CAP_TOLERANCE]);
      cube([2*OUTLET_CAP_THICKNESS, OUTLET_CAP_THICKNESS, OUTLET_CAP_DZ]);
      translate([0, OUTLET_CAP_DY-OUTLET_CAP_THICKNESS, 0]) {
        cube([2*OUTLET_CAP_THICKNESS, OUTLET_CAP_THICKNESS, OUTLET_CAP_DZ]);
      }
      translate([0, 0, OUTLET_CAP_DZ-OUTLET_CAP_THICKNESS]) {
        cube([2*OUTLET_CAP_THICKNESS, OUTLET_CAP_DY, OUTLET_CAP_THICKNESS]);
      }
    }
  }
}
