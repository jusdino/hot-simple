include <nutsnbolts/cyl_head_bolt.scad>;
include <e3d_v6.scad>;
include <gantry_plate.scad>;

e = 0.01;

collar_total_dy = collar_seg_1_dy+collar_seg_2_dy+collar_seg_3_dy;
collar_seg_2_mid_y = collar_seg_1_dy+collar_seg_2_dy/2;
saddle_overreach = 1;

peg_avg_x = (peg_1_coords[0]+peg_2_coords[0])/2;
peg_avg_y = (peg_1_coords[1]+peg_2_coords[1])/2;
peg_dx = (peg_2_coords[0]-peg_1_coords[0]);
peg_screw_space = 1;
peg_hole_dia = peg_dia + 0.3;
peg_hole_dz = peg_dz + 0.5;

saddle_dx = (plate_width-peg_avg_x)*2;
saddle_dy = collar_total_dy;
saddle_dz = gill_dia/2 + 2 + saddle_overreach;

saddle_x = peg_avg_x;
saddle_y = peg_avg_y+collar_seg_2_mid_y;
saddle_z = 0;
saddle_coords = [saddle_x, saddle_y, saddle_z];
saddle_wedge_dy = 0.16;

e3d_dz = saddle_dz-saddle_overreach;
e3d_z = e3d_dz+saddle_z;

key_dz = 2;

nut_slot_size = 5.6;
nut_slot_dz = 5;
clamp_screw_inset = 2.75;
clamp_screw_head_hole_dia = 6;

u_gap = 0.5;
u_overreach = e3d_dz-peg_hole_dz-peg_screw_space-4.5;
u_key_inset = (saddle_dx - peg_dx)/2 - collar_seg_2_dy/2;
u_screw_dz = 4;

module e3d_clamp_saddle(coords) {
  color([0.7, 0.1, 0.1]) {
    translate(coords) {
      peg_cut_outs([-peg_dx/2, -collar_seg_1_dy-collar_seg_2_dy/2, 0]) {
        peg_cut_outs([peg_dx/2, -collar_seg_1_dy-collar_seg_2_dy/2, 0]) {
          e3d_collar_cut_out([0, 0, e3d_dz]) {
            translate([-(saddle_dx)/2, -saddle_dy, 0]) {
              difference() {
                // main block
                cube([saddle_dx, saddle_dy, saddle_dz]);
                // key
                translate([-e, collar_seg_3_dy, saddle_dz-key_dz]) {
                  cube([saddle_dx+2*e, collar_seg_2_dy+saddle_wedge_dy, key_dz+e]);
                }
                // screw/nut slots
                translate([clamp_screw_inset, saddle_dy/2, -e]) {
                  rotate([0, 0, 30]) {
                    cylinder($fn=6, d=nut_slot_size*2/sqrt(3), h=nut_slot_dz);
                  }
                  cylinder(d=3, h=saddle_dz+2*e);
                }
                translate([saddle_dx-clamp_screw_inset, saddle_dy/2, -e]) {
                  rotate([0, 0, 30]) {
                    cylinder($fn=6, d=nut_slot_size*2/sqrt(3), h=nut_slot_dz);
                  }
                  cylinder(d=3, h=saddle_dz+2*e);
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
    translate([0, 0, e3d_dz]) {
      color([0.6, 0.1, 0.1]) {
        e3d_collar_cut_out([0, 0, 0]) {
          difference() {
            // main cylinder
            rotate([90, 0, 0]) {
              cylinder(h=saddle_dy, d=saddle_dx);
            }
            // bottom seg 2 lowest subtraction
            translate([-saddle_dx/2-e, -saddle_dy-e, -(u_overreach+saddle_dx)]) {
              cube([saddle_dx+2*e, saddle_dy+2*e, saddle_dx]);
            }
            // bottom seg 2 key subtractions
            translate([-saddle_dx/2-e, -collar_seg_1_dy-collar_seg_2_dy-e, saddle_overreach+u_gap-key_dz-u_overreach]) {
              cube([u_key_inset, collar_seg_2_dy+saddle_wedge_dy+2*e, u_overreach]);
            }
            translate([saddle_dx/2+e-u_key_inset, -collar_seg_1_dy-collar_seg_2_dy-e, saddle_overreach+u_gap-key_dz-u_overreach]) {
              cube([u_key_inset, collar_seg_2_dy+saddle_wedge_dy+2*e, u_overreach]);
            }
            translate([-saddle_dx/2-e, -saddle_dy-e, -saddle_dx-key_dz+saddle_overreach+u_gap]) {
              // bottom seg 1 subtraction
              translate([0, 0, -e]) {
                cube([saddle_dx+2*e, collar_seg_3_dy+e, saddle_dx+key_dz+e]);
              }
              // bottom seg 3 subtraction
              translate([0, collar_seg_3_dy+collar_seg_2_dy+saddle_wedge_dy+e, -e]) {
                cube([saddle_dx+2*e, collar_seg_1_dy-saddle_wedge_dy+e, saddle_dx+key_dz+e]);
              }
            }
            // screw cuts
            translate([-saddle_dx/2+clamp_screw_inset, -collar_seg_1_dy-collar_seg_2_dy/2, -u_gap-e]) {
              cylinder(h=saddle_dx, d=3);
              translate([0, 0, u_screw_dz]) {
                cylinder(h=saddle_dx, d=clamp_screw_head_hole_dia);
              }
            }
            translate([saddle_dx/2-clamp_screw_inset, -collar_seg_1_dy-collar_seg_2_dy/2, -u_gap-e]) {
              cylinder(h=saddle_dx, d=3);
              translate([0, 0, u_screw_dz]) {
                cylinder(h=saddle_dx, d=clamp_screw_head_hole_dia);
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
        // seg 1
        translate([0, 0, -e]) {
          cylinder(h=collar_seg_1_dy-saddle_wedge_dy+e, d=collar_outer_dia);
        }
        translate([0, 0, collar_seg_1_dy]) {
          // seg 1 wedge
          translate([0, 0, -saddle_wedge_dy-e]) {
            cylinder(h=saddle_wedge_dy+e, d1=collar_outer_dia, d2=collar_inner_dia);
          }
          // seg 2
          translate([0, 0, -e]) {
            cylinder(h=collar_seg_2_dy+2*e, d=collar_inner_dia);
          }
          // seg 3
          translate([0, 0, collar_seg_2_dy-e]) {
            cylinder(h=collar_seg_3_dy+2*e, d=collar_outer_dia);
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
      // cube screw slot
      translate([-collar_seg_2_dy/2, -collar_seg_2_dy/2-e, peg_hole_dz+peg_screw_space]) {
        cube([collar_seg_2_dy, collar_seg_2_dy+saddle_wedge_dy+2*e, saddle_dz-peg_hole_dz-peg_screw_space+e]);
      }
      // screw hole
      translate([0, 0, peg_hole_dz-e]) {
        cylinder(h=peg_screw_space+2*e, d=3);
      }
      // peg hole
      translate([0, 0, -e]) {
        cylinder(h=peg_hole_dz+2*e, d=peg_hole_dia);
      }
    }
  }
}

