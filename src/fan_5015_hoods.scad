include <fan_5015.scad>;
include <connectors.scad>;

e = 0.01;

intake_5015_wall_thickness = 0.6;
intake_5015_rim_thickness = 1.2;
intake_5015_side_thickness = 3+intake_5015_wall_thickness;
outlet_wall_thickness_5015 = 1.6;
outlet_nozzle_overlap_5015 = 1.45;
duct_dy_5015 = 10;

module fan_5015_hood(connector_e3d_dy, include_fan=false) {
  intake_5015_cover_dia = main_dia_5015 - 4;

  outlet_latch_hole_dx = 13.0;
  outlet_latch_hole_dz = 5.0;

  screw_insert_depth = 2;

  connector_dx = 0;

  translate([-outlet_x_5015+outlet_wall_thickness_5015+duct_dy_5015, -main_dy_5015/2-outlet_tolerance_5015+outlet_nozzle_overlap_5015, -main_dz_5015-intake_5015_side_thickness+pin_dia/2]) {
    if(include_fan) {
      translate([0, 0, 0]) {
        fan_5015();
      }
    }
    color([0.5, 0.1, 0.1]) {
      translate([0, 0, main_dz_5015]) {
        // intake cover
        difference() {
          cylinder(h=intake_5015_side_thickness, d=intake_5015_cover_dia);
          translate([0, 0, -e]) {
            cylinder(h=intake_5015_side_thickness-intake_5015_wall_thickness+e, d=intake_5015_cover_dia-2*intake_5015_rim_thickness);
          } // cover vent slots
          translate([0, 0, intake_5015_wall_thickness]) {
            for (i=[0:5]) {
              rotate([0, 0, -(180-30*i)]) {
                rotate_extrude(angle=25) {
                  translate([intake_5015_cover_dia/4, 0, 0]) {
                      square([intake_5015_cover_dia/4+e, intake_5015_side_thickness-2*intake_5015_wall_thickness]);
                  }
                }
              }
            }
          }
        }
        // outlet and screw cover
        difference() {
          union() {
            hull() {
              // cube over outlet side
              translate([outlet_x_5015-outlet_wall_thickness_5015, outlet_y_5015-outlet_tolerance_5015/2-outlet_dy_5015-outlet_wall_thickness_5015, 0]) {
                cube([-outlet_x_5015+outlet_wall_thickness_5015, outlet_dy_5015+outlet_tolerance_5015+2*outlet_wall_thickness_5015, intake_5015_side_thickness]);
                // connector backing
                translate([0, (outlet_dy_5015+2*outlet_wall_thickness_5015+outlet_tolerance_5015)-3, 0]) {
                  cube([-connector_e3d_dy-duct_dy_5015+pin_dia, 3, intake_5015_side_thickness]);
                }
              }
              // screw mount
              translate(screw_hole_1_coords_5015) {
                cylinder(h=intake_5015_side_thickness, d=screw_mount_dia_5015);
              }
            }
            // screw hole insert
            translate(screw_hole_1_coords_5015) {
              translate([0, 0, -screw_insert_depth]) {
                cylinder(h=screw_insert_depth+e, d=screw_hole_dia_5015-screw_hole_tolerance_5015);
              }
            }
          }
          // cut intake cylinder
          translate([0, 0, -e]) {
            cylinder(h=intake_5015_side_thickness+2*e, d=intake_5015_cover_dia-e);
          }
          // screw hole
          translate(screw_hole_1_coords_5015) {
            translate([0, 0, -screw_insert_depth-e]) {
              cylinder(h=screw_insert_depth+intake_5015_side_thickness+2*e, d=3);
            }
          }
        }
        // connector
        translate([outlet_x_5015-outlet_wall_thickness_5015-duct_dy_5015-connector_e3d_dy, outlet_y_5015+outlet_wall_thickness_5015+outlet_tolerance_5015/2-e, intake_5015_side_thickness-pin_dia/2]) {
          rotate([0, 90, 90]) {
            pin_tab(7.5+e);
          }
        }
        // outlet frame
        translate([outlet_x_5015-outlet_wall_thickness_5015, outlet_y_5015-outlet_dy_5015-outlet_tolerance_5015/2-outlet_wall_thickness_5015, 0]) {
          translate([0, 0, -main_dz_5015-outlet_tolerance_5015-outlet_wall_thickness_5015]) {
            cube([2*outlet_wall_thickness_5015, outlet_wall_thickness_5015, main_dz_5015+outlet_tolerance_5015+outlet_wall_thickness_5015+e]);
            difference() {
              cube([outlet_wall_thickness_5015, outlet_dy_5015+outlet_tolerance_5015+2*outlet_wall_thickness_5015, main_dz_5015+outlet_tolerance_5015+2*outlet_wall_thickness_5015]);
              translate([-e, (outlet_dy_5015-outlet_inner_dy_5015)/2+outlet_wall_thickness_5015, (main_dz_5015-outlet_inner_dz_5015)/2+outlet_wall_thickness_5015]) {
                cube([outlet_wall_thickness_5015+2*e, outlet_inner_dy_5015+outlet_tolerance_5015, outlet_inner_dz_5015+outlet_tolerance_5015]);
              }
            }
          }
          // +y-face
          difference() {
            hull() {
              translate([0, outlet_dy_5015+outlet_tolerance_5015+outlet_wall_thickness_5015, 0]) {
                cube([-outlet_x_5015+outlet_wall_thickness_5015, outlet_wall_thickness_5015, outlet_wall_thickness_5015]);
                translate([0, 0, -main_dz_5015-outlet_tolerance_5015-outlet_wall_thickness_5015]) {
                  cube([outlet_wall_thickness_5015+(-outlet_x_5015/2), outlet_wall_thickness_5015, main_dz_5015+outlet_tolerance_5015+outlet_wall_thickness_5015+e]);
                }
              }
            }
            translate([outlet_wall_thickness_5015, outlet_dy_5015+outlet_tolerance_5015+outlet_wall_thickness_5015-e, -main_dz_5015/2-outlet_latch_hole_dz/2]) {
              cube([outlet_latch_hole_dx, outlet_wall_thickness_5015+2*e, outlet_latch_hole_dz]);
            }
          }
          // -z-face
          hull() {
            translate([0, outlet_dy_5015+outlet_tolerance_5015+outlet_wall_thickness_5015, -main_dz_5015-outlet_tolerance_5015-outlet_wall_thickness_5015]) {
              cube([outlet_wall_thickness_5015+(-outlet_x_5015/2), outlet_wall_thickness_5015, outlet_wall_thickness_5015]);
            }
            translate([0, 0, -main_dz_5015-outlet_tolerance_5015-outlet_wall_thickness_5015]) {
              cube([2*outlet_wall_thickness_5015, outlet_dy_5015+outlet_tolerance_5015+2*outlet_wall_thickness_5015, outlet_wall_thickness_5015]);
            }
          }
        }
        // nozzle
        translate([outlet_x_5015-outlet_wall_thickness_5015, outlet_y_5015-outlet_dy_5015-outlet_tolerance_5015/2+(outlet_dy_5015-outlet_inner_dy_5015)/2, -main_dz_5015-outlet_tolerance_5015+(main_dz_5015-outlet_inner_dz_5015)/2]) {
          left_nozzle();
        }
      }
    }
  }
}

