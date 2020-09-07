include <nutsnbolts/cyl_head_bolt.scad>;
include <gantry_plate.scad>;
include <e3d_v6.scad>;
include <fan_4010.scad>;
include <fan_5015.scad>;
include <fan_5015_hoods.scad>;
include <e3d_clamp.scad>;
include <backing.scad>;

$fa=0.5;
$fs=0.5;

tab_dz=9;

extra_x_space = 4;
left_connector_x = saddle_x-box_size_4010/2-extra_x_space-main_dz_5015-intake_5015_side_thickness;
left_connector_y = -plate_height+pin_dy+pin_dia;
left_connector_coords = [left_connector_x, left_connector_y, 0];
connector_e3d_dy = saddle_y - e3d_total_dy - left_connector_y;


gantry_plate();
e3d_clamp_saddle(saddle_coords);
e3d_clamp_u(saddle_coords);
accessory_backing(left_connector_coords=left_connector_coords);
e3d_v6([saddle_x, saddle_y, e3d_z]);
// 4010 fan
*translate([peg_avg_x, saddle_y-saddle_dy/2-box_size_4010/2, e3d_z+saddle_dx/2+2]) {
  fan_4010();
}
// 5015 fans
translate([0, saddle_y-e3d_total_dy, e3d_z]) {
  translate([left_connector_x, 0, 0, ]) { // +main_dz_5015+pin_dia/2, 0, 0]) {
    rotate([-90, 0, 90]) {
      fan_5015_hood(connector_e3d_dy=connector_e3d_dy, include_fan=true);
    }
  }
  *translate([saddle_x+box_size_4010/2+main_dz_5015+extra_x_space, 0, 0]) {
    rotate([-90, 0, 90]) {
      fan_5015_hood(connector_e3d_dy=connector_e3d_dy, include_fan=true);
    }
  }
}

// oem hot-end tip marker
*translate([peg_avg_x, -76, 11]) {
  color([0, 1, 0]) sphere(r=0.25);
}

// screws
translate([0, 0, peg_hole_dz+peg_screw_space]) {
  translate(peg_1_coords) {
    screw("M3x5");
  }
  translate(peg_2_coords) {
    screw("M3x5");
  }
}
translate([0, 0, 3]) {
  translate(hole_1_coords) {
    screw("M3x5");
  }
  translate(hole_2_coords) {
    screw("M3x5");
  }
}
translate(saddle_coords) {
  translate([0, 0, saddle_dz-saddle_overreach]) {
    translate([-saddle_dx/2+clamp_screw_inset, -collar_seg_1_dy-collar_seg_2_dy/2, -u_gap-e]) {
      translate([0, 0, u_screw_dz]) {    
        screw("M3x16");    
      }    
    }    
    translate([saddle_dx/2-clamp_screw_inset, -collar_seg_1_dy-collar_seg_2_dy/2, -u_gap-e]) {
      translate([0, 0, u_screw_dz]) {    
        screw("M3x16");    
      }    
    }    
  }
}
