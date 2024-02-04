
include <modules/RoundedCube.scad>

tagWidth = 150;
tagHeight = tagWidth/1.618;
tagThick = 1.2;
tagEdge = 4;
baseCutout = 27;
cornerRadius = 15;
textDepth = .8;
textSize = 20;
activeTextLines = 3;
textTopPadding = 8;
textBottomPadding = 25;
textLine1 = "Troop";
textLine2 = "447";
textLine3 = "#1";
textLine4 = "Four";

$fn = 60;

// Calculated Fields
workingSpace = tagHeight - (textTopPadding + textBottomPadding);
echo(workingSpace);
lineSpacing = workingSpace/activeTextLines;
echo(lineSpacing);


difference(){
	// The main frame
	roundedsquare(x=tagWidth, y=tagHeight, z=tagThick, radius=cornerRadius);
	// Remove the cutout in the center
	translate([tagEdge,tagEdge,tagThick-textDepth+.1])
		roundedsquare(x=tagWidth-2*tagEdge, y=tagHeight-2*tagEdge, z=textDepth, radius=cornerRadius);
	// Remove a edge for mounting in the bottom
	translate([-baseCutout/2+tagWidth/2,0,tagThick-textDepth+.1])#cube([baseCutout,tagEdge,textDepth]);
}

//  First line of text
translate([tagWidth/2,+lineSpacing/2+textBottomPadding+(lineSpacing*(activeTextLines-1)),tagThick])linear_extrude(textDepth) text(str(textLine1), size = textSize, halign="center", valign="center", font="Courier 10 Pitch");
if (activeTextLines >= 2) {
translate([tagWidth/2,+lineSpacing/2+textBottomPadding+(lineSpacing*(activeTextLines-2)),tagThick])linear_extrude(textDepth) text(str(textLine2), size = textSize, halign="center", valign="center", font="Courier 10 Pitch");
}
if (activeTextLines >= 3) {
translate([tagWidth/2,+lineSpacing/2+textBottomPadding+(lineSpacing*(activeTextLines-3)),tagThick])linear_extrude(textDepth) text(str(textLine3), size = textSize, halign="center", valign="center", font="Courier 10 Pitch");
}
if (activeTextLines >= 4) {
translate([tagWidth/2,+lineSpacing/2+textBottomPadding+(lineSpacing*(activeTextLines-4)),tagThick])linear_extrude(textDepth) text(str(textLine4), size = textSize, halign="center", valign="center", font="Courier 10 Pitch");
}