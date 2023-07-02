// front to back 52
// width 23

railDepth = 53;
railWidth = 23;
clipHeight = 60;
clipThick = 3;
mountHole = 5.5;
blockWidth = 15;
blockHeight = 60;
blockDepth = 3;
blockScrewDiamater = 2.5;
blockScrewHeight = 10;
blockScrewSpace = 45;

difference(){
		union(){
			cube([railWidth+(clipThick),railDepth+(clipThick*2),clipHeight]);
			translate([0,-blockDepth,0]) cube([blockWidth,blockDepth,blockHeight]);
		}
		// Remove the shape of the door rail
    translate([-1,clipThick,-1])cube([railWidth+1,railDepth,clipHeight+2]);
		// Remove bottom screw
    translate([blockWidth/2,-blockDepth-1,blockHeight/2-blockScrewSpace/2]) rotate([270,0,0])
        #cylinder(d=blockScrewDiamater, h=blockScrewHeight+1);
		// Remove top screw
    translate([blockWidth/2,-blockDepth-1,blockHeight/2+blockScrewSpace/2]) rotate([270,0,0])
        #cylinder(d=blockScrewDiamater, h=blockScrewHeight+1);
		// Remove rail mounting hole
		#translate([railWidth-1,railDepth/2+clipThick,clipHeight/2]) rotate([0,90,0]) cylinder(d=mountHole, h=clipThick+2);
}
