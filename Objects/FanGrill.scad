/*
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	Purpose:    Grill for computer case fans
	GitHub:     https://github.com/bbaumg/3DPrinter/blob/master/Objects/FanGrill.scad
	
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
gridHole = 12;					//
gridWall = 1.9;					//
thickness = 2.8;				//
counterSinkScrew = true;        //
cornerRadius = 4;               // Default is 3

// If you want to mount the fan using the grill, use these settings.
// Angle is a work in progress
grillMount = "none";           // Options = none, flush, angle
mountScrewDiameter = 3.5;       // Diameter of the screw hole
mountCounterSinkWidth = 6.5;      //
mountScrewTaper = 2;            //
mountFlushLength = 50;          // Extra length off bottom
mountFlushScrewOffset = 10;     // How far in to set the mounting holes
mountFlushCounterSink = true;  // Countersink the screw holes or not.
mountAngleType = "outter";            // Options = under, outter
mountAngleLength = 30;
mountAngleScrewOffset = 10;     // How far in to set the mounting holes
mountAngleCounterSink = true;  // Countersink the screw holes or not.


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
            // Fan frame
            roundedCube(x=fanSize, y=fanSize, z=thickness, r=cornerRadius, xyz="z");
            // mounting section - no mount
            if (grillMount == "none") {
            // mounting section - Flush mount
                echo("No mount selected");
            } else if (grillMount == "flush") {
                echo("Type = Flush");
                difference(){
                    translate([0,-mountFlushLength,0])roundedCube(x=fanSize, y=mountFlushLength+cornerRadius*2, z=thickness, r=cornerRadius, xyz="z");
                    if (mountFlushCounterSink == true){
                        // Bottom left screw
                        translate([mountFlushScrewOffset,-mountFlushLength+mountFlushScrewOffset,thickness]) 
                            screwHole(screwHole=mountScrewDiameter, screwDepth = thickness, screwHead = mountCounterSinkWidth, headTaper = mountScrewTaper);
                        // Bottom right screw
                        translate([fanSize-mountFlushScrewOffset,-mountFlushLength+mountFlushScrewOffset,thickness]) 
                            screwHole(screwHole=mountScrewDiameter, screwDepth = thickness, screwHead = mountCounterSinkWidth, headTaper = mountScrewTaper);
                        // Top left screw
                        translate([mountFlushScrewOffset,-mountFlushScrewOffset,thickness]) 
                            screwHole(screwHole=mountScrewDiameter, screwDepth = thickness, screwHead = mountCounterSinkWidth, headTaper = mountScrewTaper);
                        // Top right screw
                        translate([fanSize-mountFlushScrewOffset,-mountFlushScrewOffset,thickness]) 
                            screwHole(screwHole=mountScrewDiameter, screwDepth = thickness, screwHead = mountCounterSinkWidth, headTaper = mountScrewTaper);
                    } else {
                        // Bottom left screw
                        translate([mountFlushScrewOffset,-mountFlushLength+mountFlushScrewOffset,-.1]) cylinder(h = thickness+.2, d = mountScrewDiameter);
                        // Bottom right screw
                        translate([fanSize-mountFlushScrewOffset,-mountFlushLength+mountFlushScrewOffset,-.1]) cylinder(h = thickness+.2, d = mountScrewDiameter);
                        // Top left screw
                        translate([mountFlushScrewOffset,-mountFlushScrewOffset,-.1]) cylinder(h = thickness+.2, d = mountScrewDiameter);
                        // Top right screw
                        translate([fanSize-mountFlushScrewOffset,-mountFlushScrewOffset,-.1]) cylinder(h = thickness+.2, d = mountScrewDiameter);
                    }
                }
            } else if (grillMount == "angle") {
                echo("Type = Angle (NOTE:Work in progress...)");
                translate([0,0,0])rotate([90,0,0])roundedCube(x=fanSize, y=mountAngleLength, z=thickness, r=cornerRadius, xyz="z");

            } else {
                echo("That mount is not an option...  Doing nothing");
            }
        }
        translate([fanSize/2,fanSize/2,-.1]) cylinder(h = thickness+.2, d = cutout);
        if (counterSinkScrew == true) {
            // Variables that should never need to be changed.
            screwDiameter = 5;              // All my cases range from 5.0-5.5
            counterSinkWidth = 6.7;         // size of the head of standard fan screw = 6.5mm
            screwTaper = 1.5;
            // screw - bottom left
            translate([screwOffset,screwOffset,thickness]) screwHole(screwHole=screwDiameter, screwDepth = thickness, screwHead = counterSinkWidth, headTaper = screwTaper);
            // screw - bottom right
            translate([screwOffset+screwSpace,screwOffset,thickness]) screwHole(screwHole=screwDiameter, screwDepth = thickness, screwHead = counterSinkWidth, headTaper = screwTaper);
            // screw - top left
            translate([screwOffset,screwOffset+screwSpace,thickness]) screwHole(screwHole=screwDiameter, screwDepth = thickness, screwHead = counterSinkWidth, headTaper = screwTaper);
            // screw - top right
            translate([screwOffset+screwSpace,screwOffset+screwSpace,thickness]) screwHole(screwHole=screwDiameter, screwDepth = thickness, screwHead = counterSinkWidth, headTaper = screwTaper);
        } else {
            // screw - bottom left
            translate([screwOffset,screwOffset,-.1]) cylinder(h=thickness+.2, d = screwDiameter);
            // screw - bottom right
            translate([screwOffset+screwSpace,screwOffset,-.1]) cylinder(h=thickness+.2, d = screwDiameter);
            // screw - top left
            translate([screwOffset,screwOffset+screwSpace,-.1]) cylinder(h=thickness+.2, d = screwDiameter);
            // screw - top right
            translate([screwOffset+screwSpace,screwOffset+screwSpace,-.1]) cylinder(h=thickness+.2, d = screwDiameter);
       }

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
    objectExport(60, 10, 1.9, "none"); //FanGrid-60mm
    objectExport(70, 10, 1.9, "none"); //FanGrid-70mm
    objectExport(80, 10, 1.9, "none"); //FanGrid-80mm
    objectExport(92, 10, 1.9, "none"); //FanGrid-92mm
    objectExport(120, 10, 1.9, "none"); //FanGrid-120mm
    objectExport(140, 10, 2.0, "none"); //FanGrid-140mm
    objectExport(200, 10, 2.0, "none"); //FanGrid-200mm
    objectExport(60, 10, 0.6, "none"); //FanGrid-60mm-minimal
    objectExport(70, 10, 0.6, "none"); //FanGrid-70mm-minimal
    objectExport(80, 10, 0.6, "none"); //FanGrid-80mm-minimal
    objectExport(92, 10, 0.6, "none"); //FanGrid-92mm-minimal
    objectExport(120, 10, 0.6, "none"); //FanGrid-120mm-minimal
    objectExport(140, 10, 1.9, "none"); //FanGrid-140mm-minimal
    objectExport(200, 10, 1.9, "none"); //FanGrid-200mm-minimal
    objectExport(60, 10, 1.9, "flush"); //FanGrid-60mm-flush
    objectExport(70, 10, 1.9, "flush"); //FanGrid-70mm-flush
    objectExport(80, 10, 1.9, "flush"); //FanGrid-80mm-flush
    objectExport(92, 10, 1.9, "flush"); //FanGrid-92mm-flush
    objectExport(120, 10, 1.9, "flush"); //FanGrid-120mm-flush
    objectExport(140, 10, 2.0, "flush"); //FanGrid-140mm-flush
    objectExport(200, 10, 2.0, "flush"); //FanGrid-200mm-flush
    objectExport(60, 10, 0.6, "flush"); //FanGrid-60mm-flush-minimal
    objectExport(70, 10, 0.6, "flush"); //FanGrid-70mm-flush-minimal
    objectExport(80, 10, 0.6, "flush"); //FanGrid-80mm-flush-minimal
    objectExport(92, 10, 0.6, "flush"); //FanGrid-92mm-flush-minimal
    objectExport(120, 10, 0.6, "flush"); //FanGrid-120mm-flush-minimal
    objectExport(140, 10, 1.9, "flush"); //FanGrid-140mm-flush-minimal
    objectExport(200, 10, 1.9, "flush"); //FanGrid-200mm-flush-minimal
}

// Calls this to make minor tweaks for batch rendering
//   e.g. rotation of the object for best viewing
module objectExport(var1, var2, var3, var4){
	echo("Rendering Export");
	// Allows for rotation of object for best orientation of STL file
	//    Likely need to rotate 90-180 on z axis.
	rotate([0,0,0])object(var1, var2, var3, var4); //(fanSize, gridHole, gridWall, grillMount)
}