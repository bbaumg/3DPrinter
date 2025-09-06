/*
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	Purpose:  Printable holder for woodworking chisles (designed for 4 piece narex set)
	GitHub:		
	
	History:	
		08/30/2025	Initial creation

	Notes:
		- Nothing special see inline notes below

*/

/****** Variables ******************************************************
***********************************************************************/
// Can be sized to hold chisels with multiple base sizes (like Narex)
SizeADiameter = 23;				// Size of the hole
SizeASlot = 15;						// Size of the opening
SizeAQty = 2;							// Quantity

SizeBDiameter = 21;				// Size of the hole
SizeBSlot = 13;						// Size of the opening
SizeBQty = 2;							// Quantity

SizeCDiameter = 18;				// Size of the hole
SizeCSlot = 8;						// Size of the opening
SizeCQty = 0;							// Quantity

SizeDDiameter = 14;				// Size of the hole
SizeDSlot = 6;						// Size of the opening
SizeDQty = 0;							// Quantity

HolderDepth = 16;					// Depth of the part holding the chisel
HolderWall = 5;						// Wall thickness for each holder
HolderSpacing = 10;				// Spacing between each holder
HolderOffset = 7;				// Distance from the back wall

WallAbove = 20;						// Wall Above
WallSides = 15;						// Wall Sides
WallThickness = 4;				// Thickness of the mounting wall

ScrewHole = 4;						// Diameter of the screw holes

// Special variables
$fn = $preview ? 32 : 64;		// 0 is OpenSCAD default

/****** Imports & Includes & Calculations ******************************
***********************************************************************/
include <modules/Modules.scad>

// Global Calculations


/****** The Object *****************************************************
***********************************************************************/
object();

module object(){
	// Rendered Calculations
	SizeATotalDiameter = SizeADiameter + (HolderWall *2); echo("SizeATotalDiameter", SizeATotalDiameter);
	SizeATotalSpacing = (SizeATotalDiameter + HolderSpacing) * SizeAQty; echo("SizeATotalSpacing", SizeATotalSpacing);
	SizeATotalBackOffset = -SizeATotalDiameter/2 - HolderOffset;
	SizeBTotalDiameter = SizeBDiameter + (HolderWall *2); echo("SizeBTotalDiameter" , SizeBTotalDiameter);
	SizeBTotalSpacing = (SizeBTotalDiameter + HolderSpacing) * SizeBQty;
	SizeBTotalBackOffset = -SizeBTotalDiameter/2 - HolderOffset;
	SizeCTotalDiameter = SizeCDiameter + (HolderWall *2); echo("SizeCTotalDiameter" , SizeCTotalDiameter);
	SizeCTotalSpacing = (SizeCTotalDiameter + HolderSpacing) * SizeCQty;
	SizeCTotalBackOffset = -SizeCTotalDiameter/2 - HolderOffset;
	SizeDTotalDiameter = SizeDDiameter + (HolderWall *2); echo("SizeDTotalDiameter" , SizeDTotalDiameter);
	SizeDTotalSpacing = (SizeDTotalDiameter + HolderSpacing) * SizeDQty;
	SizeDTotalBackOffset = -SizeDTotalDiameter/2 - HolderOffset;
	TotalAWidth = (SizeATotalDiameter + HolderSpacing) * SizeAQty - HolderSpacing; echo("TotalAWidth" , TotalAWidth);
	TotalBWidth = (HolderSpacing + SizeBTotalDiameter) * SizeBQty; echo("TotalBWidth" , TotalBWidth);
	TotalCWidth = (SizeCTotalDiameter + HolderSpacing) * SizeCQty; echo("TotalCWidth" , TotalCWidth);
	TotalDWidth = (SizeDTotalDiameter + HolderSpacing) * SizeDQty; echo("TotalDWidth" , TotalDWidth);
	WallLenghtSpan = (TotalAWidth + TotalBWidth + TotalCWidth + TotalDWidth) + WallSides * 2;
	WallHeight = HolderDepth + WallAbove;

	// Start creating the object

