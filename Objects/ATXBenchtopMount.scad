/*
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	Purpose:  Benchtop power supply from an old ATX power supply
	GitHub:		https://github.com/bbaumg/3DPrinter/blob/master/Objects/ATXBenchtopMount.scad
	
	History:	
		02/17/2025	Initial creation

	Notes:
		- ATX Standards:  https://landing.coolermaster.com/faq/what-are-the-mounting-hole-dimensions-for-my-atx-power-supply/

*/

/****** Variables ******************************************************
***********************************************************************/
faceHeight = 160;
faceWidth = 90;
faceThick = 3;
faceSpaceX = 8;						// space from left side
faceSpaceY = 15;					// space up from bottom
dispHeight = 27;
dispWidth = 46;
dispSpaceX = faceSpaceX;
dispSpaceY = 10;
fuseDiamater = 11;
plugDiamater = 9;					// binderPost/plug connecter
frameDepth = 200;
frameThick = 3;

// Special variables
$fn = $preview ? 32 : 64;		// 0 is OpenSCAD default

/****** Imports & Includes & Calculations ******************************
***********************************************************************/
include <modules/Modules.scad>

// Calculations


/****** The Object *****************************************************
***********************************************************************/
/* TODO List:
		- USB ports on the front.
*/
//object();
	// Start creating the object
	//face();
	// translate([faceWidth+2,0,0])sides();
	// translate([-frameDepth-2,0,0])sides();
	// translate([0,faceHeight+2,0])topBottom();
	// translate([0,-frameDepth-2,0])topBottom();
	// translate([faceWidth+frameDepth+4,0,0])back();
	//translate([faceWidth+2,0,0])frame();
	//roundedCubeMostly(x=faceWidth, y=faceHeight, z=faceThick, r=1);

/*Some basic commands
translate([0,0,0])
rotate([0,0,0])
*/
test();
module test(){
faceHeight = 50;
faceWidth = 90;
faceThick = 3;
faceSpaceX = 8;						// space from left side
faceSpaceY = 15;					// space up from bottom

dispHeight = 27;
dispWidth = 46;
dispSpaceX = faceSpaceX;
dispSpaceY = 10;
fuseDiamater = 11;
plugDiamater = 9;					// binderPost/plug connecter

frameDepth = 200;
frameThick = 3;

	difference(){
		roundedCubeFlatBottom(x=faceWidth, y=faceHeight, z=faceThick, r=1);
		// Remove screw holes
		// Remove power switch(s)?
		for (i = [0:1:0]){
			echo(i);
			// Remove displays
			translate([dispSpaceX,faceSpaceY+(i*(dispHeight+dispSpaceY)),-1]) cube([dispWidth, dispHeight, faceThick+2]);
			// Remove fuse holes
			translate([faceWidth-faceSpaceX-(fuseDiamater/2),faceSpaceY+(i*(dispHeight+dispSpaceY))+(dispHeight/2),-1]) rotate([0,0,0]) cylinder(d=fuseDiamater, h=faceThick+2);
			// calculate plug placement on X axis
			plugSpaceX = faceSpaceX+dispWidth+(faceWidth-2*faceSpaceX-dispWidth-fuseDiamater)/2;
			// Remove + plug hole
			translate([plugSpaceX,faceSpaceY+(i*(dispHeight+dispSpaceY))+(dispHeight/5*1),-1]) rotate([0,0,0]) cylinder(d=plugDiamater, h=faceThick+2);
			// Remove - plug Hole
			translate([plugSpaceX,faceSpaceY+(i*(dispHeight+dispSpaceY))+(dispHeight/5*4),-1]) rotate([0,0,0]) cylinder(d=plugDiamater, h=faceThick+2);
		}
	}
}

