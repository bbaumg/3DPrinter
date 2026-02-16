/*
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	Purpose:  Simple cutouts for windows and doors in gingerbread house making
	GitHub:		https://github.com/bbaumg/3DPrinter/blob/master/Objects/CutoutTemplates.scad
	
	History:	
		12/27/2025	Initial creation
		01/11/2026	Finished initial planned development

	Notes:
		- This is for creating cutouts and textures for gingerbread house making
		-	There are several different shapes that include
				Circles (I know many people have the metal ones, this is here in case)
				Rectangle cutouts
				Window shaped indentions
				Half Moon cutouts
				shingle pattern indentions
				brick wall pattern indentions
				log cabin pattern indentions
		-	To render all of these, the export python script explained at the bottom is needed
			If you want to modify a shape for your needs, use one of the module callouts
			shown at in the "export()" section of the code towrds the bottom.

*/

/****** Variables ******************************************************
***********************************************************************/
wallThickness = 1.1;		// Thickness of the wall for cutting
wallHeight = 14;				// Height of the wall
baseWidth = 3;					// Width of the base frame
baseThick = 1;					// Thickness of the base frame

// To Render, select one of the objects below and uncomment it.
// At the bottom of the file is a list of lots of ways to render things

//	rectangle(baseShape="rectangle", sizeA=20, sizeB=30); //Rectangle-20x30
//	rectangle(baseShape="window", sizeA=20, sizeB=30); //Window-20x30
//	rectangle(baseShape="window", sizeA=20, sizeB=30, wallHeight=5); //Window-short-20x30
//	circle(sizeA=20); //Circle-20
//  shingle(sizeA=150, sizeB=100, wallHeight=5, sizeC=10); //Shingle-10
//	halfMoon(sizeA=30, sizeB=15, wallHeight=wallHeight);


// Special variables
$fn = $preview ? 32 : 64;		// 0 is OpenSCAD default

/****** Imports & Includes & Calculations ******************************
***********************************************************************/
include <modules/Modules.scad>

// Global Calculations


/****** The Object *****************************************************
***********************************************************************/

module rectangle(baseShape="rectangle", sizeA=20, sizeB=30, wallHeight=wallHeight){
	// base
	difference(){
		translate([-baseWidth, -baseWidth, 0])roundedCube(x=sizeA+baseWidth*2, y=sizeB+baseWidth*2, z=baseThick, r=2, xyz="z");
		translate([baseWidth, baseWidth, -1])roundedCube(x=sizeA-baseWidth*2, y=sizeB-baseWidth-2, z=baseThick+2, r=2, xyz="z");
	}
	// blade
	difference(){
		cube([sizeA, sizeB, baseThick + wallHeight]);
		translate([wallThickness, wallThickness, -1]) cube([sizeA-wallThickness*2, sizeB-wallThickness*2, baseThick + wallHeight + 2]);
	}
	if (baseShape == "rectangle"){
		// cutting edge
		difference(){
			translate([wallThickness/4, wallThickness/4, baseThick + wallHeight])cube([sizeA-wallThickness/2, sizeB-wallThickness/2, wallThickness/2]);
			translate([wallThickness/4, wallThickness/4, baseThick + wallHeight])translate([wallThickness/2,wallThickness/2,-1])cube([sizeA-wallThickness*1.5, sizeB-wallThickness*1.5, wallThickness/2+2]);
		}
	} else if (baseShape == "window") {
		translate([sizeA/2-wallThickness/2,0,0])cube([wallThickness,sizeB,baseThick + wallHeight]);
		translate([0,sizeB/2-wallThickness/2,0])cube([sizeA-wallThickness/2,wallThickness,baseThick + wallHeight]);
	}
}

module circle(sizeA = 20, wallThickness = wallThickness, wallHeight = wallHeight){
	// base
	difference(){
		translate([0, 0, 0])cylinder(d=sizeA+baseWidth*2, h=baseThick);
		translate([0, 0, -1])cylinder(d=sizeA-baseWidth*2, h=baseThick+2);
	}
	// blade
	difference(){
		cylinder(d=sizeA, h=baseThick+wallHeight);
		translate([0, 0, -1])cylinder(d=sizeA-wallThickness*2, h=baseThick+wallHeight+2);
	}
	// cutting edge
	difference(){
		translate([0,0,baseThick + wallHeight])cylinder(d=sizeA-wallThickness/2, h=wallThickness/2);
		translate([0,0,baseThick + wallHeight])translate([0, 0, -1])cylinder(d=sizeA-wallThickness*1.5, h=wallThickness/2+2);
	}
}

