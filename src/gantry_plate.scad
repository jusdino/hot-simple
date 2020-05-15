e=0.1;

PLATE_WIDTH=64.0;
PLATE_HEIGHT=44.6;
PLATE_THICKNESS=2.5;

CORNER_RADIUS=9;

BOTTOM_TAB_WIDTH = 24;
BOTTOM_TAB_HEIGHT = 18.6;

HOLE_1_COORDS = [13.1, -33.1, 0];
HOLE_2_COORDS = [30.4, -14.2, 0];

PEG_1_COORDS = [41.5, -24.5, 0];
PEG_2_COORDS = [55.6, -24.5, 0];
PEG_DIA=5.3;
PEG_DZ=4.4;


WHEEL_SCREW_1_COORDS = [12.1, -11.9, 0];
WHEEL_SCREW_2_COORDS = [51.9, -11.4, 0];
WHEEL_SCREW_3_COORDS = [PLATE_WIDTH/2, -(PLATE_HEIGHT+BOTTOM_TAB_HEIGHT-BOTTOM_TAB_WIDTH/2), 0];


module gantry_plate() {

  color([0.1, 0.1, 0.1]) {
    m3_screw_peg(PEG_1_COORDS, PLATE_THICKNESS) {
      m3_screw_peg(PEG_2_COORDS, PLATE_THICKNESS) {
        m3_screw_hole(HOLE_1_COORDS, PLATE_THICKNESS) {
          m3_screw_hole(HOLE_2_COORDS, PLATE_THICKNESS) {
            translate([0, -PLATE_HEIGHT, -PLATE_THICKNESS]) {
              difference() {
                // Main section
                cube([PLATE_WIDTH, PLATE_HEIGHT, PLATE_THICKNESS]);
                // Rounded corners
                translate([-e, PLATE_HEIGHT-CORNER_RADIUS+e, -e]) {
                  difference() {
                    cube([CORNER_RADIUS+e, CORNER_RADIUS+e, PLATE_THICKNESS+2*e]);
                    translate([CORNER_RADIUS, 0, -e]) {
                      cylinder(h=PLATE_THICKNESS+4*e, r=CORNER_RADIUS);
                    }
                  }
                }
                translate([PLATE_WIDTH-CORNER_RADIUS+e, PLATE_HEIGHT-CORNER_RADIUS+e, -e]) {
                  difference() {
                    cube([CORNER_RADIUS+e, CORNER_RADIUS+e, PLATE_THICKNESS+2*e]);
                    translate([0, 0, -e]) {
                      cylinder(h=PLATE_THICKNESS+4*e, r=CORNER_RADIUS);
                    }
                  }
                }
              }
              // Round tab on bottom
              translate([PLATE_WIDTH/2-BOTTOM_TAB_WIDTH/2, -(BOTTOM_TAB_HEIGHT-BOTTOM_TAB_WIDTH/2), 0]) {
                cube([BOTTOM_TAB_WIDTH, BOTTOM_TAB_HEIGHT-BOTTOM_TAB_WIDTH/2, PLATE_THICKNESS]);
                translate([BOTTOM_TAB_WIDTH/2, 0, 0]) {
                  cylinder(d=BOTTOM_TAB_WIDTH, h=PLATE_THICKNESS);
                }
              }
            }
          }
        }
      }
    }
  }
  color([0.7, 0.7, 0.7]) m5_button_cap(WHEEL_SCREW_1_COORDS, PLATE_THICKNESS);
  color([0.7, 0.7, 0.7]) m5_button_cap(WHEEL_SCREW_2_COORDS, PLATE_THICKNESS);
  color([0.7, 0.7, 0.7]) m5_nut_end(WHEEL_SCREW_3_COORDS, PLATE_THICKNESS);
}

module m3_screw_hole(coords, length) {
  SCREW_DIA=3;

  difference() {
    children();
    translate([coords[0], coords[1], coords[2]-length-e]) {
      cylinder(d=SCREW_DIA, h=length+2*e);
    }
  }
}

module m3_screw_peg(coords, length) {
  m3_screw_hole([coords[0], coords[1], coords[2]+PEG_DZ], length+PEG_DZ) {
    union() {
      translate([coords[0], coords[1], coords[2]]) {
        cylinder(d=PEG_DIA, h=PEG_DZ);
      }
      children();
    }
  }
}

module m5_button_cap(coords, length) {
  HEAD_DIA=9.2;
  SCREW_DIA=5;
  HEAD_HEIGHT=2;
  ALLEN_SIZE=2.5;
  ALLEN_DEPTH=1.5;

  translate([coords[0], coords[1], coords[2]]) {
    translate([0, 0, HEAD_HEIGHT/2]) {
      difference() {
        union() {
          scale([HEAD_DIA/10, HEAD_DIA/10, HEAD_HEIGHT/10]) {
            sphere(d=10);
          }
          translate([0, 0, -HEAD_HEIGHT/2]) {
            cylinder(d=HEAD_DIA, h=HEAD_HEIGHT/2);
          }
        }
        translate([0, 0, HEAD_HEIGHT/2+e-ALLEN_DEPTH]) {
          nut(ALLEN_SIZE, ALLEN_DEPTH);
        }
      }
    }
    translate([0, 0, -length-e]) {
      cylinder(d=5, h=length+2*e);
    }
  }
}

module m5_nut_end(coords, length) {
  NUT_SIZE=8;
  NUT_HEIGHT=4.7;
  SCREW_DIA=5;
  SCREW_EXCESS=2;

  translate([coords[0], coords[1], coords[2]]) {
    nut(NUT_SIZE, NUT_HEIGHT);
    translate([0, 0, -length-e]) {
      cylinder(d=SCREW_DIA, h=length+NUT_HEIGHT+SCREW_EXCESS+e);
    }
  }
}

module nut(size, height) {
  cylinder($fn=6, d=size*(2/sqrt(3)), h=height);
}

module gantry_fit_test() {
  THICKNESS=0.32;

  color([0.8, 0.2, 0.2]) {
    translate([0, 0, PLATE_THICKNESS+2*e]) {
      difference() {
        translate([0, -PLATE_HEIGHT, 0]) {
          cube([PLATE_WIDTH, PLATE_HEIGHT, THICKNESS]);
        }
        translate([HOLE_1_COORDS[0], HOLE_1_COORDS[1], HOLE_1_COORDS[2]-e]) {
          cylinder(d=4, h=THICKNESS+2*e);
        }
        translate([HOLE_2_COORDS[0], HOLE_2_COORDS[1], HOLE_2_COORDS[2]-e]) {
          cylinder(d=4, h=THICKNESS+2*e);
        }
        translate([PEG_1_COORDS[0], PEG_1_COORDS[1], PEG_1_COORDS[2]-e]) {
          cylinder(d=6, h=THICKNESS+2*e);
        }
        translate([PEG_2_COORDS[0], PEG_2_COORDS[1], PEG_2_COORDS[2]-e]) {
          cylinder(d=6, h=THICKNESS+2*e);
        }
        translate([WHEEL_SCREW_1_COORDS[0], WHEEL_SCREW_1_COORDS[1], WHEEL_SCREW_1_COORDS[2]-e]) {
          cylinder(d=10, h=THICKNESS+2*e);
        }
        translate([WHEEL_SCREW_2_COORDS[0], WHEEL_SCREW_2_COORDS[1], WHEEL_SCREW_2_COORDS[2]-e]) {
          cylinder(d=10, h=THICKNESS+2*e);
        }
      }
    }
  }
}

