/*
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	Purpose:  Hold general use modules for to simplify making of objects
	
	History:	
		01/25/2024	Initial creation
		02/17/2025	Added modules for roundedCube, roundedCylinder
								and FilletedCylinder

*/

/***********************************************************************
****** Module - screwHole
	Create a hole specifically for a screw to go in.
***********************************************************************/
//screwHole();
module screwHole(screwHole=4.5, screwDepth = 10, screwHead = 9, headTaper = 2.3, screwHeadDepth = 5){
	// Common size screws
	
    translate([0,0,-headTaper])cylinder(d1=screwHole, d2=screwHead, h = headTaper, $fn=20);
    translate([0,0,-headTaper-screwDepth])cylinder(d=screwHole, h=screwDepth, $fn=10);
    translate([0,0,-headTaper-screwDepth])cylinder(d=screwHole, h=screwDepth, $fn=10);
    translate([0,0,0]) cylinder(d=screwHead, h=screwHeadDepth, $fn=10);
}

/***********************************************************************
****** Module - roundedCube
	4 various ways to make a cube with soft rounded sides.
***********************************************************************/
//roundedCube(x=50, y=30, z=20, r=5, xyz="x");
//roundedCube(x=50, y=30, z=20, r=5, xyz="y");
//roundedCube(x=50, y=30, z=20, r=5, xyz="z");
//roundedCube(x=50, y=30, z=20, r=5, xyz="all");
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

/***********************************************************************
******* Module - roundedCylinder
	Create a cylinder with nice rounded outter top and bottom
***********************************************************************/
//roundedCylinder();
//roundedCylinder(d=200, h=100, r=5);
//difference(){roundedCylinder(d=20, h=10, r=1, s=60);filletedCylinder(d=5, h=10, tr=2, br=1, pad=0, s=30);}
module roundedCylinder(d=200, h=100, r=5, s=$fn){
	$fn = s;
	hull(){
		translate([0,0,r])rotate_extrude()translate([d/2-r,0,0])circle(r=r);
		translate([0,0,h-r])rotate_extrude()translate([d/2-r,0,0])circle(r=r);
	}
}

/***********************************************************************
******* Module - filletedCylinder
	Create a cylinder with flared top and/or bottoms.
	Used for making rounded top/bottom holes in objects.
***********************************************************************/
//filletedCylinder();
//filletedCylinder(d=10, h=20, tr=1, br=1, pad=.1, s=60);
//difference(){roundedCylinder(d=200, h=100, r=5);filletedCylinder(d=50, h=100, tr=10, br=5, pad=5);}
//difference(){roundedCylinder(d=20, h=10, r=1, s=30);filletedCylinder(d=5, h=10, tr=2, br=1, pad=0, s=30);}
module filletedCylinder(d=50, h=100, tr=10, br=5, pad=5, s=$fn){
	$fn = s;
	shift = .1;
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

/***********************************************************************
******* Module - CylinderFillet
***********************************************************************/
//difference(){cylinder(h=20, d=100);cylinderFillet(d = 100, r=5);}
/*difference(){
	cylinder(h=20, d=100);
	cylinderFillet(d = 100, r=5);
	translate([0,0,20])rotate([180,0,0])cylinderFillet(d = 100, r=5, s=60);
}*/
module cylinderFillet(d = 100, r=5, s=$fn){
		$fn = s;
		pad = 0.1;	// Padding to maintain manifold
		translate([0,0,0])
		difference() {
				rotate_extrude(convexity=10)
						translate([d/2-r+pad,-pad,0])
								square(r+pad,r+pad);
				#rotate_extrude(convexity=10)
						translate([d/2-r,r,0])
								circle(r=r);
		}
}
