
/*
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	Purpose:  Create small numbered tags to zip tag to objects for inventroy
	GitHub:		https://github.com/bbaumg/3DPrinter/blob/master/Objects/IDTagNumber.scad
	
	History:	
		04/08/2024	Initial creation
		03/01/2026	Cleaned up code a bit.

	Notes:
		- Note to self:  Last printed 21-40

*/

/****** Variables ******************************************************
***********************************************************************/

tagWidth = 25;
tagHeight = tagWidth * 1.618;
tagThick = 2;
tagEdge = 2;
cornerRadius = 2;
holeWidth = 5;
holeHeight = 2;
holeSpace = 2.5;  // how far from the edge should the hole be.
textDepth = .5;
textSize = 15;
starting = 21;
quantity = 19;

// Special variables
$fn = $preview ? 32 : 64;		// 0 is OpenSCAD default

/****** Imports & Includes & Calculations ******************************
***********************************************************************/
include <modules/RoundedCube.scad>

// Global Calculations
ending = starting + quantity;

/****** The Object *****************************************************
***********************************************************************/

for (i=[starting:ending]){
	translate([tagWidth*i+5*i, 0, 0])tag(i);
}

module tag(i=0){
	difference(){
		roundedsquare(x=tagWidth, y=tagHeight, z=tagThick, radius=cornerRadius);
		translate([tagEdge,tagEdge,tagThick-textDepth+.1])
			roundedsquare(x=tagWidth-2*tagEdge, y=tagHeight-2*tagEdge, z=textDepth, radius=cornerRadius);
		translate([tagWidth/2-holeWidth/2, tagHeight-holeHeight-holeSpace, 0])
			roundedsquare(x=holeWidth, y=holeHeight, z=tagThick, radius = 1);
	}
	translate([tagWidth/2,tagHeight/2,tagThick-textDepth])rotate([0,0,90])
		linear_extrude(textDepth) text(str(i), size = textSize, halign="center", valign="center", font="Stencil");
}