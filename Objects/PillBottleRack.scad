/*
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	Purpose:  Trey to hold pill bottles
	GitHub:		https://github.com/bbaumg/3DPrinter/blob/master/Objects/PillBottleRack.scad
	
	History:	
		01/01/2026	Initial creation

	Notes:
		- Nothing special see inline notes below

*/

/****** Variables ******************************************************
***********************************************************************/
bottlesWide = 6;					// number of bottles on X axis
bottlesDeep = 2;					// number of bottles on Y axis
bottleDiameter = 39.5;		// diamter measured at top of cup
//bottleCapDiameter = 49; // NOT USED:  diamter of the bottle cap
bottleSpacing = 7;				// Space between cups (not bottles)
cupHeight = 20;						// Height of the cup holding the bottle
cupThickness = 2;					// Thickness of the cup walls
//cupPadding = .5;				// NOT USED:  Future: padding from bottle to cup wall
treyThickness = 3;				// How thick is the trey
treyPadding = 3;					// How much trey around the outter perimeter
treyHoles = true;					// true:false Material saving holes in trey
stacking = true;					// NOT USED:  Make trey base for stacking

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
	totalCupDiameter = bottleDiameter+cupThickness*2;
	totalCupAndSpacing = totalCupDiameter + bottleSpacing;
	totalX = (treyPadding*2)+(totalCupDiameter*bottlesWide)+(bottleSpacing*(bottlesWide-1));
	echo("totalX = ", totalX);
	totalY = (treyPadding*2)+(totalCupDiameter*bottlesDeep)+(bottleSpacing*(bottlesDeep-1));;
	echo("totalY = ", totalY);

	// Start creating the object

	// Trey
	difference(){
		roundedCube(x=totalX, y=totalY, z=treyThickness, r=5, xyz="z");
		// Cutout for the holes
		if (treyHoles == true){
			for (i = [0:bottlesWide-1]){
				for (ii = [0:bottlesDeep-1]){
					translate([treyPadding+(i*totalCupAndSpacing),treyPadding+(ii*totalCupAndSpacing),0])
						translate([bottleDiameter/2+cupThickness,bottleDiameter/2+cupThickness,0])
							filletedCylinder(d=bottleDiameter*.75, h=treyThickness, tr=1, br=1, pad=.1);
				}
			}
		}
	}
	// Add the cups
	for (i = [0:bottlesWide-1]){
		for (ii = [0:bottlesDeep-1]){
			translate([treyPadding+(i*totalCupAndSpacing),treyPadding+(ii*totalCupAndSpacing),treyThickness])cup();
		}
	}
}

// module to create the cup that holds the pill bottle
module cup(){
	translate([bottleDiameter/2+cupThickness,bottleDiameter/2+cupThickness,0])
	difference(){
		roundedCylinder(d=bottleDiameter+cupThickness*2, h=cupHeight, tr=.5, br=.1);
		filletedCylinder(d=bottleDiameter, h=cupHeight, tr=.5, br=.1, pad=1);
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
	// First option is good if you need or rotate the object with simple variables
	// Second option is good if you just want to render the object without rotation
	// Thrid you could just rotate inline.
	//objectExport(x); //<filename.stl>
	// OR
	//object(x); //<filename.stl>
	// OR
	//rotate([0,0,0])object(x); //<filename.stl>
}

// Calls this to make minor tweaks for batch rendering
//   e.g. rotation of the object for best viewing
module objectExport(var1){
	echo("Rendering Export");
	// Allows for rotation of object for best orientation of STL file
	//    Likely need to rotate 90-180 on z axis.
	rotate([0,0,0])object(var1);
}