module shingle(sizeA=20, sizeB=30, sizeC = 0, wallHeight=wallHeight){
	echo("Shingle Selected");
	// Section variable
	depthOffset = 4;
	// sizeA = total X width
	// sizeB = total Y height
	// SizeC = individual single width

	shingleWidth = sizeC;
	shingleHeight = shingleWidth/2;

	widthCount = floor(sizeA/shingleWidth);
	echo("widthCount = ", widthCount);
	actualWidth = widthCount * shingleWidth;
	echo("actualWidth = ", actualWidth);

	heightCount = floor(sizeB/shingleHeight);
	echo("heightCount = ", heightCount);
	actualHeight = heightCount * shingleHeight;
	echo("actualHeight = ", actualHeight);

	// base
	difference(){
			translate([-baseWidth, -baseWidth, 0])roundedCube(x=actualWidth+baseWidth*2-wallThickness/2, y=actualHeight+baseWidth*2-wallThickness/2, z=baseThick, r=2, xyz="z");
			translate([baseWidth, baseWidth, -1])roundedCube(x=actualWidth-baseWidth*2-wallThickness/2, y=actualHeight-baseWidth-2-wallThickness/2, z=baseThick+2, r=2, xyz="z");
	}
	// outer wall
	difference(){
		translate([-wallThickness/2,-wallThickness/2,0])cube([actualWidth+wallThickness/2,actualHeight+wallThickness/2,wallHeight]);
		translate([wallThickness/2,wallThickness/2,-1])cube([actualWidth-wallThickness*2,actualHeight-wallThickness*2,wallHeight+2]);
	}
	difference(){
		union(){
			for (i = [0:widthCount]){
				for (ii = [1:heightCount]){
					shingleOffset = (ii % 2 == 0) ? shingleWidth/2 : 0;
					translate([shingleOffset,0,0])
						translate([i*shingleWidth,ii*shingleHeight,0])
							shingleShape(sizeA = shingleWidth+wallThickness, sizeB = shingleHeight, wallThickness = wallThickness, wallHeight = wallHeight+depthOffset);
				}
			}
		}
		translate([0,0,-1])
		difference(){
			translate([-shingleWidth/2-1,-shingleWidth,0])cube([actualWidth+shingleWidth*1.5+2,actualHeight+shingleWidth*2,wallHeight+depthOffset+2]);
			translate([-wallThickness/2,-wallThickness/2,0])cube([actualWidth+wallThickness/2,actualHeight+wallThickness/2,wallHeight+depthOffset]);
		}
	}
}

module shingleShape(sizeA = 20, sizeB = 10, wallThickness = wallThickness, wallHeight = wallHeight){
	difference(){
		cylinder(d=sizeA, h=wallHeight);
		translate([0,0,-1])cylinder(d=sizeA-wallThickness*2, h=wallHeight+2);
		translate([-sizeA/2-1,0,-1])cube([sizeA+2, sizeB+2, wallHeight+2]);
	}
}

module halfMoon(sizeA=20, sizeB=10, wallHeight=wallHeight){
	// The main window
	difference(){
		halfMoonShape(sizeA=sizeA, sizeB=sizeB, wallHeight=wallHeight);
		translate([0,0,-1])halfMoonShape(sizeA=sizeA-wallThickness*2, sizeB=sizeB-wallThickness*2, wallHeight=wallHeight+2);
	}
	// The base
		difference(){
		halfMoonShape(sizeA=sizeA+baseWidth, sizeB=sizeB+baseWidth, wallHeight=baseThick);
		translate([0,0,-1])halfMoonShape(sizeA=sizeA-wallThickness*2-baseWidth, sizeB=sizeB-wallThickness*2-baseWidth, wallHeight=baseThick+2);
	}
}

