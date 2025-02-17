/*
 * LED Relay Board & PS mount
 *
 120mm tall
 50mm wide
 4mm thick
 
 screw holes at top and bottom
 zip tie holes for each wire
 
 
*/

include <modules/RoundedCube.scad>

plateWidth = 50;
plateHeight = 120;
plateThick = 3;
plateCorner = 3;

difference(){
	roundedsquare(x=plateWidth, y=plateHeight, z=plateThick, radius=plateCorner);
	//Bottom holes
	#translate([plateWidth/2,7,plateThick]) screwHole();
	#translate([35,5,0]) ziptie();
	#translate([35,20,0]) ziptie();
	#translate([20,23,0]) rotate([0,0,-45]) ziptie();
	#translate([4,90,0]) rotate([0,0,-45]) ziptie();	
	//Top holes
	#translate([7,15,0]) rotate([0,0,45]) ziptie();	
	#translate([37,110,0]) ziptie();
	#translate([37,85,0]) ziptie();
	#translate([25,83,0]) rotate([0,0,45]) ziptie();
	#translate([plateWidth/2,113,plateThick]) screwHole();
	//	#translate([plateWidth-20,plateHeight-15,0]) ziptie();
	//	#translate([plateWidth-35,plateHeight-15,0]) ziptie();
	//	#translate([plateWidth-60,plateHeight-15,0]) ziptie();
	//	#translate([plateWidth-80,plateHeight-15,0]) ziptie();
    //#translate([piHoleStartX+piHoleX+40,piHoleStartY,0]) rotate(90,0,0) ziptie();

  //#translate([ZipX,ZipY2,0]) rotate(90,0,0) ziptie();
}


module ziptie(){
    zipWidth = 3;
    zipHeight = 6;
    zipSpace = 6;
    zipDepth = 1;
    // Bottom groove
    //#translate ([0,0,0]) cube([zipWidth+zipSpace,zipHeight,zipDepth]);
    // Left ziptie slot
    #translate([0,0,0]) cube([zipWidth,zipHeight,plateThick+1]);
    // Right ziptie slot
    #translate([zipSpace,0,0]) cube([zipWidth,zipHeight,plateThick+1]);
    // Bottom
}

module screwHole(){
    screwHole = 4.5;
    screwDepth = 10;
    screwHead = 9;
    headTaper = 2.3;
    screwHeadDepth = 5;
    translate([0,0,-headTaper])cylinder(d1=screwHole, d2=screwHead, h = headTaper, $fn=20);
    translate([0,0,-headTaper-screwDepth])cylinder(d=screwHole, h=screwDepth, $fn=10);
    translate([0,0,-headTaper-screwDepth])cylinder(d=screwHole, h=screwDepth, $fn=10);
    translate([0,0,0]) cylinder(d=screwHead, h=screwHeadDepth, $fn=10);
}