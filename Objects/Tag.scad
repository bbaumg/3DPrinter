
include <modules/RoundedCube.scad>

tagWidth = 25;
tagHeight = tagWidth * 1.618;
tagThick = 2;
tagEdge = 2;
cornerRadius = 2;
holeWidth = 5;
holeHeight = 2;
holeSpace = 2.5;  // how far from the edge should the hole be.
textDepth = .5;
textSize = 15;
starting = 1;
quantity = 20;

$fn = 60;

for (i=[starting:quantity]){
	translate([tagWidth*i+5*i, 0, 0])tag(i);
}

module tag(i=0){
	difference(){
		roundedsquare(x=tagWidth, y=tagHeight, z=tagThick, radius=cornerRadius);
		translate([tagEdge,tagEdge,tagThick-textDepth+.1])
			roundedsquare(x=tagWidth-2*tagEdge, y=tagHeight-2*tagEdge, z=textDepth, radius=cornerRadius);
		translate([tagWidth/2-holeWidth/2, tagHeight-holeHeight-holeSpace, 0])
			roundedsquare(x=holeWidth, y=holeHeight, z=tagThick, radius = 1);
	}
	translate([tagWidth/2,tagHeight/2,tagThick-textDepth])rotate([0,0,90])
		linear_extrude(textDepth) text(str(i), size = textSize, halign="center", valign="center", font="Courier 10 Pitch");
}