module halfMoonShape(sizeA=20, sizeB=10, wallHeight=wallHeight){
	translate([0,0,wallHeight/2]){
		difference(){
			cylinder(d=sizeA, h=wallHeight, center = true);
			translate([0,-sizeB,0])cube([sizeA, sizeA, wallHeight+2], center = true);
		}
	}
}


//bricks(sizeA=150, sizeB=100, sizeC = 10, sizeD = 10/1.618, wallHeight=5);
bricks(sizeA=150, sizeB=100, sizeC = 15, sizeD = 15/1.618, wallHeight=5);
//bricks(sizeA=150, sizeB=100, sizeC = 150, sizeD = 5, wallHeight=5, style="log");

module bricks(sizeA=150, sizeB=100, sizeC = 10, sizeD = 5, wallHeight=wallHeight, style="brick"){
	
	depthOffset = 4;
	// sizeA = total X width
	// sizeB = total Y height
	// SizeC = individual brick width
	// SizeD = individual brick height

	brickWidth = sizeC;
	brickHeight = sizeD;
	
	widthCount = floor(sizeA/(brickWidth-wallThickness));
	echo("widthCount = ", widthCount);
	actualWidth = (style == "brick") ? widthCount * (brickWidth-wallThickness) + brickWidth/2 + wallThickness :
								(style == "log") ? widthCount * (brickWidth-wallThickness) + wallThickness :
								0;
	echo("actualWidth = ", actualWidth);

	heightCount = floor(sizeB/(brickHeight-wallThickness));
	echo("heightCount = ", heightCount);
	actualHeight = heightCount * (brickHeight-wallThickness) +wallThickness;
	echo("actualHeight = ", actualHeight);

	// base
	difference(){
			translate([-baseWidth, -baseWidth, 0])roundedCube(x=actualWidth+baseWidth*2-wallThickness/2, y=actualHeight+baseWidth*2-wallThickness/2, z=baseThick, r=2, xyz="z");
			translate([baseWidth, baseWidth, -1])roundedCube(x=actualWidth-baseWidth*2-wallThickness/2, y=actualHeight-baseWidth-2-wallThickness/2, z=baseThick+2, r=2, xyz="z");
	}

	// brick pattern
	for (i = [0:widthCount-1]){
		for (ii = [0:heightCount-1]){
			//brickOffset = (ii % 2 == 0) ? brickWidth/2 : 0;
			brickOffset = (ii % 2 == 0 && style == "brick") ? brickWidth/2 :
										(ii % 2 == 0 && style == "log") ? 0 :
										0;
			translate([brickOffset,0,0])			
				translate([i * (brickWidth-wallThickness),ii * (brickHeight-wallThickness),0])bricksShape(brickWidth = brickWidth, brickHeight = brickHeight, wallHeight=wallHeight+depthOffset);
		}
	}
	// outter wall
	difference(){
		cube([actualWidth, actualHeight, wallHeight]);
		translate([wallThickness, wallThickness,-1])cube([actualWidth-wallThickness*2, actualHeight-wallThickness*2, wallHeight+2]);
	}
}

