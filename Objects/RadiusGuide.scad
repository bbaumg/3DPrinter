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
		??/??/????	Initial creation
		02/17/2025	Restructured code.  Batch exportable now.
								Modular output, and common file formatting

	Notes:
		* For variables with an ** in the notes.  Means it can be overwritten

		If you increase the overallWidth by the same amount as wallThickness 
		with each increasing size, then they will stack nicely.
		
		See exports section for common sizes for radius and width
*/

/****** Variables ******************************************************
***********************************************************************/

shape = "curve";        //"curve" or "flat"
measurement = "in";			//"mm" or "in"
cutout = "1/4";       //** how big should the curve, or angle be?
overallThickness = 6;
wallThickness = 4;
wallHeight = 12;
wallLength = 50;
overallWidth = 100;     //** default = 100.  If radius > 90 then set "radius + 25 + wallLength"
fingerHole = 15;
textSize = 10;
textDepth = .5;         // .5mm is pretty good...

// Special variables
$fn = $preview ? 32 : 64;		// 0 is OpenSCAD default

/****** Imports & Includes & Calculations ******************************
***********************************************************************/
include <modules/Modules.scad>
include <BOSL2/std.scad>
		
/****** The Object *****************************************************
***********************************************************************/
object();

module object(cutout = cutout, overallWidth = overallWidth){
	// Calculations
	cutoutVal = parse_num(cutout);
	radius = measurement == "in" ? cutoutVal * 25.4 : cutoutVal;
	echo(radius);

	textString = measurement == "in" ?
		str(cutout, " in"):
		str(cutout, " mm");
	echo(textString);

	difference(){
		cube([overallWidth, overallWidth, overallThickness]);                   //The main cube
		//Remove the raidus or angle
		if (shape=="curve"){
				translate([radius, radius, -1]) rotate([0,0,180])
						difference(){
								cube([radius + 1, radius + 1, overallThickness + 2]);
								#cylinder(r = radius, h = overallThickness + 2);
						}
		} else if (shape=="flat"){
				#translate([0,0,overallThickness/2]) 
						rotate([0,0,-45])
								cube([radius*2, radius, overallThickness + 2], center = true);
		}
		//Remove the outter curve
		translate([0, 0, -1]) rotate([0,0,0])
				difference(){
						cube(size = [overallWidth + 1, overallWidth + 1, overallThickness + 2]);
						cylinder(r = overallWidth, h = overallThickness + 2);
				}
		//Remove the text
		#translate([overallWidth/6, overallWidth/6, overallThickness-textDepth+.01]) 
				rotate([0,0,0])
						linear_extrude(textDepth) 
								text(text = textString, size = textSize+2);
		//Remove the finger hole
		translate([overallWidth/2,overallWidth/2,-1])
				cylinder(r = fingerHole, h = overallThickness + 2);
	}
	translate([overallWidth-overallWidth/2,-wallThickness,0])sideWall(textString, overallWidth);
	translate([-wallThickness,overallWidth,0])rotate([0,0,-90])sideWall(textString, overallWidth);
}

module sideWall(textString = "", overallWidth = 1){
	difference(){
		cube([overallWidth/2,wallThickness,wallHeight+overallThickness]);
		#translate([5,textDepth-.01,5])rotate([90,0,0])linear_extrude(textDepth)text(text = textString, size = textSize);
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
	object("1/4", 100); //RadiusGuide-1_4
	object("5/16", 106); //RadiusGuide-5_16
	object("3/8", 112); //RadiusGuide-3_8
	object("7/16", 118); //RadiusGuide-7_16
	object("1/2", 124); //RadiusGuide-1_2
	object("3/4", 130); //RadiusGuide-3_4
	object("1", 136); //RadiusGuide-1
	object("1 1/2", 142); //RadiusGuide-1 1_2
	object("1 3/4", 148); //RadiusGuide-1 3_4
	object("2", 154); //RadiusGuide-2
}