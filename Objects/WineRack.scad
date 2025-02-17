/*
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	Purpose:  
	
	History:	
		MM/DD/YYYY	Initial creation

	Notes:
		- Nothing special see inline notes below

*/

/****** Variables ******************************************************
***********************************************************************/

length = 200;       // total lenght
width = 40;         // total width
height = 12;        // total height
base = 10;          // offset approximate width of base
thickness = .5;     // how thick is the main part, but that is not a real number...
slopeInner = 10;    // degrees of angle for inner cutout
slopeOutter = 5;    // degrees of angle for the outter (bottom)side
innerBevel = 30;    // degrees of angle for the inside bevel
outterBevel = 20;   // angle to remove some outside material
screwOffset = 20;   // how far to move the srew in from the end
screwDepth = 5;     // how deep to set the screw

// Special variables
$fn = $preview ? 32 : 64;		// 0 is OpenSCAD default

/****** Imports & Includes & Calculations ******************************
***********************************************************************/
include <modules/Modules.scad>

// Calculations


/****** The Object *****************************************************
***********************************************************************/

object();

module object(length=length){
	difference(){
			cube([width, length, height]);
			// Remove the top inner section
			translate([-base,0,thickness]) rotate([0,-slopeInner,0]) cube([width, length, height]);
			// Remove the bottom slope
			translate([0,0,-height]) rotate([0,-slopeOutter,0]) cube([width*2, length, height]);
			// Remove the inner bevel
			translate([0,0,0]) rotate([0,-innerBevel,0]) cube([width, length, height]);
			// Remove the outter bevel
			translate([width,0,height]) rotate([0,outterBevel+90,0]) cube([width, length, height*2]);
			// Remove the front screw
			translate([width-(base/2),screwOffset,screwDepth]) rotate([180,0,0]) screwHole();  // Screw hole
			translate([width-(base/2),length-screwOffset,screwDepth]) rotate([180,0,0]) screwHole();  // Screw head
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
	object(100); //WineRack-100
	object(150); //WineRack-150
	object(200); //WineRack-200
}