module bricksShape(brickWidth = 10, brickHeight=5, wallHeight=wallHeight){
	difference(){
		cube([brickWidth, brickHeight, wallHeight]);
		translate([wallThickness,wallThickness,-1])cube([brickWidth-wallThickness*2, brickHeight-wallThickness*2, wallHeight+2]);
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
	rectangle(baseShape="rectangle", sizeA=20, sizeB=30); //Rectangle-20x30
	rectangle(baseShape="rectangle", sizeA=20, sizeB=40); //Rectangle-20x40
	rectangle(baseShape="rectangle", sizeA=20, sizeB=50); //Rectangle-20x50
	rectangle(baseShape="rectangle", sizeA=30, sizeB=30); //Rectangle-30x30
	rectangle(baseShape="rectangle", sizeA=30, sizeB=40); //Rectangle-30x40
	rectangle(baseShape="rectangle", sizeA=30, sizeB=50); //Rectangle-30x50
	rectangle(baseShape="rectangle", sizeA=30, sizeB=60); //Rectangle-30x60
	rectangle(baseShape="rectangle", sizeA=40, sizeB=40); //Rectangle-40x40
	rectangle(baseShape="rectangle", sizeA=40, sizeB=50); //Rectangle-40x50
	rectangle(baseShape="rectangle", sizeA=40, sizeB=60); //Rectangle-40x60
	rectangle(baseShape="rectangle", sizeA=40, sizeB=70); //Rectangle-40x70
	rectangle(baseShape="rectangle", sizeA=40, sizeB=80); //Rectangle-40x80
	rectangle(baseShape="rectangle", sizeA=50, sizeB=50); //Rectangle-50x50
	rectangle(baseShape="rectangle", sizeA=50, sizeB=60); //Rectangle-50x60
	rectangle(baseShape="rectangle", sizeA=50, sizeB=70); //Rectangle-50x70
	rectangle(baseShape="rectangle", sizeA=50, sizeB=80); //Rectangle-50x80
	rectangle(baseShape="rectangle", sizeA=50, sizeB=90); //Rectangle-50x90
	rectangle(baseShape="rectangle", sizeA=50, sizeB=100); //Rectangle-50x100
	rectangle(baseShape="rectangle", sizeA=60, sizeB=60); //Rectangle-60x60
	rectangle(baseShape="rectangle", sizeA=60, sizeB=70); //Rectangle-60x70
	rectangle(baseShape="rectangle", sizeA=60, sizeB=80); //Rectangle-60x80
	rectangle(baseShape="rectangle", sizeA=60, sizeB=90); //Rectangle-60x90
	rectangle(baseShape="rectangle", sizeA=60, sizeB=100); //Rectangle-60x100
	rectangle(baseShape="rectangle", sizeA=60, sizeB=110); //Rectangle-60x110
	rectangle(baseShape="rectangle", sizeA=60, sizeB=120); //Rectangle-60x120

	rectangle(baseShape="window", sizeA=20, sizeB=30); //Window-20x30
	rectangle(baseShape="window", sizeA=20, sizeB=40); //Window-20x40
	rectangle(baseShape="window", sizeA=20, sizeB=50); //Window-20x50
	rectangle(baseShape="window", sizeA=30, sizeB=30); //Window-30x30
	rectangle(baseShape="window", sizeA=30, sizeB=40); //Window-30x40
	rectangle(baseShape="window", sizeA=30, sizeB=50); //Window-30x50
	rectangle(baseShape="window", sizeA=30, sizeB=60); //Window-30x60
	rectangle(baseShape="window", sizeA=40, sizeB=40); //Window-40x40
	rectangle(baseShape="window", sizeA=40, sizeB=50); //Window-40x50
	rectangle(baseShape="window", sizeA=40, sizeB=60); //Window-40x60
	rectangle(baseShape="window", sizeA=40, sizeB=70); //Window-40x70
	rectangle(baseShape="window", sizeA=40, sizeB=80); //Window-40x80
	rectangle(baseShape="window", sizeA=50, sizeB=50); //Window-50x50
	rectangle(baseShape="window", sizeA=50, sizeB=60); //Window-50x60
	rectangle(baseShape="window", sizeA=50, sizeB=70); //Window-50x70
	rectangle(baseShape="window", sizeA=50, sizeB=80); //Window-50x80
	rectangle(baseShape="window", sizeA=50, sizeB=90); //Window-50x90
	rectangle(baseShape="window", sizeA=50, sizeB=100); //Window-50x100
	rectangle(baseShape="window", sizeA=60, sizeB=60); //Window-60x60
	rectangle(baseShape="window", sizeA=60, sizeB=70); //Window-60x70
	rectangle(baseShape="window", sizeA=60, sizeB=80); //Window-60x80
	rectangle(baseShape="window", sizeA=60, sizeB=90); //Window-60x90
	rectangle(baseShape="window", sizeA=60, sizeB=100); //Window-60x100
	rectangle(baseShape="window", sizeA=60, sizeB=110); //Window-60x110
	rectangle(baseShape="window", sizeA=60, sizeB=120); //Window-60x120

	rectangle(baseShape="window", sizeA=20, sizeB=30, wallHeight=5); //Window-short-20x30
	rectangle(baseShape="window", sizeA=20, sizeB=40, wallHeight=5); //Window-short-20x40
	rectangle(baseShape="window", sizeA=20, sizeB=50, wallHeight=5); //Window-short-20x50
	rectangle(baseShape="window", sizeA=30, sizeB=30, wallHeight=5); //Window-short-30x30
	rectangle(baseShape="window", sizeA=30, sizeB=40, wallHeight=5); //Window-short-30x40
	rectangle(baseShape="window", sizeA=30, sizeB=50, wallHeight=5); //Window-short-30x50
	rectangle(baseShape="window", sizeA=30, sizeB=60, wallHeight=5); //Window-short-30x60
	rectangle(baseShape="window", sizeA=40, sizeB=40, wallHeight=5); //Window-short-40x40
	rectangle(baseShape="window", sizeA=40, sizeB=50, wallHeight=5); //Window-short-40x50
	rectangle(baseShape="window", sizeA=40, sizeB=60, wallHeight=5); //Window-short-40x60
	rectangle(baseShape="window", sizeA=40, sizeB=70, wallHeight=5); //Window-short-40x70
	rectangle(baseShape="window", sizeA=40, sizeB=80, wallHeight=5); //Window-short-40x80
	rectangle(baseShape="window", sizeA=50, sizeB=50, wallHeight=5); //Window-short-50x50
	rectangle(baseShape="window", sizeA=50, sizeB=60, wallHeight=5); //Window-short-50x60
	rectangle(baseShape="window", sizeA=50, sizeB=70, wallHeight=5); //Window-short-50x70
	rectangle(baseShape="window", sizeA=50, sizeB=80, wallHeight=5); //Window-short-50x80
	rectangle(baseShape="window", sizeA=50, sizeB=90, wallHeight=5); //Window-short-50x90
	rectangle(baseShape="window", sizeA=50, sizeB=100, wallHeight=5); //Window-short-50x100
	rectangle(baseShape="window", sizeA=60, sizeB=60, wallHeight=5); //Window-short-60x60
	rectangle(baseShape="window", sizeA=60, sizeB=70, wallHeight=5); //Window-short-60x70
	rectangle(baseShape="window", sizeA=60, sizeB=80, wallHeight=5); //Window-short-60x80
	rectangle(baseShape="window", sizeA=60, sizeB=90, wallHeight=5); //Window-short-60x90
	rectangle(baseShape="window", sizeA=60, sizeB=100, wallHeight=5); //Window-short-60x100
	rectangle(baseShape="window", sizeA=60, sizeB=110, wallHeight=5); //Window-short-60x110
	rectangle(baseShape="window", sizeA=60, sizeB=120, wallHeight=5); //Window-short-60x120

	circle(sizeA=20); //Circle-20
	circle(sizeA=30); //Circle-30
	circle(sizeA=40); //Circle-40
	circle(sizeA=50); //Circle-50
	circle(sizeA=60); //Circle-60
	circle(sizeA=70); //Circle-70
	circle(sizeA=80); //Circle-80
	circle(sizeA=90); //Circle-90
	circle(sizeA=100); //Circle-100
	circle(sizeA=110); //Circle-110
	circle(sizeA=120); //Circle-120

	halfMoon(sizeA=20, sizeB=5, wallHeight=wallHeight); //HalfMoon-20x5
	halfMoon(sizeA=20, sizeB=7, wallHeight=wallHeight); //HalfMoon-20x7
	halfMoon(sizeA=20, sizeB=10, wallHeight=wallHeight); //HalfMoon-20x10
	halfMoon(sizeA=30, sizeB=7, wallHeight=wallHeight); //HalfMoon-30x7
	halfMoon(sizeA=30, sizeB=10, wallHeight=wallHeight); //HalfMoon-30x10
	halfMoon(sizeA=30, sizeB=12, wallHeight=wallHeight); //HalfMoon-30x12
	halfMoon(sizeA=30, sizeB=15, wallHeight=wallHeight); //HalfMoon-30x15
	halfMoon(sizeA=40, sizeB=10, wallHeight=wallHeight); //HalfMoon-40x10
	halfMoon(sizeA=40, sizeB=12, wallHeight=wallHeight); //HalfMoon-40x12
	halfMoon(sizeA=40, sizeB=15, wallHeight=wallHeight); //HalfMoon-40x15
	halfMoon(sizeA=40, sizeB=17, wallHeight=wallHeight); //HalfMoon-40x17
	halfMoon(sizeA=40, sizeB=20, wallHeight=wallHeight); //HalfMoon-40x20
	halfMoon(sizeA=50, sizeB=10, wallHeight=wallHeight); //HalfMoon-50x10
	halfMoon(sizeA=50, sizeB=15, wallHeight=wallHeight); //HalfMoon-50x15
	halfMoon(sizeA=50, sizeB=20, wallHeight=wallHeight); //HalfMoon-50x20
	halfMoon(sizeA=50, sizeB=25, wallHeight=wallHeight); //HalfMoon-50x25
	halfMoon(sizeA=60, sizeB=10, wallHeight=wallHeight); //HalfMoon-60x10
	halfMoon(sizeA=60, sizeB=15, wallHeight=wallHeight); //HalfMoon-60x15
	halfMoon(sizeA=60, sizeB=20, wallHeight=wallHeight); //HalfMoon-60x20
	halfMoon(sizeA=60, sizeB=25, wallHeight=wallHeight); //HalfMoon-60x25
	halfMoon(sizeA=60, sizeB=30, wallHeight=wallHeight); //HalfMoon-60x30
	halfMoon(sizeA=70, sizeB=10, wallHeight=wallHeight); //HalfMoon-70x10
	halfMoon(sizeA=70, sizeB=15, wallHeight=wallHeight); //HalfMoon-70x15
	halfMoon(sizeA=70, sizeB=20, wallHeight=wallHeight); //HalfMoon-70x20
	halfMoon(sizeA=70, sizeB=25, wallHeight=wallHeight); //HalfMoon-70x25
	halfMoon(sizeA=70, sizeB=30, wallHeight=wallHeight); //HalfMoon-70x30
	halfMoon(sizeA=70, sizeB=35, wallHeight=wallHeight); //HalfMoon-70x35

	shingle(sizeA=150, sizeB=100, wallHeight=5, sizeC=10); //Shingle-10
	shingle(sizeA=150, sizeB=100, wallHeight=5, sizeC=15); //Shingle-15
	shingle(sizeA=150, sizeB=100, wallHeight=5, sizeC=20); //Shingle-20
	shingle(sizeA=150, sizeB=100, wallHeight=5, sizeC=25); //Shingle-25
	shingle(sizeA=150, sizeB=100, wallHeight=5, sizeC=30); //Shingle-30
	shingle(sizeA=150, sizeB=100, wallHeight=5, sizeC=35); //Shingle-35
	shingle(sizeA=150, sizeB=100, wallHeight=5, sizeC=40); //Shingle-40

	bricks(sizeA=150, sizeB=100, sizeC = 10, sizeD = 10/1.618, wallHeight=5); //Bricks-10
	bricks(sizeA=150, sizeB=100, sizeC = 15, sizeD = 15/1.618, wallHeight=5); //Bricks-15
	bricks(sizeA=150, sizeB=100, sizeC = 20, sizeD = 20/1.618, wallHeight=5); //Bricks-20
	bricks(sizeA=150, sizeB=100, sizeC = 25, sizeD = 25/1.618, wallHeight=5); //Bricks-25
	bricks(sizeA=150, sizeB=100, sizeC = 30, sizeD = 30/1.618, wallHeight=5); //Bricks-30

	bricks(sizeA=150, sizeB=100, sizeC = 150, sizeD = 10, wallHeight=5, style="log"); //Log-10
	bricks(sizeA=150, sizeB=100, sizeC = 150, sizeD = 15, wallHeight=5, style="log"); //Log-15
	bricks(sizeA=150, sizeB=100, sizeC = 150, sizeD = 20, wallHeight=5, style="log"); //Log-20
	bricks(sizeA=150, sizeB=100, sizeC = 150, sizeD = 25, wallHeight=5, style="log"); //Log-25

}

// Calls this to make minor tweaks for batch rendering
//   e.g. rotation of the object for best viewing
module objectExport(var1, var2, var3, var4){
	echo("Rendering Export");
	// Allows for rotation of object for best orientation of STL file
	//    Likely need to rotate 90-180 on z axis.
	rotate([0,0,0])object(var1, var2, var3, var4);
}