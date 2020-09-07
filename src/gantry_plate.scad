e=0.1;

plate_width=64.0;
plate_height=44.6;
plate_thickness=2.5;

corner_radius=9;

bottom_tab_width = 24;
bottom_tab_height = 18.6;

hole_1_coords = [13.1, -33.1, 0];
hole_2_coords = [30.4, -14.2, 0];

peg_1_coords = [41.5, -24.5, 0];
peg_2_coords = [55.6, -24.5, 0];
peg_dia=5.3;
peg_dz=4.4;


wheel_screw_1_coords = [12.1, -11.9, 0];
wheel_screw_2_coords = [51.9, -11.4, 0];
wheel_screw_3_coords = [plate_width/2, -(plate_height+bottom_tab_height-bottom_tab_width/2), 0];


module gantry_plate() {

  color([0.1, 0.1, 0.1]) {
    m3_screw_peg(peg_1_coords, plate_thickness) {
      m3_screw_peg(peg_2_coords, plate_thickness) {
        m3_screw_hole(hole_1_coords, plate_thickness) {
          m3_screw_hole(hole_2_coords, plate_thickness) {
            translate([0, -plate_height, -plate_thickness]) {
              difference() {
                // main section
                cube([plate_width, plate_height, plate_thickness]);
                // rounded corners
                translate([-e, plate_height-corner_radius+e, -e]) {
                  difference() {
                    cube([corner_radius+e, corner_radius+e, plate_thickness+2*e]);
                    translate([corner_radius, 0, -e]) {
                      cylinder(h=plate_thickness+4*e, r=corner_radius);
                    }
                  }
                }
                translate([plate_width-corner_radius+e, plate_height-corner_radius+e, -e]) {
                  difference() {
                    cube([corner_radius+e, corner_radius+e, plate_thickness+2*e]);
                    translate([0, 0, -e]) {
                      cylinder(h=plate_thickness+4*e, r=corner_radius);
                    }
                  }
                }
              }
              // round tab on bottom
              translate([plate_width/2-bottom_tab_width/2, -(bottom_tab_height-bottom_tab_width/2), 0]) {
                cube([bottom_tab_width, bottom_tab_height-bottom_tab_width/2, plate_thickness]);
                translate([bottom_tab_width/2, 0, 0]) {
                  cylinder(d=bottom_tab_width, h=plate_thickness);
                }
              }
            }
          }
        }
      }
    }
  }
  color([0.7, 0.7, 0.7]) m5_button_cap(wheel_screw_1_coords, plate_thickness);
  color([0.7, 0.7, 0.7]) m5_button_cap(wheel_screw_2_coords, plate_thickness);
  color([0.7, 0.7, 0.7]) m5_nut_end(wheel_screw_3_coords, plate_thickness);
}

module m3_screw_hole(coords, length) {
  screw_dia=3;

  difference() {
    children();
    translate([coords[0], coords[1], coords[2]-length-e]) {
      cylinder(d=screw_dia, h=length+2*e);
    }
  }
}

module m3_screw_peg(coords, length) {
  m3_screw_hole([coords[0], coords[1], coords[2]+peg_dz], length+peg_dz) {
    union() {
      translate([coords[0], coords[1], coords[2]]) {
        cylinder(d=peg_dia, h=peg_dz);
      }
      children();
    }
  }
}

module m5_button_cap(coords, length) {
  head_dia=9.2;
  screw_dia=5;
  head_height=2;
  allen_size=2.5;
  allen_depth=1.5;

  translate([coords[0], coords[1], coords[2]]) {
    translate([0, 0, head_height/2]) {
      difference() {
        union() {
          scale([head_dia/10, head_dia/10, head_height/10]) {
            sphere(d=10);
          }
          translate([0, 0, -head_height/2]) {
            cylinder(d=head_dia, h=head_height/2);
          }
        }
        translate([0, 0, head_height/2+e-allen_depth]) {
          nut(allen_size, allen_depth);
        }
      }
    }
    translate([0, 0, -length-e]) {
      cylinder(d=5, h=length+2*e);
    }
  }
}

module m5_nut_end(coords, length) {
  nut_size=8;
  nut_height=4.7;
  screw_dia=5;
  screw_excess=2;

  translate([coords[0], coords[1], coords[2]]) {
    nut(nut_size, nut_height);
    translate([0, 0, -length-e]) {
      cylinder(d=screw_dia, h=length+nut_height+screw_excess+e);
    }
  }
}

module nut(size, height) {
  cylinder($fn=6, d=size*(2/sqrt(3)), h=height);
}

module gantry_fit_test() {
  thickness=0.32;

  color([0.8, 0.2, 0.2]) {
    translate([0, 0, plate_thickness+2*e]) {
      difference() {
        translate([0, -plate_height, 0]) {
          cube([plate_width, plate_height, thickness]);
        }
        translate([hole_1_coords[0], hole_1_coords[1], hole_1_coords[2]-e]) {
          cylinder(d=4, h=thickness+2*e);
        }
        translate([hole_2_coords[0], hole_2_coords[1], hole_2_coords[2]-e]) {
          cylinder(d=4, h=thickness+2*e);
        }
        translate([peg_1_coords[0], peg_1_coords[1], peg_1_coords[2]-e]) {
          cylinder(d=6, h=thickness+2*e);
        }
        translate([peg_2_coords[0], peg_2_coords[1], peg_2_coords[2]-e]) {
          cylinder(d=6, h=thickness+2*e);
        }
        translate([wheel_screw_1_coords[0], wheel_screw_1_coords[1], wheel_screw_1_coords[2]-e]) {
          cylinder(d=10, h=thickness+2*e);
        }
        translate([wheel_screw_2_coords[0], wheel_screw_2_coords[1], wheel_screw_2_coords[2]-e]) {
          cylinder(d=10, h=thickness+2*e);
        }
      }
    }
  }
}

