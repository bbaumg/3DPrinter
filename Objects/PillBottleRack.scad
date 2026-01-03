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
	GitHub:		
	
	History:	
		01/01/2026	Initial creation

	Notes:
		- Nothing special see inline notes below

*/

/****** Variables ******************************************************
***********************************************************************/
bottlesWide = 2;
bottlesDeep = 1;
bottleDiameter = 41;
bottleSpacing = 8;
cupHeight = 20;
cupThickness = 2;
treyThickness = 3;
treyPadding = 3;
treyHoles = true;

// Special variables
$fn = $preview ? 32 : 64;		// 0 is OpenSCAD default

/****** Imports & Includes & Calculations ******************************
***********************************************************************/
include <modules/Modules.scad>

// Global Calculations


/****** The Object *****************************************************
***********************************************************************/
object();
// difference(){
// 	roundedCylinder(d=bottleDiameter+cupThickness*2, h=cupHeight, tr=.5, br=.1,);
// 	filletedCylinder(d=bottleDiameter, h=cupHeight, tr=.5, br=.1, pad=1);
// }

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
		for (i = [0:bottlesWide-1]){
			for (ii = [0:bottlesDeep-1]){
				translate([treyPadding+(i*totalCupAndSpacing),treyPadding+(ii*totalCupAndSpacing),0])
					translate([bottleDiameter/2+cupThickness,bottleDiameter/2+cupThickness,0])
						filletedCylinder(d=bottleDiameter*.75, h=treyThickness, tr=1, br=1, pad=.1, s=60);
			}
		}
	}

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
		roundedCylinder(d=bottleDiameter+cupThickness*2, h=cupHeight, tr=.5, br=.1, s=60);
		filletedCylinder(d=bottleDiameter, h=cupHeight, tr=.5, br=.1, pad=1, s=60);
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