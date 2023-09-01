

$fn = 20;

module roundedsquare(x=20, y=20, z=20, radius=3) {
	difference(){
		cube([x,y,z]);
		translate([0,0,0]) rotate([0,0,0]) fillet(radius,z);
		translate([x,0,0]) rotate([0,0,90]) fillet(radius,z);
		translate([x,y,0]) rotate([0,0,180]) fillet(radius,z);
		translate([0,y,0]) rotate([0,0,270]) fillet(radius,z);	
	}
}

module roundedcube(x=20, y=20, z=20, radius=3) {
	difference(){
		cube([x,y,z]);
		// fillet along z axis
		translate([0,0,0]) rotate([0,0,0]) fillet(radius,z);
		translate([x,0,0]) rotate([0,0,90]) fillet(radius,z);
		translate([x,y,0]) rotate([0,0,180]) fillet(radius,z);
		translate([0,y,0]) rotate([0,0,270]) fillet(radius,z);
		// fillet along x axis
		translate([0,0,0]) rotate([90,0,90]) fillet(radius,z);
		translate([0,0,z]) rotate([90,90,90]) fillet(radius,z);
		translate([0,y,z]) rotate([90,180,90]) fillet(radius,z);
		translate([0,y,0]) rotate([90,270,90]) fillet(radius,z);
		// fillet along y axis
		translate([0,0,0]) rotate([-90,270,0]) fillet(radius,z);
		translate([x,0,0]) rotate([-90,180,0]) fillet(radius,z);
		translate([x,0,z]) rotate([-90,90,0]) fillet(radius,z);
		translate([0,0,z]) rotate([-90,0,0]) fillet(radius,z);
	}
}

module fillet(radius = 1, height = 1){
    translate([radius, radius, -1]) rotate([0,0,180])
        difference(){
            cube([radius + 1, radius + 1, height + 2]);
            cylinder(r = radius, h = height + 2);
        }
}

//roundedsquare();