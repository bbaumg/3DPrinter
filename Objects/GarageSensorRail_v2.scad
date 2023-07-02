// front to back 52
// width 23

baseWidth = 30;
baseHeight = 90;
baseThick = 5;
baseCorner = 5;
baseScrew = 4;      //#8 = 4mm
blockWidth = 15;
blockHeight = 60;
blockDepth = 89;
mountWidth = 30;
mountHeight = 5;
mountThick = 3;
mountScrewDiamater = 2.5;
mountScrewHeight = 12;
mountScrewSpace = 45;

translate([0,-baseThick,0]){
    difference(){
			//create the base plate
			cube([baseWidth,baseThick,baseHeight]);
			//round bottom left
			translate([0,0,0]) rotate([-90,270,0]) fillet(baseCorner,baseThick,$fn=20);
			//round bottom right
			translate([30,0,0]) rotate([-90,180,0]) fillet(baseCorner,baseThick,$fn=20);
			//round top left
			translate([0,0,90]) rotate([-90,0,0]) fillet(baseCorner,baseThick,$fn=20);
			//round top right
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

translate([0,-blockDepth,(baseHeight-blockHeight)/2])
	cube([blockWidth,blockDepth,blockHeight]);


translate([-blockWidth,-blockDepth-mountThick,(baseHeight-blockHeight)/2]){
    difference(){
        cube([mountWidth,mountThick,blockHeight]);
        translate([mountWidth/4,-1,blockHeight/2-mountScrewSpace/2]) rotate([270,0,0])
            #cylinder(d=mountScrewDiamater, h=mountScrewHeight+1);
        translate([mountWidth/4,-1,blockHeight	/2+mountScrewSpace/2]) rotate([270,0,0])
            #cylinder(d=mountScrewDiamater, h=mountScrewHeight);
    }
}



module fillet(radius = 1, height = 1){
    translate([radius, radius, -1]) rotate([0,0,180])
        difference(){
            cube([radius + 1, radius + 1, height + 2]);
            #cylinder(r = radius, h = height + 2);
        }
}