module face(){
	difference(){
		roundedCubeFlatBottom(x=faceWidth, y=faceHeight, z=faceThick, r=1);
		// Remove screw holes
		// Remove power switch(s)?
		for (i = [0:1:2]){
			echo(i);
			// Remove displays
			translate([dispSpaceX,faceSpaceY+(i*(dispHeight+dispSpaceY)),-1]) cube([dispWidth, dispHeight, faceThick+2]);
			// Remove fuse holes
			translate([faceWidth-faceSpaceX-(fuseDiamater/2),faceSpaceY+(i*(dispHeight+dispSpaceY))+(dispHeight/2),-1]) rotate([0,0,0]) cylinder(d=fuseDiamater, h=faceThick+2);
			// calculate plug placement on X axis
			plugSpaceX = faceSpaceX+dispWidth+(faceWidth-2*faceSpaceX-dispWidth-fuseDiamater)/2;
			// Remove + plug hole
			translate([plugSpaceX,faceSpaceY+(i*(dispHeight+dispSpaceY))+(dispHeight/5*1),-1]) rotate([0,0,0]) cylinder(d=plugDiamater, h=faceThick+2);
			// Remove - plug Hole
			translate([plugSpaceX,faceSpaceY+(i*(dispHeight+dispSpaceY))+(dispHeight/5*4),-1]) rotate([0,0,0]) cylinder(d=plugDiamater, h=faceThick+2);
		}
	}
}

//  That won't work...  Too long print time.
module frame(){
screwShaft = 10;
holeDiameter = 10;
holeSpacing = 2;
holePadding = 30;
// Calculations
holesWide = round((faceHeight-(holePadding*2))/(holeDiameter+holeSpacing));
echo(holesWide);
holePaddingY = (faceHeight-(holesWide*(holeDiameter+holeSpacing)-holeSpacing))/2;
echo(holePaddingY);
holesHigh = round((frameDepth-(holePadding*2))/(holeDiameter+holeSpacing));
echo(holesHigh);
holePaddingZ = (frameDepth-(holesHigh*(holeDiameter+holeSpacing)-holeSpacing))/2;;
echo(holePaddingZ);
difference(){
		roundedCube(x=faceWidth, y=faceHeight, z=frameDepth, r=1, xyz="z");
		translate([frameThick,frameThick,-1])roundedCube(x=faceWidth-frameThick*2, y=faceHeight-frameThick*2, z=frameDepth+2, r=1, xyz="z");
		for (i = [0:1:holesWide-1]){
			for (ii = [0:1:holesHigh-1]){
				//echo("i = ", i);
				//echo("ii = ", ii);
				#translate([0,i*(holeDiameter+holeSpacing),ii*(holeDiameter+holeSpacing)])
					translate([0,holePaddingY,holePaddingZ])
						translate([-1,holeDiameter/2,holeDiameter/2])
							rotate([0,90,0])cylinder(d=holeDiameter,h=faceWidth+2, $fn=6);
			}
		}
	}
	translate([screwShaft/2,screwShaft/2,0])cylinder(d=7,h=frameDepth);
}

module sides(){
	roundedCube(x=frameDepth, y=faceHeight, z=faceThick, r=1, xyz="z");
}

module topBottom(){
	roundedCube(x=faceWidth, y=frameDepth, z=faceThick, r=1, xyz="z");
}

module back(){
	roundedCubeFlatBottom(x=faceWidth, y=faceHeight, z=faceThick, r=1);
}

module roundedCubeFlatBottom(x=50, y=30, z=20, r=5, s=$fn){
	assert (r <= z/2, "ERROR: r must be half z or smaller to work properly")
	hull(){
		translate([r,r,0])cylinder(h=z-r, r=r);
		translate([x-r,r,0])cylinder(h=z-r, r=r);
		translate([r,y-r,0])cylinder(h=z-r, r=r);
		translate([x-r,y-r,0])cylinder(h=z-r, r=r);
		translate([r,r,z-r])rotate([-90,0,0])cylinder(h=y-r*2, r=r);
		translate([x-r,r,z-r])rotate([-90,0,0])cylinder(h=y-r*2, r=r);
		translate([r,r,z-r])rotate([0,90,0])cylinder(h=x-r*2, r=r);
		translate([r,y-r,z-r])rotate([0,90,0])cylinder(h=x-r*2, r=r);
	}
}

/****** Batch Export***************************************************
	Use this module to create multiple exports based on rerenderd values
	https://github.com/18107/OpenSCAD-batch-export-stl
	<modules/export.py>
	
	This script searches for "module export()" and individually renders
	and exports each item in it. Each item is expected to be on its own line. 
	The file name will be the comment on the same line, or the module 
	call if no comment exists. All files will be put in a folder with 
	the same name as the scad file it's created from.
***********************************************************************/
module export() {
	//object(x); //file name here.
}

