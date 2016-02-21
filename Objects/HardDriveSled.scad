




// Overall Outter frame dimensions.  Should match that of 5.25" drive 
OHeight = 30;
OWidth = 146;
ODepth = 140;

//  Settings for internal size.  Should fit a 3.5" HDD
IWidth = 102;
BedThickness = 4;
WallThickness = 3;

// Settings for the depth of the outter screw holes.
OSDepth1 = 22;
OSHeight1 = 10.5;
OSHeight2 = OSHeight1 + 12.7;
OSDiamater = 4;

// Inner screw hols are harder...  need to make screwdriver space outside before creating inner hole.
HDDepth1 = 15;
HDDepth2 = HDDepth1 + 60;
HDDepth3 = HDDepth2 + 41.6;
HDHeight = BedThickness + 6.5;
NubLength = 1;
NubWidth = 2;


//  Some caluculations used later.
Spacing = ((OWidth-IWidth)/2)-(2*WallThickness);
echo(Spacing);

difference(){
    // Primary shell
    cube([OWidth,ODepth,OHeight]);
    // Cutout for the HDD
    translate([(OWidth-IWidth)/2,-.1,BedThickness])cube([IWidth,ODepth+.2,OHeight-BedThickness+.1]);
    // Cutout for the left supports
    translate([WallThickness,-.1,BedThickness])cube([Spacing,ODepth+.2,OHeight-BedThickness+.1]);
    // Cutout for the right supports
    translate([OWidth-WallThickness-Spacing,-.1,BedThickness])cube([Spacing,ODepth+.2,OHeight-BedThickness+.1]);
    // Outer mounting holes
    translate([-.1,OSDepth1,OSHeight1])rotate([0,90,0])cylinder(d=OSDiamater, h=WallThickness+.2, $fn=20);
    translate([OWidth-WallThickness-.1,OSDepth1,OSHeight1])rotate([0,90,0])cylinder(d=OSDiamater, h=WallThickness+.2, $fn=20);
    translate([-.1,OSDepth1,OSHeight2])rotate([0,90,0])cylinder(d=OSDiamater, h=WallThickness+.2, $fn=20);
    translate([OWidth-WallThickness-.1,OSDepth1,OSHeight2])rotate([0,90,0])cylinder(d=OSDiamater, h=WallThickness+.2, $fn=20);
}
// Hard drive nubs
translate([Spacing+(2*WallThickness),HDDepth1,HDHeight])rotate([0,90,0])cylinder(d=NubWidth, h=NubLength, $fn=20);
translate([Spacing+(2*WallThickness),HDDepth3,HDHeight])rotate([0,90,0])cylinder(d=NubWidth, h=NubLength, $fn=20);
translate([IWidth+(2*WallThickness)+Spacing-NubLength,HDDepth1,HDHeight])rotate([0,90,0])cylinder(d=NubWidth, h=NubLength, $fn=20);
translate([IWidth+(2*WallThickness)+Spacing-NubLength,HDDepth3,HDHeight])rotate([0,90,0])cylinder(d=NubWidth, h=NubLength, $fn=20);