module left_nozzle() {
  outlet_area = outlet_inner_dy_5015 * outlet_inner_dz_5015;
  outlet_clearance = 1;
  outlet_nozzle_exit_dx = duct_dy_5015 - outlet_clearance - outlet_wall_thickness_5015;
  outlet_nozzle_exit_dy = (4*outlet_area)/(PI*outlet_nozzle_exit_dx);

  difference() {
    // exterior
    total_dz = outlet_inner_dz_5015 + outlet_tolerance_5015 + 2*outlet_wall_thickness_5015;
    outer_initial_dy = outlet_inner_dy_5015+outlet_tolerance_5015+2*outlet_wall_thickness_5015;
    outer_final_dy = outlet_nozzle_exit_dy+2*outlet_wall_thickness_5015;
    outer_final_dx = outlet_nozzle_exit_dx+outlet_wall_thickness_5015+e;
    union() {
      // additive segment 1
      hull() {
        total_dz = outlet_inner_dz_5015 + outlet_tolerance_5015 + 2*outlet_wall_thickness_5015;
        outer_initial_dy = outlet_inner_dy_5015+outlet_tolerance_5015+2*outlet_wall_thickness_5015;
        outer_final_dy = outlet_nozzle_exit_dy+2*outlet_wall_thickness_5015;
        translate([0, -outlet_wall_thickness_5015+e, 0]) {
          for(i = [0:total_dz/10:total_dz]) {
            dx = (outlet_nozzle_exit_dx/total_dz)*sqrt(pow(total_dz, 2)-pow(i, 2)) + outlet_wall_thickness_5015+e;
            dy = (outer_initial_dy)*(i/total_dz)+outer_final_dy*(total_dz-i)/total_dz;
            nozzle_section(i, dy, dx, true);
          }
        }
      }
      // additive segment 2
      translate([0, -outlet_wall_thickness_5015+e, 0]) {
        hull() {
          nozzle_section(0, outer_final_dy, outer_final_dx, true);
          translate([-outer_final_dx+outlet_wall_thickness_5015, outer_final_dy/4, -total_dz]) {
            nozzle_section(0, outer_final_dy, outer_final_dx, true);
          }
        }
      }
    }
    // subtracted interior
    interior_initial_dy = outlet_inner_dy_5015+outlet_tolerance_5015;
    interior_final_dy = outlet_nozzle_exit_dy;
    // subtractive segment 1
    hull() {
      total_dz = outlet_inner_dz_5015 + outlet_tolerance_5015 + outlet_wall_thickness_5015+e;
      interior_initial_dy = outlet_inner_dy_5015+outlet_tolerance_5015;
      interior_final_dy = outlet_nozzle_exit_dy;
      for(i = [0:total_dz/10:total_dz]) {
        dx = (outlet_nozzle_exit_dx/total_dz)*sqrt(pow(total_dz, 2)-pow(i, 2))+e;
        dy = (interior_initial_dy)*(i/total_dz)+interior_final_dy*(total_dz-i)/total_dz;
        translate([0, 0, -e]) {
          nozzle_section(i, dy, dx, false);
        }
      }
    }
    interior_final_dx = outlet_nozzle_exit_dx+e;
    // subtractive segment 2
    hull() {
      nozzle_section(0, interior_final_dy, interior_final_dx, false);
      translate([-interior_final_dx, interior_final_dy/4, -total_dz-e]) {
        nozzle_section(0, interior_final_dy, interior_final_dx, false);
      }
    }
    // Cut over print bed
    translate([-2*outer_final_dx, -outlet_wall_thickness_5015+e, -total_dz-outlet_wall_thickness_5015-e]) {
      cube([outer_final_dx, (5/4)*outer_final_dy, 2*total_dz+e]);
    }
    cube([outlet_wall_thickness_5015+2*e, outlet_inner_dy_5015+outlet_tolerance_5015, outlet_inner_dz_5015+outlet_tolerance_5015]);
  }
  module nozzle_section(i, dy, dx, additive=true) {
    if (additive) {
      translate([0, 0, i-outlet_wall_thickness_5015]) {
        cube([outlet_wall_thickness_5015+e, dy, e]);
      }
    }
    translate([e, dy/2, i-outlet_wall_thickness_5015]) {
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

