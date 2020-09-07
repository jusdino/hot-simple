include <functions.scad>;

e = 0.01;
dark_gray = [0.2, 0.2, 0.2];


main_dia_5015 = 48.1;
main_dy_5015 = 51.3;
main_dz_5015 = 15.0;

screw_hole_dia_5015 = 4.5;
screw_mount_dia_5015 = 6.8;
screw_hole_1_coords_5015 = [20.0, 23.0];
screw_hole_2_coords_5015 = [-18.0, -20.0];
screw_hole_tolerance_5015 = 0.3;

outlet_x_5015 = -25.4;
outlet_y_5015 = 51.3-main_dia_5015/2;
outlet_dy_5015 = 20.0;
outlet_inner_dy_5015 = 17.6;
outlet_inner_dz_5015 = 12.2;
outlet_tolerance_5015 = 0.5;


module fan_5015() {
  intake_outer_dia = 31.0;
  intake_inner_dia = 26.0;

  color(dark_gray) {
    difference() {
      union() {
        // main body
        cylinder(h=15, d=48.1);
        // outlet box
        translate([outlet_x_5015, outlet_y_5015-outlet_dy_5015, 0]) {
          difference() {
            cube([-outlet_x_5015, outlet_dy_5015, main_dz_5015]);
            translate([-e, (outlet_dy_5015-outlet_inner_dy_5015)/2, (main_dz_5015-outlet_inner_dz_5015)/2]) {
              cube([-outlet_x_5015+2+e, outlet_inner_dy_5015, outlet_inner_dz_5015]);
            }
          }
        }
        // screw mounts
        for (coords=[screw_hole_1_coords_5015, screw_hole_2_coords_5015]) {
          translate(coords) {
            difference() {
              union() {
                cylinder(h=main_dz_5015, d=screw_mount_dia_5015);
                rotate([0, 0, to_origin_angle(coords)]) {
                  translate([-screw_mount_dia_5015/2, 0, 0]) {
                    cube([screw_mount_dia_5015, length(coords), main_dz_5015]);
                  }
                }
              }
              translate([0, 0, -e]) {
                cylinder(h=main_dz_5015+2*e, d=screw_hole_dia_5015);
              }
            }
          }
        }
        // fit body to outlet
        difference() {
          scale([1, outlet_y_5015/(main_dia_5015/2), 1]) {
            cylinder(h=main_dz_5015, d=main_dia_5015);
          }
          translate([-main_dia_5015/2, -outlet_y_5015-e, -e]) {
            cube([main_dia_5015, -outlet_x_5015+e, main_dz_5015+2*e]);
          }
        }
      }
      difference() {
        translate([0, 0, main_dz_5015/2]) {
          cylinder(h=main_dz_5015+e, d=intake_outer_dia);
        }
        translate([0, 0, main_dz_5015/2-e]) {
          cylinder(h=main_dz_5015+2*e, d=intake_inner_dia);
        }
      }
    }
  }
}

module fan_5015_fit_test() {
  base_x = min([screw_hole_1_coords_5015[0], screw_hole_2_coords_5015[0], outlet_x_5015])-screw_mount_dia_5015/2;
  base_y = min([screw_hole_1_coords_5015[1], screw_hole_2_coords_5015[1], outlet_y_5015])-screw_mount_dia_5015/2;
  base_dx = max([screw_hole_1_coords_5015[0], screw_hole_2_coords_5015[0], outlet_x_5015])-base_x+screw_mount_dia_5015/2;
  base_dy = max([screw_hole_1_coords_5015[1], screw_hole_2_coords_5015[1], outlet_y_5015])-base_y+screw_mount_dia_5015/2;
  base_dz = 0.32;

  screw_peg_dia = screw_hole_dia_5015 - 0.4;
  outlet_cap_thickness = 1.5;
  outlet_cap_tolerance = 0.5;
  outlet_cap_dy = outlet_dy_5015+2*outlet_cap_thickness+outlet_cap_tolerance;
  outlet_cap_dz = main_dz_5015+outlet_cap_thickness+outlet_cap_tolerance;

  color([0.8, 0.2, 0.2]) {
    // base
    translate([base_x, base_y, -base_dz]) {
      cube([base_dx, base_dy, base_dz]);
    }
    // screw hole pegs
    translate(screw_hole_1_coords_5015) {
      cylinder(h=main_dz_5015, d=screw_peg_dia);
    }
    translate(screw_hole_2_coords_5015) {
      cylinder(h=main_dz_5015, d=screw_peg_dia);
    }
    // outlet cap
    translate([outlet_x_5015-outlet_cap_thickness, outlet_y_5015-outlet_dy_5015-outlet_cap_thickness-outlet_cap_tolerance/2, 0]) {
      cube([outlet_cap_thickness, outlet_cap_dy, main_dz_5015+outlet_cap_thickness+outlet_cap_tolerance]);
      cube([2*outlet_cap_thickness, outlet_cap_thickness, outlet_cap_dz]);
      translate([0, outlet_cap_dy-outlet_cap_thickness, 0]) {
        cube([2*outlet_cap_thickness, outlet_cap_thickness, outlet_cap_dz]);
      }
      translate([0, 0, outlet_cap_dz-outlet_cap_thickness]) {
        cube([2*outlet_cap_thickness, outlet_cap_dy, outlet_cap_thickness]);
      }
    }
  }
}
