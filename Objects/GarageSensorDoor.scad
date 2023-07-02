

// distance from door is 40
// distance between door edge and rail edge ~ 5
// #8 screw = 4mm



baseWidth = 30;
baseHeight = 90;
baseThick = 5;
baseCorner = 5;
baseScrew = 4;      //#8 = 4mm
blockWidth = 15;
blockHeight = 60;
blockDepth = 50;
blockScrewDiamater = 2.5;
blockScrewHeight = 12;
blockScrewSpace = 45;


translate([0,-baseThick,0]){
    difference(){
        cube([baseWidth,baseThick,baseHeight]);
        //bottom left
        translate([0,0,0]) rotate([-90,270,0]) fillet(baseCorner,baseThick,$fn=20);
        //bottom right
        translate([30,0,0]) rotate([-90,180,0]) fillet(baseCorner,baseThick,$fn=20);
        //top left
        translate([0,0,90]) rotate([-90,0,0]) fillet(baseCorner,baseThick,$fn=20);
        //top right
        translate([30,0,90]) rotate([-90,90,0]) fillet(baseCorner,baseThick,$fn=20);
        //top screw
        translate([blockWidth/2,-1,(baseHeight-blockHeight)/4]) 
            rotate([-90,0,0]) cylinder(d=baseScrew, h = baseThick+2);
        //bottom screw
        translate([blockWidth/2,-1,baseHeight-(baseHeight-blockHeight)/4]) 
            rotate([-90,0,0]) cylinder(d=baseScrew, h = baseThick+2);
        //side screw
        translate([baseWidth-baseScrew-1,-1,baseHeight/2]) 
            rotate([-90,0,0]) cylinder(d=baseScrew, h = baseThick+2);

    }
}

translate([0,-blockDepth,(baseHeight-blockHeight)/2]){
    difference(){
        cube([blockWidth,blockDepth,blockHeight]);
        translate([blockWidth/2,-1,blockHeight/2-blockScrewSpace/2]) rotate([270,0,0])
            #cylinder(d=blockScrewDiamater, h=blockScrewHeight+1);
        translate([blockWidth/2,-1,blockHeight/2+blockScrewSpace/2]) rotate([270,0,0])
            #cylinder(d=blockScrewDiamater, h=blockScrewHeight);
    }
}


module fillet(radius = 1, height = 1){
    translate([radius, radius, -1]) rotate([0,0,180])
        difference(){
            cube([radius + 1, radius + 1, height + 2]);
            #cylinder(r = radius, h = height + 2);
        }
}
