
include <modules/RoundedCube.scad>

tagWidth = 150;
tagHeight = tagWidth/1.618;
tagThick = 2.2;
tagEdge = 4;
baseCutout = 27;
cornerRadius = 17;
textDepth = .8;
textSize = 20;
activeTextLines = 2;
textTopPadding = 8;
textBottomPadding = 25;
textFont="Stencil";
textLine1 = "447";
textLine1Size = 34;
textLine2 = "Table 1";
textLine2Size = 16;
textLine3 = "#1";
textLine3Size = textSize;
textLine4 = "Four";
textLine4Size = textSize;

/* NOTES:
*	Actual thickness is tagThick.
*	Plate thickness is tagThick - TextDepth
*/

$fn = 60;

// Calculated Fields
workingSpace = tagHeight - (textTopPadding + textBottomPadding);
echo(workingSpace);
lineSpacing = workingSpace/activeTextLines;
echo(lineSpacing);

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