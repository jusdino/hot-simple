include <fan_5015.scad>;
include <connectors.scad>;

e = 0.01;

INTAKE_5015_WALL_THICKNESS = 0.48;
INTAKE_5015_RIM_THICKNESS = 1.2;
INTAKE_5015_SIDE_THICKNESS = 3+INTAKE_5015_WALL_THICKNESS;
OUTLET_WALL_THICKNESS_5015 = 1.6;
OUTLET_NOZZLE_OVERLAP_5015 = 1.45;
DUCT_DY_5015 = 9;

module fan_5015_hood(connector_e3d_dy, include_fan=false) {
  INTAKE_5015_COVER_DIA = MAIN_DIA_5015 - 4;

  OUTLET_LATCH_HOLE_DX = 13.0;
  OUTLET_LATCH_HOLE_DZ = 5.0;

  SCREW_INSERT_DEPTH = 2;

  CONNECTOR_DX = 0;

  translate([-OUTLET_X_5015+OUTLET_WALL_THICKNESS_5015+DUCT_DY_5015, -MAIN_DY_5015/2-OUTLET_TOLERANCE_5015+OUTLET_NOZZLE_OVERLAP_5015, -MAIN_DZ_5015-INTAKE_5015_SIDE_THICKNESS+PIN_DIA/2]) {
    if(include_fan) {
      translate([0, 0, 0]) {
        fan_5015();
      }
    }
    color([0.5, 0.1, 0.1]) {
      translate([0, 0, MAIN_DZ_5015]) {
        // Intake cover
        difference() {
          cylinder(h=INTAKE_5015_SIDE_THICKNESS, d=INTAKE_5015_COVER_DIA);
          translate([0, 0, -e]) {
            cylinder(h=INTAKE_5015_SIDE_THICKNESS-INTAKE_5015_WALL_THICKNESS+e, d=INTAKE_5015_COVER_DIA-2*INTAKE_5015_RIM_THICKNESS);
          } // Cover vent slots
          translate([0, 0, INTAKE_5015_WALL_THICKNESS]) {
            for (i=[0:5]) {
              rotate([0, 0, -(180-30*i)]) {
                rotate_extrude(angle=25) {
                  translate([INTAKE_5015_COVER_DIA/4, 0, 0]) {
                      square([INTAKE_5015_COVER_DIA/4+e, INTAKE_5015_SIDE_THICKNESS-2*INTAKE_5015_WALL_THICKNESS]);
                  }
                }
              }
            }
          }
        }
        // Outlet and screw cover
        difference() {
          union() {
            hull() {
              // Cube over outlet side
              translate([OUTLET_X_5015-OUTLET_WALL_THICKNESS_5015, OUTLET_Y_5015-OUTLET_TOLERANCE_5015/2-OUTLET_DY_5015-OUTLET_WALL_THICKNESS_5015, 0]) {
                cube([-OUTLET_X_5015+OUTLET_WALL_THICKNESS_5015, OUTLET_DY_5015+OUTLET_TOLERANCE_5015+2*OUTLET_WALL_THICKNESS_5015, INTAKE_5015_SIDE_THICKNESS]);
                // Connector backing
                translate([0, (OUTLET_DY_5015+2*OUTLET_WALL_THICKNESS_5015+OUTLET_TOLERANCE_5015)-3, 0]) {
                  cube([-connector_e3d_dy-DUCT_DY_5015+PIN_DIA, 3, INTAKE_5015_SIDE_THICKNESS]);
                }
              }
              // Screw mount
              translate(SCREW_HOLE_1_COORDS_5015) {
                cylinder(h=INTAKE_5015_SIDE_THICKNESS, d=SCREW_MOUNT_DIA_5015);
              }
            }
            // Screw hole insert
            translate(SCREW_HOLE_1_COORDS_5015) {
              translate([0, 0, -SCREW_INSERT_DEPTH]) {
                cylinder(h=SCREW_INSERT_DEPTH+e, d=SCREW_HOLE_DIA_5015-SCREW_HOLE_TOLERANCE_5015);
              }
            }
          }
          // Cut intake cylinder
          translate([0, 0, -e]) {
            cylinder(h=INTAKE_5015_SIDE_THICKNESS+2*e, d=INTAKE_5015_COVER_DIA-e);
          }
          // Screw hole
          translate(SCREW_HOLE_1_COORDS_5015) {
            translate([0, 0, -SCREW_INSERT_DEPTH-e]) {
              cylinder(h=SCREW_INSERT_DEPTH+INTAKE_5015_SIDE_THICKNESS+2*e, d=3);
            }
          }
        }
        // Connector
        translate([OUTLET_X_5015-OUTLET_WALL_THICKNESS_5015-DUCT_DY_5015-connector_e3d_dy, OUTLET_Y_5015+OUTLET_WALL_THICKNESS_5015+OUTLET_TOLERANCE_5015/2-e, INTAKE_5015_SIDE_THICKNESS-PIN_DIA/2]) {
          rotate([0, 90, 90]) {
            pin_tab(7.5+e);
          }
        }
        // Outlet frame
        translate([OUTLET_X_5015-OUTLET_WALL_THICKNESS_5015, OUTLET_Y_5015-OUTLET_DY_5015-OUTLET_TOLERANCE_5015/2-OUTLET_WALL_THICKNESS_5015, 0]) {
          translate([0, 0, -MAIN_DZ_5015-OUTLET_TOLERANCE_5015-OUTLET_WALL_THICKNESS_5015]) {
            cube([2*OUTLET_WALL_THICKNESS_5015, OUTLET_WALL_THICKNESS_5015, MAIN_DZ_5015+OUTLET_TOLERANCE_5015+OUTLET_WALL_THICKNESS_5015+e]);
            difference() {
              cube([OUTLET_WALL_THICKNESS_5015, OUTLET_DY_5015+OUTLET_TOLERANCE_5015+2*OUTLET_WALL_THICKNESS_5015, MAIN_DZ_5015+OUTLET_TOLERANCE_5015+2*OUTLET_WALL_THICKNESS_5015]);
              translate([-e, (OUTLET_DY_5015-OUTLET_INNER_DY_5015)/2+OUTLET_WALL_THICKNESS_5015, (MAIN_DZ_5015-OUTLET_INNER_DZ_5015)/2+OUTLET_WALL_THICKNESS_5015]) {
                cube([OUTLET_WALL_THICKNESS_5015+2*e, OUTLET_INNER_DY_5015+OUTLET_TOLERANCE_5015, OUTLET_INNER_DZ_5015+OUTLET_TOLERANCE_5015]);
              }
            }
          }
          // +Y-face
          difference() {
            hull() {
              translate([0, OUTLET_DY_5015+OUTLET_TOLERANCE_5015+OUTLET_WALL_THICKNESS_5015, 0]) {
                cube([-OUTLET_X_5015+OUTLET_WALL_THICKNESS_5015, OUTLET_WALL_THICKNESS_5015, OUTLET_WALL_THICKNESS_5015]);
                translate([0, 0, -MAIN_DZ_5015-OUTLET_TOLERANCE_5015-OUTLET_WALL_THICKNESS_5015]) {
                  cube([OUTLET_WALL_THICKNESS_5015+(-OUTLET_X_5015/2), OUTLET_WALL_THICKNESS_5015, MAIN_DZ_5015+OUTLET_TOLERANCE_5015+OUTLET_WALL_THICKNESS_5015+e]);
                }
              }
            }
            translate([OUTLET_WALL_THICKNESS_5015, OUTLET_DY_5015+OUTLET_TOLERANCE_5015+OUTLET_WALL_THICKNESS_5015-e, -MAIN_DZ_5015/2-OUTLET_LATCH_HOLE_DZ/2]) {
              cube([OUTLET_LATCH_HOLE_DX, OUTLET_WALL_THICKNESS_5015+2*e, OUTLET_LATCH_HOLE_DZ]);
            }
          }
          // -Z-face
          hull() {
            translate([0, OUTLET_DY_5015+OUTLET_TOLERANCE_5015+OUTLET_WALL_THICKNESS_5015, -MAIN_DZ_5015-OUTLET_TOLERANCE_5015-OUTLET_WALL_THICKNESS_5015]) {
              cube([OUTLET_WALL_THICKNESS_5015+(-OUTLET_X_5015/2), OUTLET_WALL_THICKNESS_5015, OUTLET_WALL_THICKNESS_5015]);
            }
            translate([0, 0, -MAIN_DZ_5015-OUTLET_TOLERANCE_5015-OUTLET_WALL_THICKNESS_5015]) {
              cube([2*OUTLET_WALL_THICKNESS_5015, OUTLET_DY_5015+OUTLET_TOLERANCE_5015+2*OUTLET_WALL_THICKNESS_5015, OUTLET_WALL_THICKNESS_5015]);
            }
          }
        }
        // Nozzle
        translate([OUTLET_X_5015-OUTLET_WALL_THICKNESS_5015, OUTLET_Y_5015-OUTLET_DY_5015-OUTLET_TOLERANCE_5015/2+(OUTLET_DY_5015-OUTLET_INNER_DY_5015)/2, -MAIN_DZ_5015-OUTLET_TOLERANCE_5015+(MAIN_DZ_5015-OUTLET_INNER_DZ_5015)/2]) {
          left_nozzle();
        }
      }
    }
  }
}

