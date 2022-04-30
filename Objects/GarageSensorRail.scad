// front to back 52
// width 23

railDepth = 53;
railWidth = 23;
clipHeight = 60;
clipThick = 3;
blockWidth = 10;
blockHeight = 60;
blockDepth = 3;
blockScrewDiamater = 2;
blockScrewHeight = 10;
blockScrewSpace = 45;

difference(){
    cube([railWidth+(clipThick),railDepth+(clipThick*2),clipHeight]);
    // Remove the shape of the door rail
    translate([-1,clipThick,-1])cube([railWidth+1,railDepth,clipHeight+2]);
    translate([blockWidth/2,-blockDepth-1,blockHeight/2-blockScrewSpace/2]) rotate([270,0,0])
        #cylinder(d=blockScrew, h=blockScrewHeight+1);
    translate([blockWidth/2,-blockDepth-1,blockHeight/2+blockScrewSpace/2]) rotate([270,0,0])
        #cylinder(d=blockScrew, h=blockScrewHeight+1);
}


/*
difference(){
    union(){
        cube([railWidth+(clipThick),railDepth+(clipThick*2),clipHeight]);
        translate([0,-blockDepth,0]) cube([blockWidth,blockDepth,blockHeight]);    
    }
    // Remove the shape of the door rail
    translate([-1,clipThick,-1])cube([railWidth+1,railDepth,clipHeight+2]);
    // remove the mounting holes for the switch
    translate([blockWidth/2,-blockDepth-1,blockHeight/2-blockScrewSpace/2]) rotate([270,0,0])
        #cylinder(d=blockScrew, h=blockScrewHeight+1);
    translate([blockWidth/2,-blockDepth-1,blockHeight/2+blockScrewSpace/2]) rotate([270,0,0])
        #cylinder(d=blockScrew, h=blockScrewHeight+1);
}
*/

