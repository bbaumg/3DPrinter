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
		02/23/2025	refactored filletedCylinder to include tapered cylinders
								reference filletedCylinderV1 to see original

*/

/***********************************************************************
****** Module - screwHole
	Create a hole specifically for a screw to go in.
***********************************************************************/
//screwHole();
module screwHole(screwHole=4.5, screwDepth = 10, screwHead = 9, headTaper = 2.3, screwHeadDepth = 5, s=$fn){
	$fn = s;
	// Common size screws	
		// Taper
    translate([0,0,-headTaper])cylinder(d1=screwHole, d2=screwHead, h = headTaper);
		// Shaft
    translate([0,0,-headTaper-screwDepth+.01])cylinder(d=screwHole, h=screwDepth);
		// Top of head opening
    translate([0,0,-.01]) cylinder(d=screwHead, h=screwHeadDepth);
}

/***********************************************************************
****** Module - screwCounterPan
	Create a hole specifically for a screw to go in.
	!!!!!!! NOT FINISHED
***********************************************************************/
//screwCounterPan();
module screwCounterPan(screwHole=4.5, screwDepth = 10, screwHead = 9, headTaper = 2.3, screwHeadDepth = 5, s=$fn){
	$fn = s;
	// Common size screws
	
    translate([0,0,-headTaper])cylinder(d1=screwHole, d2=screwHead, h = headTaper, $fn=20);
    translate([0,0,-headTaper-screwDepth])cylinder(d=screwHole, h=screwDepth, $fn=10);
    translate([0,0,-headTaper-screwDepth])cylinder(d=screwHole, h=screwDepth, $fn=10);
    translate([0,0,0]) cylinder(d=screwHead, h=screwHeadDepth, $fn=10);
}

/***********************************************************************
****** Module - screwCounterFlush
	Create a hole specifically for a screw to go in.
	!!!!!!! NOT FINISHED
***********************************************************************/
//screwCounterFlush();
module screwCounterFlush(screwHole=4.5, screwDepth = 10, screwHead = 9, headTaper = 2.3, screwHeadDepth = 5, s=$fn){
	$fn = s;
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
//roundedCube(x=50, y=30, z=20, r=5, xyz="all", s=60);
//roundedCube(x=50, y=30, z=20, r=5, xyz="all", s=$fn);
module roundedCube(x=50, y=30, z=20, r=5, xyz="z", s=$fn){
	/* variable definitions
			x = value for x axis
			y = value for y axis
			z = value for z axis
			r = radius
			xyz = axis to have the sides rounded
	*/
	$fn = s;
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
//roundedCylinder(td=100, bd=100, tr= 10, br = .1);
//difference(){roundedCylinder(d=20, h=10, r=1, s=60);filletedCylinder(d=5, h=10, tr=2, br=1, pad=0, s=30);}
module roundedCylinder(d=200, td=0, bd=0, h=100, r=5, tr=0, br=0, s=$fn){
	$fn = s;

	// Calulate for one or two radises
	tRad = tr > 0 ? tr : r;
	bRad = br > 0 ? br : r;
	//echo(tRad, bRad);

	// Calculate for one diamater or two.
	tDia = td > 0 ? td : d;
	bDia = bd > 0 ? bd : d;
	//echo(tDia, bDia);

	hull(){
		//Bottom
		translate([0,0,bRad])rotate_extrude()translate([bDia/2-bRad,0,0])circle(r=bRad);
		//Top
		translate([0,0,h-tRad])rotate_extrude()translate([tDia/2-tRad,0,0])circle(r=tRad);
	}
}

/***********************************************************************
******* Module - filletedCylinder
	Create a cylinder with flared top and/or bottoms.
	Used for making rounded top/bottom holes in objects.
	Usage:
		d = diamater
		td = top diamater.  d will be used if not provided
		dd = bottom diamater.  d will be used if not provided
		h = height
		r = radius of the fillet
		tr = top radius.  r will be used if not provided
		br = bottom radius.  r will be used if not provided
		pad = filler around the radius  5 is usually good unless very small
		s = smoothing.  generally let $fn of the object do the work.
***********************************************************************/
//filletedCylinder();
//filletedCylinder(d=50, h=100, r=5, pad=5, s=$fn);
//filletedCylinder(d=10, h=20, tr=1, br=1, pad=.1, s=60);
//difference(){roundedCylinder();filletedCylinder();}
//difference(){roundedCylinder(d=200, h=100, r=5);filletedCylinder(d=50, h=100, tr=10, br=5, pad=5);}
//difference(){roundedCylinder(d=20, h=10, r=1, s=30);filletedCylinder(d=5, h=10, tr=2, br=1, pad=0, s=30);}
//filletedCylinder(d=50, td=20, bd=60, h=100, tr=10, br=5, pad=5, s=$fn);
//difference(){roundedCylinder(s=60);filletedCylinder(d=50, td=50, bd=20, h=100, tr=10, br=5, pad=5, s=$fn);}
module filletedCylinder(d=50, td=0, bd=0, h=100, tr=0, br=0, r=5, pad=5, s=$fn){
	$fn = s;
	shift = .1;

	// Calulate for one or two radises
	tRad = tr > 0 ? tr : r;
	bRad = br > 0 ? br : r;
	//echo(tRad, bRad);

	// Calculate for one diamater or two.
	tDia = td > 0 ? td : d;
	bDia = bd > 0 ? bd : d;
	//echo(tDia, bDia);

	// Calculate the shift of the radius in due to angle of a cone
  trShift = tDia > bDia ? tRad * tan(atan(((tDia/2)-(bDia/2))/h)) : 0;
	brShift = bDia > tDia ? bRad * tan(atan(((bDia/2)-(tDia/2))/h)) : 0;
	//echo(trShift, brShift);

	translate([0,0,-shift])cylinder(h=h+shift*2, r1=bDia/2, r2=tDia/2);
	if ( bRad > 0 ){
		// bottom
		translate([0,0,-shift])
			difference(){
				rotate_extrude()translate([bDia/2-pad-brShift,0,0])square([bRad+pad, bRad]);
				rotate_extrude()translate([bDia/2+bRad-brShift,bRad,0])circle(r=bRad);
			}
	}
	if ( tRad > 0 ){
		// top
		translate([0,0,h-tRad+shift])
			difference(){
				rotate_extrude()translate([tDia/2-pad-trShift,0,0])square([tRad+pad, tRad]);
				rotate_extrude()translate([tDia/2+tRad-trShift,0,0])circle(r=tRad);
			}
	}
}

		// v1 kept for reference.  No longer used
		// module filletedCylinderV1(d=50, h=100, tr=10, br=5, pad=5, s=$fn){
		// 	$fn = s;
		// 	shift = .1;
		// 	translate([0,0,-shift])cylinder(h=h+shift*2, r=d/2);
		// 	if ( br > 0 ){
		// 		// bottom
		// 		translate([0,0,-shift])
		// 			difference(){
		// 				rotate_extrude()translate([d/2-pad,0,0])square([br+pad, br]);
		// 				rotate_extrude()translate([d/2+br,br,0])circle(r=br);
		// 			}
		// 	}
		// 	if ( tr > 0 ){
		// 		// top
		// 		translate([0,0,h-tr+shift])
		// 			difference(){
		// 				rotate_extrude()translate([d/2-pad,0,0])square([tr+pad, tr]);
		// 				rotate_extrude()translate([d/2+tr,0,0])circle(r=tr);
		// 			}
		// 	}
		// }

/***********************************************************************
******* Module - CylinderFillet
	Fillet the outter circumfrence of a cylinder.
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
