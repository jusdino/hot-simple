e = 0.01;

collar_inner_dia = 12;
collar_outer_dia = 16;
collar_seg_1_dy = 3.7;
collar_seg_2_dy = 6;
collar_seg_3_dy = 3;

inner_seg_1_dia = 9;
inner_seg_1_dy = 4;

inner_seg_2_d1 = 9.0;
inner_seg_2_d2 = 12.6;
inner_seg_2_dy = 26;

gill_dy = 1;
gill_dia = 22;
gill_count = 11;

neck_dia = 2.75;
neck_dy = 3;

block_x = 16;
block_y = 23;
block_z = 11.5;
block_y_offset = 6.8;

nozzle_nut_dy = 3;
nozzle_nut_size = 7;
nozzle_cone_dy = 2;
nozzle_cone_d1 = 3;
nozzle_cone_d2 = 0.6;

e3d_total_dy = collar_seg_1_dy + collar_seg_2_dy + collar_seg_3_dy + inner_seg_1_dy + inner_seg_2_dy + neck_dy + block_z + nozzle_nut_dy + nozzle_cone_dy;

module e3d_v6(coords) {
  translate(coords) {
    rotate([90, 0, 0]) {
      // push fitting
      color([0.1, 0.1, 0.1]) translate([0, 0, -2.25]) {
        difference() {
          cylinder(h=2.25, d=7);
          translate([0, 0, -e]) {
            cylinder(h=2.25+2*e, d=4);
          }
        }
      }
      // collar
      cylinder(h=collar_seg_1_dy, d=collar_outer_dia);
      translate([0, 0, collar_seg_1_dy]) {
        translate([0, 0, -e]) cylinder(h=collar_seg_2_dy+2*e, d=collar_inner_dia);
        translate([0, 0, collar_seg_2_dy]) {
          cylinder(h=collar_seg_3_dy, d=collar_outer_dia);
          translate([0, 0, collar_seg_3_dy]) {
            cylinder(h=inner_seg_1_dy, d=inner_seg_1_dia);
            // small gill
            translate([0, 0, inner_seg_1_dy/2-gill_dy/2]) {
              cylinder(h=gill_dy, d=collar_outer_dia);
            }
            // gills
            translate([0, 0, inner_seg_1_dy]) {
              cylinder(d2=inner_seg_2_d2, d1=inner_seg_2_d1, h=inner_seg_2_dy);
              for(i = [0: gill_count-1]) {
                translate([0, 0, i*((inner_seg_2_dy-gill_dy)/(gill_count-1))]) {
                  cylinder(h=gill_dy, d=gill_dia);
                }
              }
              // filament neck
              translate([0, 0, inner_seg_2_dy]) {
                cylinder(h=neck_dy, d=neck_dia);
                translate([-block_x/2, -block_y+block_y_offset, neck_dy]) {
                  // heat block
                  cube([block_x, block_y, block_z]);
                }
                // nozzle
                color([0.8, 0.7, 0]) translate([0, 0, neck_dy+block_z]) {
                  cylinder(h=nozzle_nut_dy, d=nozzle_nut_size*2/sqrt(3),$fn=6);
                  translate([0, 0, nozzle_nut_dy]) {
                    cylinder(d1=nozzle_cone_d1, d2=nozzle_cone_d2, h=nozzle_cone_dy);
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
