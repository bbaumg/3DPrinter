/*
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	Purpose:  Create nice caulk bead and do it in tight spaces.
	GitHub:		
	
	History:	
		11/10/2025	Initial creation

	Notes:
		- Nothing special see inline notes below

*/

/****** Variables ******************************************************
***********************************************************************/
radius1 = 3;						//
radius2 = 4;						//
radius3 = 5;						//
radius4 = 6;						//
objHeight = 100;
objWidth = 16;
objThick = 3;

// Special variables
$fn = $preview ? 32 : 64;		// 0 is OpenSCAD default

/****** Imports & Includes & Calculations ******************************
***********************************************************************/
include <modules/Modules.scad>

// Global Calculations


/****** The Object *****************************************************
***********************************************************************/
object(objHeight, objWidth, objThick, radius1, radius2, radius3, radius4);

module object(x,y, z, r1, r2, r3, r4){
	// Rendered Calculations
	
	// Start creating the object
	
	hull(){
		translate([r1,r2,0])cylinder(h=z, r=r1);
		translate([x-r2,r3,0])cylinder(h=z, r=r2);
		translate([r3,y-r3,0])cylinder(h=z, r=r3);
		translate([x-r4,y-r4,0])cylinder(h=z, r=r4);
	}
}

/*Some basic commands
translate([0,0,0])
rotate([0,0,0])
cube([0,0,0]);
difference(){}
*/



/****** Batch Export***************************************************
	Use this module to create multiple exports based on rerenderd values
	https://github.com/bbaumg/3DPrinter/blob/master/export.py
	<modules/export.py>
	
	This script searches for "module export()" and individually renders
	and exports each item in it. Each item is expected to be on its own line. 
	The file name will be the comment on the same line, or the module 
	call if no comment exists. All files will be put in a folder with 
	the same name as the scad file it's created from.
***********************************************************************/
module export() {
	//objectExport(x); //<filename.stl>
}

// Calls this to make minor tweaks for batch rendering
//   e.g. rotation of the object for best viewing
module objectExport(var1){
	echo("Rendering Export");
	// Allows for rotation of object for best orientation of STL file
	//    Likely need to rotate 90-180 on z axis.
	rotate([0,0,0])object(var1);
}