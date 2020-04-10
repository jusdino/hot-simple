e = 0.01;

COLLAR_INNER_DIA = 12;
COLLAR_OUTER_DIA = 16;
COLLAR_SEG_1_DY = 3.7;
COLLAR_SEG_2_DY = 6;
COLLAR_SEG_3_DY = 3;

INNER_SEG_1_DIA = 9;
INNER_SEG_1_DY = 4;

INNER_SEG_2_D1 = 9.0;
INNER_SEG_2_D2 = 12.6;
INNER_SEG_2_DY = 26;

GILL_DY = 1;
GILL_DIA = 22;
GILL_COUNT = 11;

NECK_DIA = 2.75;
NECK_DY = 3;

BLOCK_X = 16;
BLOCK_Y = 23;
BLOCK_Z = 11.5;
BLOCK_Y_OFFSET = 6.8;

NOZZLE_NUT_DY = 3;
NOZZLE_NUT_SIZE = 7;
NOZZLE_CONE_DY = 2;
NOZZLE_CONE_D1 = 3;
NOZZLE_CONE_D2 = 0.6;

E3D_TOTAL_DY = COLLAR_SEG_1_DY + COLLAR_SEG_2_DY + COLLAR_SEG_3_DY + INNER_SEG_1_DY + INNER_SEG_2_DY + NECK_DY + BLOCK_Z + NOZZLE_NUT_DY + NOZZLE_CONE_DY;

module e3d_v6(coords) {
  translate(coords) {
    rotate([90, 0, 0]) {
      // Push fitting
      color([0.1, 0.1, 0.1]) translate([0, 0, -2.25]) {
        difference() {
          cylinder(h=2.25, d=7);
          translate([0, 0, -e]) {
            cylinder(h=2.25+2*e, d=4);
          }
        }
      }
      // Collar
      cylinder(h=COLLAR_SEG_1_DY, d=COLLAR_OUTER_DIA);
      translate([0, 0, COLLAR_SEG_1_DY]) {
        translate([0, 0, -e]) cylinder(h=COLLAR_SEG_2_DY+2*e, d=COLLAR_INNER_DIA);
        translate([0, 0, COLLAR_SEG_2_DY]) {
          cylinder(h=COLLAR_SEG_3_DY, d=COLLAR_OUTER_DIA);
          translate([0, 0, COLLAR_SEG_3_DY]) {
            cylinder(h=INNER_SEG_1_DY, d=INNER_SEG_1_DIA);
            // Small gill
            translate([0, 0, INNER_SEG_1_DY/2-GILL_DY/2]) {
              cylinder(h=GILL_DY, d=COLLAR_OUTER_DIA);
            }
            // Gills
            translate([0, 0, INNER_SEG_1_DY]) {
              cylinder(d2=INNER_SEG_2_D2, d1=INNER_SEG_2_D1, h=INNER_SEG_2_DY);
              for(i = [0: GILL_COUNT-1]) {
                translate([0, 0, i*((INNER_SEG_2_DY-GILL_DY)/(GILL_COUNT-1))]) {
                  cylinder(h=GILL_DY, d=GILL_DIA);
                }
              }
              // Filament neck
              translate([0, 0, INNER_SEG_2_DY]) {
                cylinder(h=NECK_DY, d=NECK_DIA);
                translate([-BLOCK_X/2, -BLOCK_Y+BLOCK_Y_OFFSET, NECK_DY]) {
                  // Heat block
                  cube([BLOCK_X, BLOCK_Y, BLOCK_Z]);
                }
                // Nozzle
                color([0.8, 0.7, 0]) translate([0, 0, NECK_DY+BLOCK_Z]) {
                  cylinder(h=NOZZLE_NUT_DY, d=NOZZLE_NUT_SIZE*2/sqrt(3),$fn=6);
                  translate([0, 0, NOZZLE_NUT_DY]) {
                    cylinder(d1=NOZZLE_CONE_D1, d2=NOZZLE_CONE_D2, h=NOZZLE_CONE_DY);
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
