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
wallThickness = 1.6;		// Estimated width the spiral vase will be set to
height = 50;			//
bottomDiam = 50;			//
topDiam = 60;				//
potHolePattern = 1;					// (1: Single Hole, 3: 3 holes, 5: 5 holes)
potHoleDiam = 10;				//
withSaucer = true;
saucerGap = 1;
saucerHeight = 20;
saucerGroveQty = 1;
saucerGroveDiam = 5;
saucerIntHeight = 5;

// saucerBottomDiam = 100;
// saucerTopDiam = 120;
// saucerHeight = 20;
// saucerGroveQty = 1;
// saucerGroveDiam = 5;
// saucerWallThick = 1.6;			// Used so Saucer is inside diameter based


// Special variables
$fn = $preview ? 32 : 64;		// 0 is OpenSCAD default

/****** Imports & Includes & Calculations ******************************
***********************************************************************/
include <modules/Modules.scad>

// Global Calculations


/****** The Object *****************************************************
***********************************************************************/
Object();
//translate([topDiam,topDiam,0])FlowerPot();
//translate([-topDiam,-topDiam,0])Saucer();


module Object(topDiam = topDiam, bottomDiam = bottomDiam, height = height, potHolePattern = potHolePattern, 
								potHoleDiam = potHoleDiam, withSaucer = withSaucer, saucerGap = saucerGap, 
								saucerHeight = saucerHeight, saucerGroveQty = saucerGroveQty, saucerGroveDiam = saucerGroveDiam){
	// Rendered Calculations
	pThick = wallThickness;
	pHeight = withSaucer ? height - saucerIntHeight : height;
	pBottomDiam = withSaucer ? bottomDiam-(saucerGap*2)-(wallThickness*2) : bottomDiam;
	pTopDiam = topDiam;
	
	sThick = wallThickness;
	sBottomDiam = bottomDiam;
	sTopDiam = withSaucer ? topDiam+(saucerGap*2)-(wallThickness*2) : topDiam;
	sHeight = withSaucer ? height : saucerHeight;

//should not need these
//potHolePattern = 1;					// (1: Single Hole, 3: 3 holes, 5: 5 holes)
//potHoleDiam = 10;				//
//withSaucer = true;

// not using these now.
// saucerGap = 1;
// saucerHeight = 20;
// saucerGroveQty = 1;
// saucerGroveDiam = 5;
// saucerIntHeight = 5;


	// Start creating the object
	//translate([pHeight,pHeight,0])
	difference(){
		cylinder(h=pHeight, d1=pBottomDiam, d2=topDiam);
		holeGen(potHolePattern = potHolePattern, potHoleDiam = potHoleDiam);
	}
	if (withSaucer == true) {
		translate([topDiam,topDiam,0])
		difference(){
			cylinder(h=sHeight, d1=bottomDiam, d2=topDiam);
			#translate([0,0,saucerHeight])cylinder(h=sHeight, d=topDiam+4);
		}
	}
}

// module Saucer(saucerTopDiam = saucerTopDiam, saucerBottomDiam = saucerBottomDiam, saucerHeight = saucerHeight, saucerGroveQty = saucerGroveQty, saucerGroveDiam = saucerGroveDiam, saucerWallThick = saucerWallThick){
// 	// Rendered Calculations
	
// 	// Start creating the object
// 	difference(){
// 		cylinder(h=saucerHeight, d1=saucerBottomDiam, d2=saucerTopDiam);
// 		#translate([0,0,1])cube([20,20,20]);
// 	}
// }

module holeGen(potHolePattern = potHolePattern, potHoleDiam = potHoleDiam, height = height){
	if (potHolePattern == 1){
		translate([0,0,-1])cylinder (h=height+2, d = potHoleDiam);
	} else {
		cylinder (h=20, d = potHoleDiam);		
	}
}

module groveGen(){

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