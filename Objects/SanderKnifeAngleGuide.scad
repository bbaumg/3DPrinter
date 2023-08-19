


angle = 20;

baseWidth = 40;
baseHeight = 60;
baseThick = 10;
anchorOffset = 2;   // distance from back side of belt
anchorWidth = 30;
anchorHeight = 40;
anchorThick = 2;
beltSpace = 10;
beltWallThick = 4;
wedgeBase = 2;
textSize = 10;
textDepth = .5;         // .5mm is pretty good...


// Calculations
wedgeThick = round(baseHeight*tan(angle));
echo(wedgeThick);

difference(){
    cube([baseWidth, baseThick, baseHeight]);
    translate([(baseWidth-anchorWidth)/2, anchorOffset, -.1])
        cube([anchorWidth, anchorThick, anchorHeight]);
}
translate([baseWidth-beltWallThick,-beltSpace,0])
    cube([beltWallThick, beltSpace, baseHeight]);

difference(){
    translate([0,-(beltSpace+wedgeThick+wedgeBase),0])
        cube([baseWidth, wedgeThick+wedgeBase, baseHeight]);
    translate([baseWidth,-beltSpace-wedgeBase,0])rotate([-angle,0,180])
        cube([baseWidth, wedgeThick, baseHeight*2]);
    translate([baseWidth/2-textSize,-beltSpace-textSize-2,baseHeight+.1-textDepth]) 
        linear_extrude(textDepth)
            #text(text = str(angle), size = textSize);
}

