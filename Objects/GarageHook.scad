/*
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	Purpose:  Adjustible hook for haning things
	GitHub:		https://github.com/bbaumg/3DPrinter/blob/master/Objects/GarageHook.scad
	
	History:	
		??/??/????	Initial creation
		02/17/2025	Rewrite to standard format refactor for batch export

	Notes:
		- Nothing special see inline notes below
*/

/****** Variables ******************************************************
***********************************************************************/

hookWidth = 70;			//total width
armLength = 120;		//total lenght
armHeight = 10;			//how thick will the arm be at the thickes part
armTaper = 2;				//used to give gental taper to arm 2 is a good number
mountHeight = 60;		//height of the mounting portion
mountThick = 7;			//thickness of the mounting portion
quadScrew = true;	  //recommended over 40mm wide
supportSize = 15;		//rounded inner corner for structural support
endHeight = 20;			//height of the hook at the end
endWidth = 5;				//width of the hook at the end

// Special variables
$fn = $preview ? 32 : 64;		// 0 is OpenSCAD default

/****** Imports & Includes & Calculations ******************************
***********************************************************************/
include <modules/Modules.scad>

/****** The Object *****************************************************
***********************************************************************/
//object();
	object(20, 60); //GarageHook - 20x60


module object(hookWidth = hookWidth, armLength = armLength){
	// Calculations
	endStart = armLength-endWidth;		//used to set hook back
	calcEndBottom = armLength * tan(armTaper);
	echo(calcEndBottom);

	difference(){
		union(){
			// Mount
			difference(){
				cube([mountThick,hookWidth,mountHeight]);
				translate([mountThick,0,mountHeight]) rotate([-90,90,0]) fillet(mountThick,hookWidth);  // rounded top
			}
			// Arm
			difference(){
				cube([armLength, hookWidth, armHeight]);
			}
			// Rounded structural support
			difference(){
				translate([mountThick,0,armHeight-1]) cube([supportSize,hookWidth,supportSize]);
				translate([mountThick+supportSize,-1,armHeight-1+supportSize]) rotate([-90,0,0]) cylinder(r=supportSize,h=hookWidth+2);
			}
			// Hook End
			union() {
				translate([endStart,0,calcEndBottom])cube([endWidth,hookWidth,endHeight-endWidth/2]);
				translate([endStart+armHeight/4,0,calcEndBottom+endHeight-endWidth/2]) rotate([-90,0,0]) cylinder(d=endWidth, h=hookWidth);
				translate([endStart,1,armHeight]) rotate([-90,180,0]) fillet(endHeight/4,hookWidth-2);
			}
		}
		// Remove bottom to taper angle
		translate([0,-1,0]) rotate([0,-armTaper,0]) mirror([0,0,1]) cube([armLength*1.25,hookWidth+2,armHeight*2]);
		// round front bottom edge
		translate([armLength,0,calcEndBottom]) rotate([-90,180,0]) fillet(2, hookWidth);
		// remove screw holes
		if(quadScrew){
			#translate([mountThick-1,+10,endHeight+5]) rotate([0,90,0]) screwHole();
			#translate([mountThick-1,+10,mountHeight-12]) rotate([0,90,0]) screwHole();
			#translate([mountThick-1,hookWidth-10,endHeight+5]) rotate([0,90,0]) screwHole();
			#translate([mountThick-1,hookWidth-10,mountHeight-12]) rotate([0,90,0]) screwHole();
		}else {
			#translate([mountThick-1,hookWidth/2,endHeight+10]) rotate([0,90,0]) screwHole();
			#translate([mountThick-1,hookWidth/2,mountHeight-10]) rotate([0,90,0]) screwHole();
		}
	}
}


module fillet(radius = 1, height = 1){
    translate([radius, radius, -1]) rotate([0,0,180])
        difference(){
            cube([radius + 1, radius + 1, height + 2]);
            translate([0,0,-1]) cylinder(r = radius, h = height + 4, $fn=60);
        }
}

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
	objectExport(20, 40); //GarageHook - 20x40
	objectExport(20, 60); //GarageHook - 20x60
	objectExport(20, 80); //GarageHook - 20x80
	objectExport(20, 100); //GarageHook - 20x100
	objectExport(20, 120); //GarageHook - 20x120
	objectExport(30, 40); //GarageHook - 30x40
	objectExport(30, 60); //GarageHook - 30x60
	objectExport(30, 80); //GarageHook - 30x80
	objectExport(30, 100); //GarageHook - 30x100
	objectExport(30, 120); //GarageHook - 30x120
	objectExport(40, 40); //GarageHook - 40x40
	objectExport(40, 60); //GarageHook - 40x60
	objectExport(40, 80); //GarageHook - 40x80
	objectExport(40, 100); //GarageHook - 40x100
	objectExport(40, 120); //GarageHook - 40x120
	objectExport(50, 60); //GarageHook - 50x60
	objectExport(50, 80); //GarageHook - 50x80
	objectExport(50, 100); //GarageHook - 50x100
	objectExport(50, 120); //GarageHook - 50x120
	objectExport(60, 40); //GarageHook - 60x40
	objectExport(60, 60); //GarageHook - 60x60
	objectExport(60, 80); //GarageHook - 60x80
	objectExport(60, 100); //GarageHook - 60x100
	objectExport(60, 120); //GarageHook - 60x120
	objectExport(70, 80); //GarageHook - 70x80
	objectExport(70, 100); //GarageHook - 70x100
	objectExport(70, 120); //GarageHook - 70x120
	objectExport(80, 80); //GarageHook - 80x80
	objectExport(80, 100); //GarageHook - 80x100
	objectExport(80, 120); //GarageHook - 80x120
}

// Calls this to make minor tweaks for batch rendering
//   e.g. rotation of the object for best viewing
module objectExport(var1, var2){
	echo("Rendering Export");
	// Allows for rotation of object for best orientation of STL file
	//    Likely need to rotate 90-180 on z axis.
	rotate([0,0,270])object(var1, var2);
}
	objectExport(70, 120); //GarageHook - 70x120
