/***************************************
*   Purpose:	Regular use modules
***************************************/

//screwHole();
module screwHole(screwHole=4.5, screwDepth = 10, screwHead = 9, headTaper = 2.3, screwHeadDepth = 5){
	// Common size screws
	
    translate([0,0,-headTaper])cylinder(d1=screwHole, d2=screwHead, h = headTaper, $fn=20);
    translate([0,0,-headTaper-screwDepth])cylinder(d=screwHole, h=screwDepth, $fn=10);
    translate([0,0,-headTaper-screwDepth])cylinder(d=screwHole, h=screwDepth, $fn=10);
    translate([0,0,0]) cylinder(d=screwHead, h=screwHeadDepth, $fn=10);
}

//roundedCube(x=50, y=30, z=20, r=5, xyz="x");
//roundedCube(x=50, y=30, z=20, r=5, xyz="y");
//roundedCube(x=50, y=30, z=20, r=5, xyz="z");
//roundedCube(x=50, y=30, z=20, r=5, xyz="all");
//roundedCylinder(d=200, h=100, r=5);
module roundedCube(x=50, y=30, z=20, r=5, xyz="z"){
	hull(){
		if (xyz == "z") {
			translate([r,r,0])cylinder(h=z, r=r);
			translate([x-r,r,0])cylinder(h=z, r=r);
			translate([r,y-r,0])cylinder(h=z, r=r);
			translate([x-r,y-r,0])cylinder(h=z, r=r);
		} else if (xyz == "y") {
			translate([r,0,r])rotate([-90,0,0])cylinder(h=y, r=r);
			translate([x-r,0,r])rotate([-90,0,0])cylinder(h=y, r=r);
			translate([r,0,z-r])rotate([-90,0,0])cylinder(h=y, r=r);
			translate([x-r,0,z-r])rotate([-90,0,0])cylinder(h=y, r=r);
		} else if (xyz == "x") {
			translate([0,r,r])rotate([0,90,0])cylinder(h=x, r=r);
			translate([0,y-r,r])rotate([0,90,0])cylinder(h=x, r=r);
			translate([0,r,z-r])rotate([0,90,0])cylinder(h=x, r=r);
			translate([0,y-r,z-r])rotate([0,90,0])cylinder(h=x, r=r);
		} else if (xyz == "all") {
			minkowski(){
				translate([r,r,r])cube([x-r*2,y-r*2,z-r*2]);
				sphere(r=r);
			}			
		} else { 
			echo("XYZ not set");
		}
	}
}

//roundedCylinder(d=200, h=100, r=5);
//difference(){roundedCylinder();filletedCylinder();}
module roundedCylinder(d=200, h=100, r=5){
	hull(){
		translate([0,0,r])rotate_extrude()translate([d/2-r,0,0])circle(r=r);
		translate([0,0,h-r])rotate_extrude()translate([d/2-r,0,0])circle(r=r);
	}
}

//filletedCylinder();
//filletedCylinder(d=10, h=20, tr=1, br=1, pad=.1, s=60);
module filletedCylinder(d=50, h=100, tr=10, br=5, pad=5, s=30){
	$fn = s;
	shift = .1;
	//r=5;
	translate([0,0,-shift])cylinder(h=h+shift*2, r=d/2);
	if ( br > 0 ){
		// bottom
		translate([0,0,-shift])
			difference(){
				rotate_extrude()translate([d/2-pad,0,0])square([br+pad, br]);
				rotate_extrude()translate([d/2+br,br,0])circle(r=br);
			}
	}
	if ( tr > 0 ){
		// top
		translate([0,0,h-tr+shift])
			difference(){
				rotate_extrude()translate([d/2-pad,0,0])square([tr+pad, tr]);
				rotate_extrude()translate([d/2+tr,0,0])circle(r=tr);
			}
	}
}

module CylinderFillet(){
}
