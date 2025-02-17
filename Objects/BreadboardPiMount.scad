/*
 * Raspberry Pi mounting plate with space for a power supply board
 *
*/

include <modules/RoundedCube.scad>

plateWidth = 185;
plateHeight = 290;
plateThick = 4;
plateCorner = 3;
piHoleX = 58;      //Distance from 1st hole on X
piHoleY = 49;      //Distance from 1st hole on Y
piHoleStartX = 30;
piHoleStartY = 230;
ZipX = plateWidth -15;
ZipY = 5;
ZipY2 = plateHeight-13;


difference(){
	roundedsquare(x=plateWidth, y=plateHeight, z=plateThick, radius=plateCorner);
	for (i = [0:15:60]) {
		#translate([plateWidth-20-i,plateHeight-60,0]) ziptie();
		#translate([plateWidth-10-i,plateHeight-45,0]) rotate([0,0,90]) ziptie();
		#translate([plateWidth-20-i,plateHeight-30,0]) ziptie();
		#translate([plateWidth-10-i,plateHeight-15,0]) rotate([0,0,90]) ziptie();
	}
	
	//	#translate([plateWidth-20,plateHeight-15,0]) ziptie();
	//	#translate([plateWidth-35,plateHeight-15,0]) ziptie();
	//	#translate([plateWidth-60,plateHeight-15,0]) ziptie();
	//	#translate([plateWidth-80,plateHeight-15,0]) ziptie();
    //#translate([piHoleStartX+piHoleX+40,piHoleStartY,0]) rotate(90,0,0) ziptie();

  //#translate([ZipX,ZipY2,0]) rotate(90,0,0) ziptie();
}

// Standoff bottom left
translate([piHoleStartX, piHoleStartY, plateThick])screwStandoff();
// Standoff bottom right
translate([piHoleStartX + piHoleX, piHoleStartY, plateThick])screwStandoff();
// Standoff top left
translate([piHoleStartX, piHoleStartY + piHoleY, plateThick])screwStandoff();
// Standoff top right
translate([piHoleStartX + piHoleX, piHoleStartY + piHoleY, plateThick])screwStandoff();



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

module screwStandoff(){
    holeWidth = 2.8;      //#4 screw = 2.8mm, 
    holeDepth = 9;        //Offset from height
    Height = holeDepth;
    Width = holeWidth + (2*2);
    difference(){
        cylinder(d=Width, h=Height, $fn=6);
        #translate([0,0,Height-holeDepth])cylinder(d=holeWidth, h=holeDepth, $fn=10);
    }
}

module fillet(radius = 1, height = 1){
    translate([radius, radius, -1]) rotate([0,0,180])
        difference(){
            cube([radius + 1, radius + 1, height + 2]);
            #cylinder(r = radius, h = height + 2);
        }
}

module ziptie(){
    zipWidth = 3;
    zipHeight = 7;
    zipSpace = 7;
    zipDepth = 1;
    // Bottom groove
    #translate ([0,0,0]) cube([zipWidth+zipSpace,zipHeight,zipDepth]);
    // Left ziptie slot
    #translate([0,0,0]) cube([zipWidth,zipHeight,plateThick+1]);
    // Right ziptie slot
    #translate([zipSpace,0,0]) cube([zipWidth,zipHeight,plateThick+1]);
    // Bottom
}
