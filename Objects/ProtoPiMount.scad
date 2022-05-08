/*
 * Raspberry Pi mounting plate with space for a power supply board
 * 
 * 
 * 
 * 
 * 
 * Copyright 2022 Dan Kirshner - dan_kirshner@yahoo.com
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * See <http://www.gnu.org/licenses/>.
 *
*/

plateWidth = 140;
plateHeight = 95;
plateThick = 3;
plateCorner = 3;
piHoleX = 49;      //Distance from 1st hole on X
piHoleY = 58;      //Distance from 1st hole on Y
piHoleStartX = 20;
piHoleStartY = 10;
ZipX = plateWidth -15;
ZipY = 5;
ZipY2 = plateHeight- 13;


difference(){
    cube([plateWidth, plateHeight, plateThick]);
    // Remove Left Screw
    translate([10,plateHeight/2,plateThick]) screwHole();
    // Remove Right Screw
    translate([plateWidth-10,plateHeight/2,plateThick]) screwHole();
    // Round bottom left
    translate([0,0,0]) rotate([0,0,0]) fillet(plateCorner,plateThick, $fn=20);
    // Round bottom right
    translate([plateWidth,0,0]) rotate([0,0,90]) fillet(plateCorner,plateThick, $fn=20);
    // Round top right
    translate([plateWidth,plateHeight,0]) rotate([0,0,180]) fillet(plateCorner,plateThick, $fn=20);
    // Round top left
    translate([0,plateHeight,0]) rotate([0,0,270]) fillet(plateCorner,plateThick, $fn=20);
    #translate([ZipX,ZipY,0]) ziptie();
    #translate([ZipX,ZipY2,0]) ziptie();
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
    #translate ([]) cube([zipWidth+zipSpace,zipHeight,zipDepth]);
    // Left ziptie slot
    #translate([0,0,0]) cube([zipWidth,zipHeight,plateThick+1]);
    // Right ziptie slot
    #translate([zipSpace,0,0]) cube([zipWidth,zipHeight,plateThick+1]);
    // Bottom
}
