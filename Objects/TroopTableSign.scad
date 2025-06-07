
/*
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	Purpose:  Printable sign for a table topper used at scout summer camp.
	GitHub:		https://github.com/bbaumg/3DPrinter/blob/master/Objects/TroopTableSign.scad
	
	History:	
		??/??/????	Initial creation
		06/07/2025	Added code to be able to batch export multiple

	Notes:
	*	Actual thickness is tagThick.
	*	Plate thickness is tagThick - TextDepth
	* Setting textLine#Size all to "textSize"

	Settings as first printed:
		tagWidth = 150;
		tagHeight = tagWidth/1.618;
		tagThick = 2.2;
		tagEdge = 4;
		baseCutout = 27;
		cornerRadius = 17;
		textDepth = 1;
		textSize = 20;
		activeTextLines = 2;
		textTopPadding = 12;
		textBottomPadding = 25;
		textFont="Stencil";
		textLine1 = "447";
		textLine1Size = 38;
		textLine2 = "Table 1";
		textLine2Size = 16;
		textLine3 = "#1";
		textLine3Size = textSize;
		textLine4 = "Four";
		textLine4Size = textSize;
*/

/****** Variables ******************************************************
***********************************************************************/
tagWidth = 150;
tagHeight = tagWidth/1.618;
tagThick = 2.2;
tagEdge = 4;
baseCutout = 27;
cornerRadius = 17;
textDepth = 1;
textSize = 20;						//Usefull if multiple textLine#Size are the same
activeTextLines = 2;
textTopPadding = 12;
textBottomPadding = 25;
textFont="Stencil";
textLine1 = "447";
textLine1Size = 38;
//textLine2 = "Table 1";  //  Using export variable to set (see bottom)
textLine2Size = 16;
textLine3 = "#1";
textLine3Size = textSize;
textLine4 = "Four";
textLine4Size = textSize;

// Special variables
$fn = $preview ? 32 : 64;		// 0 is OpenSCAD default

/****** Imports & Includes & Calculations ******************************
***********************************************************************/
include <modules/RoundedCube.scad>
include <modules/Modules.scad>


// Global Calculations
//$fn = 60;

workingSpace = tagHeight - (textTopPadding + textBottomPadding);
echo(workingSpace);
lineSpacing = workingSpace/activeTextLines;
echo(lineSpacing);

/****** The Object *****************************************************
***********************************************************************/
module object(textLine2){
	difference(){
		// The main frame
		color("yellow")roundedsquare(x=tagWidth, y=tagHeight, z=tagThick, radius=cornerRadius);
		// Remove the cutout in the center
		color("green")translate([tagEdge,tagEdge,tagThick-textDepth])
			roundedsquare(x=tagWidth-2*tagEdge, y=tagHeight-2*tagEdge, z=textDepth+.1, radius=cornerRadius);
		// Remove a edge for mounting in the bottom
		translate([-baseCutout/2+tagWidth/2,-.1,tagThick-textDepth])color("Green")cube([baseCutout,tagEdge+.2,textDepth+.1]);
	}

	//  First line of text
	translate([tagWidth/2,+lineSpacing/2+textBottomPadding+(lineSpacing*(activeTextLines-1)),tagThick-textDepth])color("yellow")linear_extrude(textDepth) text(str(textLine1), size = textLine1Size, halign="center", valign="center", font=textFont);
	if (activeTextLines >= 2) {
	translate([tagWidth/2,+lineSpacing/2+textBottomPadding+(lineSpacing*(activeTextLines-2)),tagThick-textDepth])color("yellow")linear_extrude(textDepth) text(str(textLine2), size = textLine2Size, halign="center", valign="center", font=textFont);
	}
	if (activeTextLines >= 3) {
	translate([tagWidth/2,+lineSpacing/2+textBottomPadding+(lineSpacing*(activeTextLines-3)),tagThick-textDepth])color("yellow")linear_extrude(textDepth) text(str(textLine3), size = textLine3Size, halign="center", valign="center", font=textFont);
	}
	if (activeTextLines >= 4) {
	translate([tagWidth/2,+lineSpacing/2+textBottomPadding+(lineSpacing*(activeTextLines-4)),tagThick-textDepth])color("yellow")linear_extrude(textDepth) text(str(textLine4), size = textLine4Size, halign="center", valign="center", font=textFont);
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
objectExport("Table 5"); //file name here.

module export() {
	objectExport("Table 1"); //Troop447-Table-1
	objectExport("Table 2"); //Troop447-Table-2
	objectExport("Table 3"); //Troop447-Table-3
	objectExport("Table 4"); //Troop447-Table-4
	objectExport("Table 5"); //Troop447-Table-5
	objectExport("Table 6"); //Troop447-Table-6
	objectExport("Table 7"); //Troop447-Table-7
	objectExport("Table 8"); //Troop447-Table-8
	objectExport("Table 9"); //Troop447-Table-9
}

// Calls this to make minor tweaks for batch rendering
//   e.g. rotation of the object for best viewing
module objectExport(var1){
	echo("Rendering Export");
	// Allows for rotation of object for best orientation of STL file
	//    Likely need to rotate 90-180 on z axis.
	rotate([0,0,0])object(var1);
}