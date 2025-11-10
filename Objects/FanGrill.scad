/*
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	Purpose:  Grill for computer case fans
	GitHub:		
	
	History:	
		11/10/2025	Initial creation

	Notes:
		- I use a 0.6mm nozel.  gridWall size will depend on nozel.
        - gridwall of 1.9 will yeild 2 permiters
        - grisWall of 2.0 will get 3 permiters with minimal extra movements
        - larger than 2.0 will get weird extra movement at the intersections

*/

/****** Variables ******************************************************
***********************************************************************/
fanSize = 120;					// Options = 60, 80, 92, 120, 140, 200
wallSize = 4;                   // Thinnest part of perimeter wall
gridHole = 10;					//
gridWall = 2.0;					//
thickness = 2.8;				//
screwDiameter = 4.3;            // Defined standard is 4.3mm
cornerRadius = 3;               // Default is 3
// If you want to mount the fan using the grill, use these settings.
grillMount = "none";           // Options = none, flush, angle
mountLengh = 50;                // 
mountScrewOffset = 10;
mountScrewHole = 5;


// Special variables
$fn = $preview ? 32 : 64;		// 0 is OpenSCAD default

/****** Imports & Includes & Calculations ******************************
***********************************************************************/
include <modules/Modules.scad>

// Global Calculations


/****** The Object *****************************************************
***********************************************************************/
object(fanSize, gridHole, gridWall, grillMount);

module object(fanSize, gridHole, gridWall, grillMount){
	// Rendered Calculations
        cutout = fanSize - wallSize;
        
        //The spacing for screw holes is a standard based on the fan size.
        screwSpace = 
            (fanSize == 60  ? 50 :
            (fanSize == 70  ? 61.5 :
            (fanSize == 80  ? 71.5 : 
            (fanSize == 92  ? 82.5 : 
            (fanSize == 120 ? 105 : 
            (fanSize == 140 ? 124.5 : 
            (fanSize == 200 ? 154 : 
            (0))))))));
        echo(screwSpace=screwSpace);
        //screwOffset = (fanSize - screwSpace - (screwDiameter))/2;
        screwOffset = (fanSize - screwSpace)/2;
        echo(screwOffset=screwOffset);
	
	// Create the main shape
    difference(){
        union(){
            roundedCube(x=fanSize, y=fanSize, z=thickness, r=cornerRadius, xyz="z");
            if (grillMount == "none") {
                echo("No mount selected");
            } else if (grillMount == "flush") {
                difference(){
                    translate([0,-mountLengh,0])roundedCube(x=fanSize, y=mountLengh+cornerRadius, z=thickness, r=cornerRadius, xyz="z");
                    translate([mountScrewOffset,-mountLengh+mountScrewOffset,-.1]) cylinder(h = thickness+.2, d = mountScrewHole);
                    translate([fanSize-mountScrewOffset,-mountLengh+mountScrewOffset,-.1]) cylinder(h = thickness+.2, d = mountScrewHole);
                    translate([mountScrewOffset,-mountScrewOffset,-.1]) cylinder(h = thickness+.2, d = mountScrewHole);
                    translate([fanSize-mountScrewOffset,-mountScrewOffset,-.1]) cylinder(h = thickness+.2, d = mountScrewHole);
                }
            }
        }
        translate([fanSize/2,fanSize/2,-.1]) cylinder(h = thickness+.2, d = cutout);
        // screw - bottom left
        translate([screwOffset,screwOffset,-.1]) cylinder(h=thickness+.2, d = screwDiameter);
        // screw - bottom right
        translate([screwOffset+screwSpace,screwOffset,-.1]) cylinder(h=thickness+.2, d = screwDiameter);
        // screw - top left
        translate([screwOffset,screwOffset+screwSpace,-.1]) cylinder(h=thickness+.2, d = screwDiameter);
        // screw - top right
        translate([screwOffset+screwSpace,screwOffset+screwSpace,-.1]) cylinder(h=thickness+.2, d = screwDiameter);
    }
    // Add the grid
    intersection(){
        hexgrid([fanSize, fanSize, thickness], gridHole, gridWall*2);
        translate([fanSize/2,fanSize/2,0]) cylinder(h = thickness, d = fanSize);
    }
}

/*Some basic commands
translate([0,0,0])
rotate([0,0,0])
cube([0,0,0]);
difference(){}
*/
// Create a single hexagon shapped object
module hex(hole, wall, thick){
    hole = hole;
    wall = wall;
    difference(){
        rotate([0, 0, 30]) cylinder(d = (hole + wall), h = thick, $fn = 6);
        translate([0, 0, -0.1]) rotate([0, 0, 30]) cylinder(d = hole, h = thick + 0.2, $fn = 6);
    }
}

// Put all the hexagons together to make a hex grid
module hexgrid(box, holediameter, wallthickness) {
    a = (holediameter + (wallthickness/2))*sin(60);
    for(x = [holediameter/2: a: box[0]]) {
        for(y = [holediameter/2: 2*a*sin(60): box[1]]) {
            translate([x, y, 0]) hex(holediameter, wallthickness, box[2]);
            translate([x + a*cos(60), y + a*sin(60), 0]) hex(holediameter, wallthickness, box[2]);

        }
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
    objectExport(60, 10, 1.9, "none"); //FanGrid-60mm.stl
    objectExport(70, 10, 1.9, "none"); //FanGrid-70mm.stl
    objectExport(80, 10, 1.9, "none"); //FanGrid-80mm.stl
    objectExport(92, 10, 1.9, "none"); //FanGrid-92mm.stl
    objectExport(120, 10, 1.9, "none"); //FanGrid-120mm.stl
    objectExport(140, 10, 2.0, "none"); //FanGrid-140mm.stl
    objectExport(200, 10, 2.0, "none"); //FanGrid-200mm.stl
    objectExport(60, 10, 1.9, "flush"); //FanGrid-60mm-flush.stl
    objectExport(70, 10, 1.9, "flush"); //FanGrid-70mm-flush.stl
    objectExport(80, 10, 1.9, "flush"); //FanGrid-80mm-flush.stl
    objectExport(92, 10, 1.9, "flush"); //FanGrid-92mm-flush.stl
    objectExport(120, 10, 1.9, "flush"); //FanGrid-120mm-flush.stl
    objectExport(140, 10, 2.0, "flush"); //FanGrid-140mm-flush.stl
    objectExport(200, 10, 2.0, "flush"); //FanGrid-200mm-flush.stl
}

// Calls this to make minor tweaks for batch rendering
//   e.g. rotation of the object for best viewing
module objectExport(var1, var2, var3){
	echo("Rendering Export");
	// Allows for rotation of object for best orientation of STL file
	//    Likely need to rotate 90-180 on z axis.
	rotate([0,0,0])object(var1, var2, var3); //(fanSize, gridHole, gridWall)
}