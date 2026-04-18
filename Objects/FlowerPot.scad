/*
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	Purpose:  Parametric flower pot
	GitHub:		
	
	History:	
		04/03/2026	Initial creation

	Notes:
		- nothing special to note

*/

/****** Variables ******************************************************
***********************************************************************/
height = 160;			//
bottomDiam = 160;			//
topDiam = 180;				//
potHoleQty = 7;					//
potHoleDiam = 14;				//
saucerHeight = 20;

// saucerBottomDiam = 100;
// saucerTopDiam = 120;
// saucerHeight = 20;
// saucerGroveQty = 1;
// saucerGroveDiam = 5;
// saucerWallThick = 1.6;			// Used so Saucer is inside diameter based


// Special variables
wallThickness = 1.6;			// Estimated width the spiral vase will be set to
bottomThickness = 2;			// Set thickness of bottom
saucerGap = 1;						// space between pot wall and saucer inner wall
saucerGrovePattern = 7;		// 
saucerGroveDiam = 5;			// 
saucerIntHeight = 5;			//

$fn = $preview ? 32 : 64;		// 0 is OpenSCAD default

/****** Imports & Includes & Calculations ******************************
***********************************************************************/
include <modules/Modules.scad>

// Global Calculations


/****** The Object *****************************************************
***********************************************************************/
object();

module object(height = height, bottomDiam = bottomDiam, topDiam = topDiam, potHoleQty = potHoleQty, 
							potHoleDiam = potHoleDiam, saucerHeight = saucerHeight){
	// Rendered Calculations
	pHeight = height - saucerIntHeight;
	pTopDiam = topDiam;
	pBottomDiam = bottomDiam - (wallThickness *2) - (saucerGap * 2);
	sBottomDiam = bottomDiam;
	sTopDiam = topDiam + (wallThickness *2) - (saucerGap * 2);
	// Start creating the object

	// Create Pot
	difference(){
		// create main pot
		cylinder(h=pHeight, d1=pBottomDiam, d2=pTopDiam);
		// for preview, remove the inner, leave in for final render
		if($preview){translate([0,0,wallThickness])cylinder(h=pHeight, d1=pBottomDiam, d2=pTopDiam);}
		// remove the holes
		if(potHoleQty == 0) {
			// Do nothing
		} else if(potHoleQty == 1 || (potHoleDiam*2)/bottomDiam < .4) {
			// single hole in the center
			// if a single hole or if 2x hole diamater exceeds 40% of bottom diameter.
			translate([0,0,-1])cylinder(h=pHeight+2, d=potHoleDiam);
		} 
		if (potHoleQty > 1) {
			// variable hole based on quantity in a circle around
			for (i = [0:potHoleQty - 1]){
				rotate([0,0,i * (360/potHoleQty)])translate([pBottomDiam/3,0,-1])cylinder(h=pHeight+2, d=potHoleDiam);
			}
		}
	}

	// Create Saucer
	translate([topDiam,0,0])
	difference(){
		cylinder(h=height, d1=sBottomDiam, d2=topDiam);
		// for preview, remove the inner, leave in for final render
		if($preview){translate([0,0,wallThickness])cylinder(h=height, d1=sBottomDiam, d2=topDiam);}
		// cut the top off
		translate([0,0,saucerHeight])cylinder(h=height, d=topDiam*2);
	}

	// Create the offset pattern
	translate([topDiam*2,0,0])
	difference(){
		union(){
			//cylinder(d=saucerIntHeight,h=saucerIntHeight/2);
			for (i = [0:saucerGrovePattern-1]){
				rotate([0,0,i * (360/saucerGrovePattern)])rotate([0,90,0])roundedCylinder(d=saucerGroveDiam, h=pBottomDiam/2, r=saucerIntHeight*2, tr=1, br=.01, s=$fn);	
			}
		}
		translate([0,0,-saucerIntHeight])cylinder(d=topDiam, h=saucerIntHeight);
	}
}

/*Some basic commands
translate([0,0,0])
rotate([0,0,0])
cube([0,0,0]);
difference(){}
a = test ? TrueValue : FalseValue ;  // ternary function
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