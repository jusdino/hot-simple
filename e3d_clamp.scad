include <nutsnbolts/cyl_head_bolt.scad>;
include <e3d_v6.scad>;
include <gantry_plate.scad>;

e = 0.01;

COLLAR_TOTAL_DY = COLLAR_SEG_1_DY+COLLAR_SEG_2_DY+COLLAR_SEG_3_DY;
COLLAR_SEG_2_MID_Y = COLLAR_SEG_1_DY+COLLAR_SEG_2_DY/2;
SADDLE_OVERREACH = 1;

PEG_AVG_X = (PEG_1_COORDS[0]+PEG_2_COORDS[0])/2;
PEG_AVG_Y = (PEG_1_COORDS[1]+PEG_2_COORDS[1])/2;
PEG_DX = (PEG_2_COORDS[0]-PEG_1_COORDS[0]);
PEG_SCREW_SPACE = 1;
PEG_HOLE_DIA = PEG_DIA + 0.3;
PEG_HOLE_DZ = PEG_DZ + 0.5;

SADDLE_DX = (PLATE_WIDTH-PEG_AVG_X)*2;
SADDLE_DY = COLLAR_TOTAL_DY;
SADDLE_DZ = GILL_DIA/2 + 2 + SADDLE_OVERREACH;

SADDLE_X = PEG_AVG_X;
SADDLE_Y = PEG_AVG_Y+COLLAR_SEG_2_MID_Y;
SADDLE_Z = 0;
SADDLE_COORDS = [SADDLE_X, SADDLE_Y, SADDLE_Z];
SADDLE_WEDGE_DY = 0.16;

E3D_DZ = SADDLE_DZ-SADDLE_OVERREACH;
E3D_Z = E3D_DZ+SADDLE_Z;

KEY_DZ = 2;

NUT_SLOT_SIZE = 5.6;
NUT_SLOT_DZ = 5;
CLAMP_SCREW_INSET = 2.75;
CLAMP_SCREW_HEAD_HOLE_DIA = 6;

U_GAP = 0.5;
U_OVERREACH = E3D_DZ-PEG_HOLE_DZ-PEG_SCREW_SPACE-4.5;
U_KEY_INSET = (SADDLE_DX - PEG_DX)/2 - COLLAR_SEG_2_DY/2;
U_SCREW_DZ = 4;

module e3d_clamp_saddle(coords) {
  color([0.7, 0.1, 0.1]) {
    translate(coords) {
      peg_cut_outs([-PEG_DX/2, -COLLAR_SEG_1_DY-COLLAR_SEG_2_DY/2, 0]) {
        peg_cut_outs([PEG_DX/2, -COLLAR_SEG_1_DY-COLLAR_SEG_2_DY/2, 0]) {
          e3d_collar_cut_out([0, 0, E3D_DZ]) {
            translate([-(SADDLE_DX)/2, -SADDLE_DY, 0]) {
              difference() {
                // Main block
                cube([SADDLE_DX, SADDLE_DY, SADDLE_DZ]);
                // Key
                translate([-e, COLLAR_SEG_3_DY, SADDLE_DZ-KEY_DZ]) {
                  cube([SADDLE_DX+2*e, COLLAR_SEG_2_DY+SADDLE_WEDGE_DY, KEY_DZ+e]);
                }
                // Screw/Nut slots
                translate([CLAMP_SCREW_INSET, SADDLE_DY/2, -e]) {
                  rotate([0, 0, 30]) {
                    cylinder($fn=6, d=NUT_SLOT_SIZE*2/sqrt(3), h=NUT_SLOT_DZ);
                  }
                  cylinder(d=3, h=SADDLE_DZ+2*e);
                }
                translate([SADDLE_DX-CLAMP_SCREW_INSET, SADDLE_DY/2, -e]) {
                  rotate([0, 0, 30]) {
                    cylinder($fn=6, d=NUT_SLOT_SIZE*2/sqrt(3), h=NUT_SLOT_DZ);
                  }
                  cylinder(d=3, h=SADDLE_DZ+2*e);
                }
              }
            }
          }
        }
      }
    }
  }
}

