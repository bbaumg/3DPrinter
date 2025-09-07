/*
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	Purpose:  Create a spacer to flush mount the shelly BLE switch
	GitHub:		https://github.com/bbaumg/3DPrinter/blob/master/Objects/ShellySwitchBack.scad
	
	History:	
		09/07/2025	Initial creation

	Notes:
		- Switch:  https://us.shelly.com/products/shelly-blu-rc-button-4?utm_source=google&utm_medium=organic&utm_campaign=Google%20May%2025&utm_content=Shelly%20BLU%20RC%20Button%204&srsltid=AfmBOoq12DYrTYY6V_eNJ0h2owDhJB2qVwWpHTZULMgSqNE6oslAbitkSmE

*/

/****** Variables ******************************************************
***********************************************************************/
OutterWidth = 44;						//
OutterHeight = 104;					//
CornerRadius = 8;						//
InnerWidth = 29;						//
InnerHeight = 62;						//
ObjThickness = 6;						//
screwHole = 4;							// size of the screw hole
screwBottom = 8;						// distance of bottom screw hole up from bottom
screwTop = 91;							// distance of top screw hole up from bottom

// Special variables
$fn = $preview ? 32 : 64;		// 0 is OpenSCAD default

/****** Imports & Includes & Calculations ******************************
***********************************************************************/
include <modules/Modules.scad>

// Global Calculations


/****** The Object *****************************************************
***********************************************************************/
object();

module object(){
	// Rendered Calculations
	InnerWidthOffset = (OutterWidth-InnerWidth)/2;
	InnerHeightOffset = (OutterHeight-InnerHeight)/2;
	HoleSideOffset = (OutterWidth-(screwHole*2))/2;

	// Start creating the object
	difference(){
		roundedCube(x=OutterWidth, y=OutterHeight, z=ObjThickness, r=CornerRadius, xyz="z");
		// cutout
		translate([InnerWidthOffset,InnerHeightOffset,-1])roundedCube(x=InnerWidth, y=InnerHeight, z=ObjThickness+2, r=.5, xyz="z");
		// top screw
			translate([HoleSideOffset,screwTop,-1])#roundedCube(x=screwHole*2, y=screwHole, z=ObjThickness+2, r=2, xyz="z");
		// bottom screw
			translate([HoleSideOffset,screwBottom,-1])#roundedCube(x=screwHole*2, y=screwHole, z=ObjThickness+2, r=2, xyz="z");
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