	// Mounting Wall
	difference(){
		translate([-WallSides,-1,0])roundedCube(x=WallLenghtSpan, y=WallThickness, z=WallHeight, r=1, xyz="all");
		translate([-WallSides+ScrewHole*1.5,WallThickness,WallHeight-ScrewHole*1.5])#rotate([90,0,0])cylinder(d=ScrewHole, h=WallThickness*2);
		translate([WallLenghtSpan/2-WallSides,WallThickness,WallHeight-ScrewHole*1.5])#rotate([90,0,0])cylinder(d=ScrewHole, h=WallThickness*2);
		translate([WallLenghtSpan-WallSides-ScrewHole*1.5,WallThickness,WallHeight-ScrewHole*1.5])#rotate([90,0,0])cylinder(d=ScrewHole, h=WallThickness*2);
	}

	// A
	for (i = [0:SizeAQty-1]){
		translate([SizeATotalDiameter/2,0,0])
		translate([i*(SizeATotalDiameter + HolderSpacing),SizeATotalBackOffset,0])
			difference(){
				// Create the holder body
				union(){
					// Rounded portion
					roundedCylinder(h=HolderDepth,d=SizeATotalDiameter, r=1);
					// Square portion to back wall
					translate([-(SizeATotalDiameter/2),0,0])
						roundedCube(x=SizeATotalDiameter, y=HolderOffset+SizeATotalDiameter/2, z=HolderDepth, r=1, xyz="y");
				}
				// remove the hole
				filletedCylinder(d=SizeADiameter, h=HolderDepth, r=1, pad=1, s=$fn);
				// remove the slot
				translate([-SizeASlot/2,-SizeATotalDiameter/2,-.1])cube([SizeASlot,SizeATotalDiameter/2,HolderDepth+.2]);
			}
	}
	// B
	for (i = [0:SizeBQty-1]){
		translate([SizeATotalSpacing,0,0])
		translate([SizeBTotalDiameter/2,0,0])
		translate([i*(SizeBTotalDiameter + HolderSpacing),SizeBTotalBackOffset,0])
			difference(){
				// Create the holder body
				union(){
					// Rounded portion
					roundedCylinder(h=HolderDepth,d=SizeBTotalDiameter, r=1);
					// Square portion to back wall
					translate([-(SizeBTotalDiameter/2),0,0])
						roundedCube(x=SizeBTotalDiameter, y=HolderOffset+SizeBTotalDiameter/2, z=HolderDepth, r=1, xyz="y");
				}
				// remove the hole
				filletedCylinder(d=SizeBDiameter, h=HolderDepth, r=1, pad=1, s=$fn);
				// remove the slot
				translate([-SizeBSlot/2,-SizeBTotalDiameter/2,-.1])cube([SizeBSlot,SizeBTotalDiameter/2,HolderDepth+.2]);
			}
		echo(SizeATotalSpacing);
		echo(i*(SizeBTotalDiameter + HolderSpacing));
}
	// C
	for (i = [0:SizeCQty-1]){
		translate([SizeATotalSpacing + SizeBTotalSpacing,0,0])
		translate([SizeCTotalDiameter/2,0,0])
		translate([i*(SizeCTotalDiameter + HolderSpacing),SizeCTotalBackOffset,0])
			difference(){
				// Create the holder body
				union(){
					// Rounded portion
					roundedCylinder(h=HolderDepth,d=SizeCTotalDiameter, r=1);
					// Square portion to back wall
					translate([-(SizeCTotalDiameter/2),0,0])
						roundedCube(x=SizeCTotalDiameter, y=HolderOffset+SizeCTotalDiameter/2, z=HolderDepth, r=1, xyz="y");
				}
				// remove the hole
				filletedCylinder(d=SizeBDiameter, h=HolderDepth, r=1, pad=1, s=$fn);
				// remove the slot
				translate([-SizeCSlot/2,-SizeCTotalDiameter/2,-.1])cube([SizeCSlot,SizeCTotalDiameter/2,HolderDepth+.2]);
			}
	}
	// D
	for (i = [0:SizeDQty-1]){
		translate([SizeATotalSpacing + SizeBTotalSpacing + SizeCTotalSpacing,0,0])
		translate([SizeDTotalDiameter/2,0,0])
		translate([i*(SizeDTotalDiameter + HolderSpacing),SizeDTotalBackOffset,0])
			difference(){
				// Create the holder body
				union(){
					// Rounded portion
					roundedCylinder(h=HolderDepth,d=SizeDTotalDiameter, r=1);
					// Square portion to back wall
					translate([-(SizeDTotalDiameter/2),0,0])
						roundedCube(x=SizeDTotalDiameter, y=HolderOffset+SizeDTotalDiameter/2, z=HolderDepth, r=1, xyz="y");
				}
				// remove the hole
				filletedCylinder(d=SizeDDiameter, h=HolderDepth, r=1, pad=1, s=$fn);
				// remove the slot
				translate([-SizeDSlot/2,-SizeDTotalDiameter/2,-.1])cube([SizeDSlot,SizeDTotalDiameter/2,HolderDepth+.2]);
			}
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


/* BAckup Copy
	// A
	for (i = [0:SizeAQty-1]){
		translate([i*(SizeATotalDiameter + HolderSpacing),SizeATotalBackOffset,0])
			difference(){
				// Create the holder body
				union(){
					// Rounded portion
					roundedCylinder(h=HolderDepth,d=SizeATotalDiameter, r=1);
					// Square portion to back wall
					translate([-(SizeATotalDiameter/2),0,0])
						roundedCube(x=SizeATotalDiameter, y=HolderOffset+SizeATotalDiameter/2, z=HolderDepth, r=1, xyz="y");
				}
				// remove the hole
				filletedCylinder(d=SizeADiameter, h=HolderDepth, r=1, pad=1, s=$fn);
				// remove the slot
				translate([-SizeASlot/2,-SizeATotalDiameter/2,-.1])cube([SizeASlot,SizeATotalDiameter/2,HolderDepth+.2]);
			}
	}
	// B
	for (i = [0:SizeBQty-1]){
		translate([SizeATotalSpacing,0,0])
		translate([i*(SizeBTotalDiameter + HolderSpacing),SizeBTotalBackOffset,0])
			difference(){
				// Create the holder body
				union(){
					// Rounded portion
					roundedCylinder(h=HolderDepth,d=SizeBTotalDiameter, r=1);
					// Square portion to back wall
					translate([-(SizeBTotalDiameter/2),0,0])
						roundedCube(x=SizeBTotalDiameter, y=HolderOffset+SizeBTotalDiameter/2, z=HolderDepth, r=1, xyz="y");
				}
				// remove the hole
				filletedCylinder(d=SizeBDiameter, h=HolderDepth, r=1, pad=1, s=$fn);
				// remove the slot
				translate([-SizeBSlot/2,-SizeBTotalDiameter/2,-.1])cube([SizeBSlot,SizeBTotalDiameter/2,HolderDepth+.2]);
			}
		echo(SizeATotalSpacing);
		echo(i*(SizeBTotalDiameter + HolderSpacing));
}
	// C
	for (i = [0:SizeCQty-1]){
		translate([SizeATotalSpacing + SizeBTotalSpacing,0,0])
		translate([i*(SizeCTotalDiameter + HolderSpacing),SizeCTotalBackOffset,0])
			difference(){
				// Create the holder body
				union(){
					// Rounded portion
					roundedCylinder(h=HolderDepth,d=SizeCTotalDiameter, r=1);
					// Square portion to back wall
					translate([-(SizeCTotalDiameter/2),0,0])
						roundedCube(x=SizeCTotalDiameter, y=HolderOffset+SizeCTotalDiameter/2, z=HolderDepth, r=1, xyz="y");
				}
				// remove the hole
				filletedCylinder(d=SizeBDiameter, h=HolderDepth, r=1, pad=1, s=$fn);
				// remove the slot
				translate([-SizeCSlot/2,-SizeCTotalDiameter/2,-.1])cube([SizeCSlot,SizeCTotalDiameter/2,HolderDepth+.2]);
			}
	}
	// D
	for (i = [0:SizeDQty-1]){
		translate([SizeATotalSpacing + SizeBTotalSpacing + SizeCTotalSpacing,0,0])
		translate([i*(SizeDTotalDiameter + HolderSpacing),SizeDTotalBackOffset,0])
			difference(){
				// Create the holder body
				union(){
					// Rounded portion
					roundedCylinder(h=HolderDepth,d=SizeDTotalDiameter, r=1);
					// Square portion to back wall
					translate([-(SizeDTotalDiameter/2),0,0])
						roundedCube(x=SizeDTotalDiameter, y=HolderOffset+SizeDTotalDiameter/2, z=HolderDepth, r=1, xyz="y");
				}
				// remove the hole
				filletedCylinder(d=SizeDDiameter, h=HolderDepth, r=1, pad=1, s=$fn);
				// remove the slot
				translate([-SizeDSlot/2,-SizeDTotalDiameter/2,-.1])cube([SizeDSlot,SizeDTotalDiameter/2,HolderDepth+.2]);
			}
	}
}
 */