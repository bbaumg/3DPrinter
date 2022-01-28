

driveWidth = 13.2;
driveDepth = 18;
socketDiamater = 35;
socketHeight = 20;
driveBearingDepth = 7;
driveBearingDiameter = 4.5;
mountDiamater = 18;
mountHeight = 5;
mountHoleDiamater = 4.5;

$fn = 20;

difference(){
    union(){
        cylinder(d=socketDiamater, h=socketHeight, $fn=60);
        hull(){
            translate([socketDiamater/2+mountDiamater/2,0,socketHeight-mountHeight])
                cylinder(d=mountDiamater, h=mountHeight);
            translate([-socketDiamater/2-mountDiamater/2,0,socketHeight-mountHeight])
                cylinder(d=mountDiamater, h=mountHeight);
        }
    }
    translate([-driveWidth/2,-driveWidth/2,-.1]) cube([driveWidth,driveWidth,driveDepth]);
    translate([driveWidth/2,0,driveBearingDepth]) sphere(d=driveBearingDiameter);
    translate([0,driveWidth/2,driveBearingDepth]) sphere(d=driveBearingDiameter);
    translate([-driveWidth/2,0,driveBearingDepth]) sphere(d=driveBearingDiameter);
    translate([0,-driveWidth/2,driveBearingDepth]) sphere(d=driveBearingDiameter);
    translate([socketDiamater/2+mountDiamater/2,0,socketHeight-mountHeight]) 
        cylinder(d=mountHoleDiamater, h=mountHeight);
    translate([-socketDiamater/2-mountDiamater/2,0,socketHeight-mountHeight])
        cylinder(d=mountHoleDiamater, h=mountHeight);
}

module screwHole(){
    screwHole = 3;
    screwDepth = 10;
    screwHead = 8.2;
    headTaper = 2.3;
    translate([0,0,-headTaper])cylinder(d1=screwHole, d2=screwHead, h = headTaper, $fn=20);
    translate([0,0,-headTaper-screwDepth])cylinder(d=screwHole, h=screwDepth, $fn=10);
}