module e3d_clamp_u(coords) {
  translate(coords) {
    translate([0, 0, E3D_DZ]) {
      color([0.6, 0.1, 0.1]) {
        e3d_collar_cut_out([0, 0, 0]) {
          difference() {
            // Main cylinder
            rotate([90, 0, 0]) {
              cylinder(h=SADDLE_DY, d=SADDLE_DX);
            }
            // Bottom seg 2 lowest subtraction
            translate([-SADDLE_DX/2-e, -SADDLE_DY-e, -(U_OVERREACH+SADDLE_DX)]) {
              cube([SADDLE_DX+2*e, SADDLE_DY+2*e, SADDLE_DX]);
            }
            // Bottom seg 2 key subtractions
            translate([-SADDLE_DX/2-e, -COLLAR_SEG_1_DY-COLLAR_SEG_2_DY-e, SADDLE_OVERREACH+U_GAP-KEY_DZ-U_OVERREACH]) {
              cube([U_KEY_INSET, COLLAR_SEG_2_DY+SADDLE_WEDGE_DY+2*e, U_OVERREACH]);
            }
            translate([SADDLE_DX/2+e-U_KEY_INSET, -COLLAR_SEG_1_DY-COLLAR_SEG_2_DY-e, SADDLE_OVERREACH+U_GAP-KEY_DZ-U_OVERREACH]) {
              cube([U_KEY_INSET, COLLAR_SEG_2_DY+SADDLE_WEDGE_DY+2*e, U_OVERREACH]);
            }
            translate([-SADDLE_DX/2-e, -SADDLE_DY-e, -SADDLE_DX-KEY_DZ+SADDLE_OVERREACH+U_GAP]) {
              // Bottom seg 1 subtraction
              translate([0, 0, -e]) {
                cube([SADDLE_DX+2*e, COLLAR_SEG_3_DY+e, SADDLE_DX+KEY_DZ+e]);
              }
              // Bottom seg 3 subtraction
              translate([0, COLLAR_SEG_3_DY+COLLAR_SEG_2_DY+SADDLE_WEDGE_DY+e, -e]) {
                cube([SADDLE_DX+2*e, COLLAR_SEG_1_DY-SADDLE_WEDGE_DY+e, SADDLE_DX+KEY_DZ+e]);
              }
            }
            // Screw cuts
            translate([-SADDLE_DX/2+CLAMP_SCREW_INSET, -COLLAR_SEG_1_DY-COLLAR_SEG_2_DY/2, -U_GAP-e]) {
              cylinder(h=SADDLE_DX, d=3);
              translate([0, 0, U_SCREW_DZ]) {
                cylinder(h=SADDLE_DX, d=CLAMP_SCREW_HEAD_HOLE_DIA);
              }
            }
            translate([SADDLE_DX/2-CLAMP_SCREW_INSET, -COLLAR_SEG_1_DY-COLLAR_SEG_2_DY/2, -U_GAP-e]) {
              cylinder(h=SADDLE_DX, d=3);
              translate([0, 0, U_SCREW_DZ]) {
                cylinder(h=SADDLE_DX, d=CLAMP_SCREW_HEAD_HOLE_DIA);
              }
            }
          }
        }
      }
    }
  }
}

module e3d_collar_cut_out(coords) {
  difference() {
    children();
    translate(coords) {
      rotate([90, 0, 0]) {
        // Seg 1
        translate([0, 0, -e]) {
          cylinder(h=COLLAR_SEG_1_DY-SADDLE_WEDGE_DY+e, d=COLLAR_OUTER_DIA);
        }
        translate([0, 0, COLLAR_SEG_1_DY]) {
          // Seg 1 wedge
          translate([0, 0, -SADDLE_WEDGE_DY-e]) {
            cylinder(h=SADDLE_WEDGE_DY+e, d1=COLLAR_OUTER_DIA, d2=COLLAR_INNER_DIA);
          }
          // Seg 2
          translate([0, 0, -e]) {
            cylinder(h=COLLAR_SEG_2_DY+2*e, d=COLLAR_INNER_DIA);
          }
          // Seg 3
          translate([0, 0, COLLAR_SEG_2_DY-e]) {
            cylinder(h=COLLAR_SEG_3_DY+2*e, d=COLLAR_OUTER_DIA);
          }
        }
      }
    }
  }
}

module peg_cut_outs(coords) {
  difference() {
    children();
    translate(coords) {
      // Cube screw slot
      translate([-COLLAR_SEG_2_DY/2, -COLLAR_SEG_2_DY/2-e, PEG_HOLE_DZ+PEG_SCREW_SPACE]) {
        cube([COLLAR_SEG_2_DY, COLLAR_SEG_2_DY+SADDLE_WEDGE_DY+2*e, SADDLE_DZ-PEG_HOLE_DZ-PEG_SCREW_SPACE+e]);
      }
      // Screw hole
      translate([0, 0, PEG_HOLE_DZ-e]) {
        cylinder(h=PEG_SCREW_SPACE+2*e, d=3);
      }
      // Peg hole
      translate([0, 0, -e]) {
        cylinder(h=PEG_HOLE_DZ+2*e, d=PEG_HOLE_DIA);
      }
    }
  }
}

