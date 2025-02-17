/*
 * Adjustible hook for haning things
 *
*/

hookWidth = 70;			//total width
armLength = 120;		//total lenght
armHeight = 10;			//how thick will the arm be at the thickes part
armTaper = 2;				//used to give gental taper to arm 2 is a good number
mountHeight = 60;		//height of the mounting portion
mountThick = 7;			//thickness of the mounting portion
quadScrew = true;	  //recommended over 40mm wide
supportSize = 15;		//rounded inner corner for structural support
endHeight = 15;			//height of the hook at the end
endWidth = 5;				//width of the hook at the end

//  Calculated fields
endStart = armLength-endWidth;		//used to set hook back
calcEndBottom = armLength * tan(armTaper);
echo(calcEndBottom);

//  Static variables
$fn = 60;

//  Begin object
difference(){
	union(){
		// Mount
		difference(){
			cube([mountThick,hookWidth,mountHeight]);
			translate([mountThick,0,mountHeight]) rotate([-90,90,0]) fillet(mountThick,hookWidth);  // rounded top
		}
		// Arm
		difference(){
			cube([armLength, hookWidth, armHeight]);
		}
		// Rounded structural support
		difference(){
			translate([mountThick,0,armHeight-1]) cube([supportSize,hookWidth,supportSize]);
			translate([mountThick+supportSize,-1,armHeight-1+supportSize]) rotate([-90,0,0]) cylinder(r=supportSize,h=hookWidth+2);
		}
		// Hook End
		union() {
			translate([endStart,0,calcEndBottom])cube([endWidth,hookWidth,endHeight-endWidth/2]);
			translate([endStart+armHeight/4,0,calcEndBottom+endHeight-endWidth/2]) rotate([-90,0,0]) cylinder(d=endWidth, h=hookWidth);
			translate([endStart,1,armHeight]) rotate([-90,180,0]) fillet(endHeight/4,hookWidth-2);
		}
	}
	// Remove bottom to taper angle
	translate([0,-1,0]) rotate([0,-armTaper,0]) mirror([0,0,1]) cube([armLength*1.25,hookWidth+2,armHeight*2]);
	// round front bottom edge
	translate([armLength,0,calcEndBottom]) rotate([-90,180,0]) fillet(2, hookWidth);
	// remove screw holes
	if(quadScrew){
		#translate([mountThick-1,+10,endHeight+5]) rotate([0,90,0]) screwHole();
		#translate([mountThick-1,+10,mountHeight-12]) rotate([0,90,0]) screwHole();
		#translate([mountThick-1,hookWidth-10,endHeight+5]) rotate([0,90,0]) screwHole();
		#translate([mountThick-1,hookWidth-10,mountHeight-12]) rotate([0,90,0]) screwHole();
	}else {
		#translate([mountThick-1,hookWidth/2,endHeight+10]) rotate([0,90,0]) screwHole();
		#translate([mountThick-1,hookWidth/2,mountHeight-10]) rotate([0,90,0]) screwHole();
	}
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

module fillet(radius = 1, height = 1){
    translate([radius, radius, -1]) rotate([0,0,180])
        difference(){
            cube([radius + 1, radius + 1, height + 2]);
            translate([0,0,-1]) cylinder(r = radius, h = height + 4, $fn=60);
        }
}

module filletold(radius = 1, height = 1){
    translate([radius, radius, -1]) rotate([0,0,180])
        difference(){
            #cube([radius + 1, radius + 1, height + 2]);
            translate([0,0,-1]) cylinder(r = radius, h = height + 4);
        }
}
