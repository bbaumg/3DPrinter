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
		- Inspired by: https://www.printables.com/model/526785-screwdriver-holder/files

*/

/****** Variables ******************************************************
***********************************************************************/
driverArms = 5;							// The number of arms. PS It always starts with a long arm
driverSpacingOn = 50;					// how far apart should holders be on the same arm
driverSpacingBetween = 25;		// how far apart should arms be
shaftDiameter = 14;						// size of the hole in the holder
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
shaftRadius = shaftDiameter/2;
holderDiameter = shaftDiameter + holderWall *2;
holderRadius = holderDiameter/2;

/****** The Object *****************************************************
***********************************************************************/

object();		

module object(driverArms = driverArms){
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
	mountWidth = (driverArms) * driverSpacingBetween;
	difference(){
		translate([-holderWall,-mountThick+filletRadius,0])
			roundedCube(x=mountWidth, y=mountThick, z=mountHeight, r=filletRadius, xyz="all");
		#translate([+holderWall,filletRadius,mountHeight-screwHole*2])rotate([90,0,0])cylinder(d=screwHole, h=mountThick+2);
		#translate([mountWidth-holderWall-screwHole*2,filletRadius,mountHeight-screwHole*2])rotate([90,0,0])cylinder(d=screwHole, h=mountThick+2);
	}
}

module toolHolder(){
	// create each of the barrel shapped holders
	difference(){
		roundedCylinder(d=holderDiameter, h=shaftHeight, r=filletRadius);
		filletedCylinder(d=shaftDiameter, h=shaftHeight, tr=filletRadius*2, br=filletRadius);
	}	
}

module shortArm(){
	difference(){
		//support arm
		roundedCube(x=shaftDiameter, y=driverSpacingOn, z=shaftHeight, r=filletRadius, xyz="y");
		// cutout the end of the arm so it does not mess with tool holder.
		translate([shaftRadius,driverSpacingOn,-1])cylinder(d=shaftDiameter+holderWall, h=shaftHeight+2);
	}
	// end tool holder
	translate([shaftRadius,driverSpacingOn,0]) toolHolder();
}

module longArm(){
	difference(){
		//support arm
		roundedCube(x=shaftDiameter, y=driverSpacingOn*1.5, z=shaftHeight, r=filletRadius, xyz="y");
		// cutout the end and middle of the arm so it does not mess with tool holders.
		translate([shaftRadius,driverSpacingOn/2,-1])cylinder(d=shaftDiameter+holderWall, h=shaftHeight+2);
		translate([shaftRadius,driverSpacingOn*1.5,-1])cylinder(d=shaftDiameter+holderWall, h=shaftHeight+2);
	}
	// middle tool holder
	translate([shaftRadius,driverSpacingOn/2,0]) toolHolder();
	// end tool holder
	translate([shaftRadius,driverSpacingOn*1.5,0]) toolHolder();
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
	object(4); //ScrewdriverHolder-4
	object(5); //ScrewdriverHolder-5
	object(6); //ScrewdriverHolder-6
	object(7); //ScrewdriverHolder-7
	object(8); //ScrewdriverHolder-8
	object(9); //ScrewdriverHolder-9
	object(10); //ScrewdriverHolder-10
	object(11); //ScrewdriverHolder-11
}















