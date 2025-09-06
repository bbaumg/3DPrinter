/*
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	Purpose:  Hold chsels on a the wall
	GitHub:		https://github.com/bbaumg/3DPrinter/blob/master/Objects/ChiselHolder.scad
	
	History:	
		02/22/2025	Initial creation

	Notes:
		- Nothing special see inline notes below

*/

/****** Variables ******************************************************
***********************************************************************/
toolCount = 4;             // Number of chisels
toolDiameter = 14;          // Diamater of the mount holding the chisel
toolHeight = 8;
toolTaper = 2;              // About how much narrower is the tool at the bottom of hight
toolOpening = 10;           // Width of the opening the slide the chisel in
toolSpacing = 11;            // Spaceing between chisels
toolWall = 5;
mountHeight = 40;							// How tall should the mounting plate be
mountThick = 4;								// How thick should the mounting plate be
screwHole = 4;								// size of the screw hole

// Special variables
$fn = $preview ? 32 : 64;		// 0 is OpenSCAD default
filletRadius = 1;

/****** Imports & Includes & Calculations ******************************
***********************************************************************/
include <modules/Modules.scad>

// Global Calculations
toolWidth = toolDiameter + toolWall*2;
echo("Tool Width:", toolWidth);

/****** The Object *****************************************************
***********************************************************************/
object();

module object(toolCount = toolCount){
	// Rendered Calculations
	mountWidth = (toolWidth + toolSpacing) * toolCount + toolSpacing;
	echo("Mount Width: ", mountWidth);
	translate([0,filletRadius,0])
		difference(){
			translate([-toolSpacing,-mountThick,0])
				roundedCube(x=mountWidth, y=mountThick, z=mountHeight, r=filletRadius, xyz="all");
			#translate([-toolSpacing+screwHole*2,filletRadius,mountHeight-screwHole*2])rotate([90,0,0])cylinder(d=screwHole, h=mountThick+2);
			#translate([mountWidth-screwHole*2-toolSpacing,filletRadius,mountHeight-screwHole*2])rotate([90,0,0])cylinder(d=screwHole, h=mountThick+2);
		}
	for (i = [0:1:toolCount-1]){
		toolHolder(i);
	}
}

module toolHolder(i){
	difference(){
		translate([toolWall+(toolWidth + toolSpacing)* i,0,0])roundedCube(x=toolDiameter, y=toolSpacing+toolWall, z=toolHeight, r=filletRadius, xyz="y");
		translate([toolWidth/2+(toolWidth + toolSpacing)* i,toolWidth/2+toolSpacing,-1])cylinder(d=toolDiameter+toolWall, h=toolHeight+2);
	}
	translate([toolWidth/2,0,0]){
		translate([(toolWidth + toolSpacing)* i,toolWidth/2+toolSpacing,0])
			difference(){
				roundedCylinder(d=toolDiameter+toolWall*2, h=toolHeight, r=1, s=60);
				filletedCylinder(td=toolDiameter, bd=toolDiameter-toolTaper, h=toolHeight, tr=2, br=1, pad=0, s=$fn);
				translate([-toolOpening/2,0,-1])cube([toolOpening,toolWall*4,toolHeight+2]);
			}
	}
}

/*Some basic commands
translate([0,0,0])
rotate([0,0,0])
cube([0,0,0])
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
	objectExport(3); //ChiselHolder-3
	objectExport(4); //ChiselHolder-4
	objectExport(5); //ChiselHolder-5
	objectExport(6); //ChiselHolder-6
	objectExport(7); //ChiselHolder-7
	objectExport(8); //ChiselHolder-8
	objectExport(9); //ChiselHolder-9
}

// Calls this to make minor tweaks for batch rendering
//   e.g. rotation of the object for best viewing
module objectExport(toolCount){
	echo("Rendering Export");
	// Allows for rotation of object for best orientation of STL file
	//    Likely need to rotate 90-180 on z axis.
	rotate([0,0,180])object(toolCount);
}

