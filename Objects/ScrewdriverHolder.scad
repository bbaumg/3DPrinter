/*
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	About:  arms for holding screwdrivers.
	
	History:	
		02/17/2025	Initial creation
	
	Notes:
		- Nothing special see inline notes below

*/

/****** Variables ******************************************************
***********************************************************************/
driverArms = 5;							// The number of arms. PS It always starts with a long arm
driverSpacingOn = 50;					// how far apart should holders be on the same arm
driverSpacingBetween = 25;		// how far apart should arms be
shaftDiamater = 14;						// size of the hole in the holder
shaftHeight = 25;							// Height of the holder arm and shaft of tool
holderWall = 5;								// thickness of the wall on the tool holder.
mountHeight = 40;							// How tall should the mounting plate be
mountThick = 3;								// How thick should the mounting plate be
screwHole = 4;								// size of the screw hole

// Special variables
$fn = $preview ? 32 : 64;			// 0 is OpenSCAD default
filletRadius = 1;							// this will adjust the overall roundness of edges.

/****** Imports & Includes & Calculations ******************************
***********************************************************************/
include <modules/Modules.scad>

// Calculations
shaftRadius = shaftDiamater/2;
holderDiamater = shaftDiamater + holderWall *2;
holderRadius = holderDiamater/2;
mountWidth = (driverArms) * driverSpacingBetween;
echo(mountWidth);

/****** The Object *****************************************************
***********************************************************************/

// Loop through and create all the arms.
	// Long Arm
for (i = [0:2:driverArms-1]){
	translate([driverSpacingBetween*i,0,0]) longArm();
}
	// Short Arm
for (i = [1:2:driverArms-1]){
	translate([driverSpacingBetween*i,0,0]) shortArm();
}

// Mounting plate
difference(){
	translate([-holderWall,-mountThick+filletRadius,0])
		roundedCube(x=mountWidth, y=mountThick, z=mountHeight, r=filletRadius, xyz="all");
	#translate([+holderWall,filletRadius,mountHeight-screwHole*2])rotate([90,0,0])cylinder(d=screwHole, h=mountThick+2);
	#translate([mountWidth-holderWall-screwHole*2,filletRadius,mountHeight-screwHole*2])rotate([90,0,0])cylinder(d=screwHole, h=mountThick+2);
}

module toolHolder(){
	// create each of the barrel shapped holders
	difference(){
		roundedCylinder(d=holderDiamater, h=shaftHeight, r=filletRadius);
		filletedCylinder(d=shaftDiamater, h=shaftHeight, tr=filletRadius*2, br=filletRadius);
	}	
}

module shortArm(){
	difference(){
		//support arm
		roundedCube(x=shaftDiamater, y=driverSpacingOn, z=shaftHeight, r=filletRadius, xyz="y");
		// cutout the end of the arm so it does not mess with tool holder.
		translate([shaftRadius,driverSpacingOn,-1])cylinder(d=shaftDiamater+holderWall, h=shaftHeight+2);
	}
	// end tool holder
	translate([shaftRadius,driverSpacingOn,0]) toolHolder();
}

module longArm(){
	difference(){
		//support arm
		roundedCube(x=shaftDiamater, y=driverSpacingOn*1.5, z=shaftHeight, r=filletRadius, xyz="y");
		// cutout the end and middle of the arm so it does not mess with tool holders.
		translate([shaftRadius,driverSpacingOn/2,-1])cylinder(d=shaftDiamater+holderWall, h=shaftHeight+2);
		translate([shaftRadius,driverSpacingOn*1.5,-1])cylinder(d=shaftDiamater+holderWall, h=shaftHeight+2);
	}
	// middle tool holder
	translate([shaftRadius,driverSpacingOn/2,0]) toolHolder();
	// end tool holder
	translate([shaftRadius,driverSpacingOn*1.5,0]) toolHolder();
}

















