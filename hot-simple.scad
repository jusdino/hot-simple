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

TAB_DZ=9;

EXTRA_X_SPACE = 4;
LEFT_CONNECTOR_X = SADDLE_X-BOX_SIZE_4010/2-EXTRA_X_SPACE-MAIN_DZ_5015-INTAKE_5015_SIDE_THICKNESS;
LEFT_CONNECTOR_Y = -PLATE_HEIGHT+PIN_DY+PIN_DIA;
LEFT_CONNECTOR_COORDS = [LEFT_CONNECTOR_X, LEFT_CONNECTOR_Y, 0];
CONNECTOR_E3D_DY = SADDLE_Y - E3D_TOTAL_DY - LEFT_CONNECTOR_Y;


*union() {
  pin_slot_tester(length=TAB_DZ);
  translate([PIN_DY, 0, TAB_DZ/2]) {
    rotate([0, -90, 0]) {
      pin_tab_tester(length=TAB_DZ);
    }
  }
}

gantry_plate();
e3d_clamp_saddle(SADDLE_COORDS);
e3d_clamp_u(SADDLE_COORDS);
accessory_backing(left_connector_coords=LEFT_CONNECTOR_COORDS);
e3d_v6([SADDLE_X, SADDLE_Y, E3D_Z]);
// 4010 fan
translate([PEG_AVG_X, SADDLE_Y-SADDLE_DY/2-BOX_SIZE_4010/2, E3D_Z+SADDLE_DX/2+2]) {
  fan_4010();
}
// 5015 fans
translate([0, SADDLE_Y-E3D_TOTAL_DY, E3D_Z]) {
  translate([LEFT_CONNECTOR_X, 0, 0, ]) { // +MAIN_DZ_5015+PIN_DIA/2, 0, 0]) {
    rotate([-90, 0, 90]) {
      !fan_5015_hood(connector_e3d_dy=CONNECTOR_E3D_DY, include_fan=false);
    }
  }
//   translate([SADDLE_X+BOX_SIZE_4010/2+MAIN_DZ_5015+EXTRA_X_SPACE, 0, 0]) {
//     rotate([-90, 0, 90]) {
//       fan_5015_hood(connector_e3d_dy=CONNECTOR_E3D_DY, include_fan=true);
//     }
//   }
}

// OEM hot-end tip marker
translate([PEG_AVG_X, -76, 11]) {
  color([0, 1, 0]) sphere(r=0.25);
}

// Screws
translate([0, 0, PEG_HOLE_DZ+PEG_SCREW_SPACE]) {
  translate(PEG_1_COORDS) {
    screw("M3x5");
  }
  translate(PEG_2_COORDS) {
    screw("M3x5");
  }
}
translate(SADDLE_COORDS) {
  translate([0, 0, SADDLE_DZ-SADDLE_OVERREACH]) {
    translate([-SADDLE_DX/2+CLAMP_SCREW_INSET, -COLLAR_SEG_1_DY-COLLAR_SEG_2_DY/2, -U_GAP-e]) {
      translate([0, 0, U_SCREW_DZ]) {    
        screw("M3x16");    
      }    
    }    
    translate([SADDLE_DX/2-CLAMP_SCREW_INSET, -COLLAR_SEG_1_DY-COLLAR_SEG_2_DY/2, -U_GAP-e]) {
      translate([0, 0, U_SCREW_DZ]) {    
        screw("M3x16");    
      }    
    }    
  }
}