module left_nozzle() {
  OUTLET_AREA = OUTLET_INNER_DY_5015 * OUTLET_INNER_DZ_5015;
  OUTLET_CLEARANCE = 1;
  OUTLET_NOZZLE_EXIT_DX = DUCT_DY_5015 - OUTLET_CLEARANCE - OUTLET_WALL_THICKNESS_5015;
  OUTLET_NOZZLE_EXIT_DY = (4*OUTLET_AREA)/(PI*OUTLET_NOZZLE_EXIT_DX);

  difference() {
    // exterior
    hull() {
      TOTAL_DZ = OUTLET_INNER_DZ_5015 + OUTLET_TOLERANCE_5015 + 2*OUTLET_WALL_THICKNESS_5015;
      translate([0, -OUTLET_WALL_THICKNESS_5015+e, 0]) {
        for(i = [0:TOTAL_DZ/40:TOTAL_DZ]) {
          dx = (OUTLET_NOZZLE_EXIT_DX/TOTAL_DZ)*sqrt(pow(TOTAL_DZ, 2)-pow(i, 2)) + OUTLET_WALL_THICKNESS_5015+e;
          dy = (OUTLET_INNER_DY_5015+OUTLET_TOLERANCE_5015)*(i/TOTAL_DZ)+OUTLET_NOZZLE_EXIT_DY*(TOTAL_DZ-i)/TOTAL_DZ+2*OUTLET_WALL_THICKNESS_5015;
          translate([0, 0, i-OUTLET_WALL_THICKNESS_5015]) {
            cube([OUTLET_WALL_THICKNESS_5015+e, dy, e]);
          }
          translate([e, dy/2, i-OUTLET_WALL_THICKNESS_5015]) {
            // cube([dx+e, dy, e]);
            scale([2*dx, dy, 1]) {
              difference() {
                cylinder(d=1, h=e, $fn=20);
                translate([0, -e-1/2, -e]) {
                  cube([1/2+e, 1+2*e, 3*e]);
                }
              }
            }
          }
        }
      }
    }
    // subtracted interior
    hull() {
      TOTAL_DZ = OUTLET_INNER_DZ_5015 + OUTLET_TOLERANCE_5015 + OUTLET_WALL_THICKNESS_5015+e;
      for(i = [0:TOTAL_DZ/10:TOTAL_DZ]) {
        dx = (OUTLET_NOZZLE_EXIT_DX/TOTAL_DZ)*sqrt(pow(TOTAL_DZ, 2)-pow(i, 2))+e;
        dy = (OUTLET_INNER_DY_5015+OUTLET_TOLERANCE_5015)*(i/TOTAL_DZ)+OUTLET_NOZZLE_EXIT_DY*(TOTAL_DZ-i)/TOTAL_DZ;
        translate([e, dy/2, i-OUTLET_WALL_THICKNESS_5015-e]) {
          scale([2*dx, dy, 1]) {
            difference() {
              cylinder(d=1, h=e, $fn=30);
              translate([0, -e-1/2, -e]) {
                cube([1/2+e, 1+2*e, 3*e]);
              }
            }
          }
        }
      }
    }
    cube([OUTLET_WALL_THICKNESS_5015+2*e, OUTLET_INNER_DY_5015+OUTLET_TOLERANCE_5015, OUTLET_INNER_DZ_5015+OUTLET_TOLERANCE_5015]);
  }
}

