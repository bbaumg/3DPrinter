
/*NOTES:
	- Set screw: The hole needs to be tight enough to force a screw in andcreate its own threads.  A 1/2in bolt is ~6.2mm at the outter end of the threads and and ~5.2mm at the inner end.  PreThread is the larger of the two and ScrewHole is the inner size.
*/
angle = 20;

// Base is the main block that attaches to the sander.
baseWidth = 34;
baseHeight = 49;
baseThick = 12;
setScrewHole = 5.3;
setPreThread = 1; //depth for pre-threading the set screw
// Anchor is the hole in the block that goes over the snaders backer plate.
anchorThick = 3.6;
anchorWidth = 26.4;
anchorHeight = baseHeight-4;
anchorOffset = 2;   // distance from back side of belt
// Space between the base and the wedge
beltSpace = 3;
beltWallThick = 4;
// Wedge for blade reference
wedgeHeight = baseHeight;
wedgeBase = .6;

textSize = 8;
textDepth = .8;         // .5mm is pretty good...



// Calculations
wedgeThick = round(baseHeight*tan(angle));

echo(wedgeThick);

// Make the base
difference(){
    cube([baseWidth, baseThick, baseHeight]);
	// Remove the anchor hole
    translate([(baseWidth-anchorWidth-beltWallThick)/2, anchorOffset, -.1])
        cube([anchorWidth, anchorThick, anchorHeight]);
	// Remove the set screw hole
	//translate([0,anchorThick+beltSpace,0])rotate([270,0,0])
	translate([(baseWidth-beltWallThick)/2,anchorOffset+anchorThick,anchorHeight/2])rotate([270,0,0])
		#cylinder(d=setScrewHole, h=baseThick-anchorThick-anchorOffset);
	translate([(baseWidth-beltWallThick)/2,baseThick-1,anchorHeight/2])rotate([270,0,0])
		#cylinder(d=setScrewHole+1, h=1);
}

// Make the wedge to base connector
translate([baseWidth-beltWallThick,-beltSpace,baseHeight-wedgeHeight])
    cube([beltWallThick, beltSpace, wedgeHeight]);

// Make the wedge
difference(){
    translate([0,-(beltSpace+wedgeThick+wedgeBase),baseHeight-wedgeHeight])
        cube([baseWidth, wedgeThick+wedgeBase, wedgeHeight]);
    translate([baseWidth,-beltSpace-wedgeBase,baseHeight-wedgeHeight])rotate([-angle,0,180])
        cube([baseWidth, wedgeThick, wedgeHeight*2]);
    translate([baseWidth/2-textSize,-beltSpace-textSize-2,baseHeight+.1-textDepth]) 
        linear_extrude(textDepth)
            #text(text = str(angle), size = textSize);
}


//baseHeight-wedgeHeight+.1-textDepth
