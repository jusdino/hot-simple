e=0.01;
part_gap=0.1;

pin_dia=3;
pin_dy=20;

bump_dx=0.6;
bump_dia=3;

module pin_tab_tester(length=9) {
  pin_dia=pin_dia;
  pin_dy=pin_dy;
  tab_dz=length;
  tab_dx=pin_dia/2;

  backing_thickness=2*pin_dia;

  pin_tab(length=length);
  translate([-tab_dx, -pin_dia, -backing_thickness*2]) {
    cube([backing_thickness, pin_dy+2*pin_dia, backing_thickness*2]);
  }
}

module pin_slot_tester(length) {
  box_dx=2*pin_dia;
  box_back_dz=1;
  box_dz=tab_dz+box_back_dz+part_gap;

  pin_slot(length=length);
  translate([-box_dx, -box_dx/2, -box_dx]) {
    cube([box_dx*2, pin_dy+box_dx, box_dx]);
  }
}

module pin_tab_base(length, subtractive=false) {
  pin_dia=pin_dia;
  pin_dy=pin_dy;
  tab_dz=subtractive ? length+part_gap+e : length;
  tab_dx=pin_dia/2;
  translate([-tab_dx, -pin_dia/2, 0]) {
    cube([tab_dx, pin_dy+pin_dia, tab_dz]);
  }
  cylinder(h=tab_dz, d=pin_dia);
  translate([0, pin_dy, 0]) {
    cylinder(h=tab_dz, d=pin_dia);
  }
}

module pin_tab(length) {
  pin_dia=pin_dia;
  pin_dy=pin_dy;
  tab_dz=length;
  tab_dx=pin_dia/2;

  difference() {
    pin_tab_base(length);
    translate([0, pin_dy/2, tab_dz-bump_dia]) {
      rotate([0, 0, 180]) {
        bump(h=bump_dx, d=bump_dia);
      }
    }
  }
}

module pin_slot(length) {
  box_back_dz=1;

  difference() {
    pin_slot_profile(length=length+box_back_dz+part_gap);
    translate([0, 0, box_back_dz]) {
      pin_tab_base(subtractive=true);
    }
  }
  translate([0, pin_dy/2, bump_dia]) {
    rotate([0, 0, 180]) {
      bump(h=bump_dx, d=bump_dia);
    }
  }
}

module pin_slot_profile(length) {
  box_dx=2*pin_dia;
  box_dz=length;
  union() {
    cylinder(h=box_dz, d=box_dx);
    translate([0, pin_dy, 0]) {
      cylinder(h=box_dz, d=box_dx);
    }
    translate([-pin_dia, 0, 0]) {
      cube([box_dx, pin_dy, box_dz]);
      translate([0, -box_dx/2, 0]) {
        cube([box_dx/2, pin_dy+box_dx, box_dz]);
      }
    }
  }
}

module bump(h, d) {
  dia=(pow(d/2, 2) + pow(h, 2))/(2*h)*2;
  inset=dia/2-h;
  difference() {
    translate([-inset, 0, 0]) {
      sphere(d=dia);
    }
    translate([-dia-e, -dia/2, -dia/2]) {
      cube([dia, dia, dia]);
    }
  }
}
