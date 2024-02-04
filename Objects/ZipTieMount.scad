// Dimensions
baseWidth=20;
baseHeight=3;
screwSize=4.5;
topHeight=4.5;
topBorder=2;
topHoleSize=9;

// Calculated
tieHoleSize=4;
topWidth=topHoleSize+2*topBorder;
borderTopVertical=topBorder/2;
totalHeight=baseHeight+topHeight;

// Smoother Curves
$fa=6;
$fs=0.4;

translate([0, 0, totalHeight])
rotate([180, 0, 0])
mount();

module mount(){
    difference(){
        union() {
            base();
            top();
        }
        cableTieHole();
        rotate([0,0,90]) cableTieHole();
    }
}

module base(){
    difference(){
        basePlate();
        screwHole();

    }
}

module basePlate(){
    translate([0,0,baseHeight/2])
    cube([baseWidth, baseWidth, baseHeight], center=true);
}

module screwHole(){
    height=baseHeight;
    union(){
        cylinder(h=height, r=screwSize/2);
        translate([0,0,height-screwSize])
        cylinder(h=screwSize, r2=screwSize, r1=0);
    }
    
}

module top(){
    difference(){
        topPyramid();
        topHole();
    }
}

module topPyramid(){
    translate([0,0,baseHeight])
    linear_extrude(topHeight, scale=topWidth/baseWidth)
    square(size=baseWidth, center=true);
}

module topHole(){
    translate([0,0,baseHeight])
    cylinder(h=topHeight, r=topHoleSize/2);
}

module cableTieHole(){
    difference(){
        cableTieHoleBore();
        cableTieHoleTop();
    }
}

module cableTieHoleBore(){
    tieHoleRadius=tieHoleSize/2;
    translate([0, 0, totalHeight-borderTopVertical/2])
    scale(v=[1, 1, topHeight/tieHoleRadius])
    rotate([90, 0, 0])
    cylinder(h=baseWidth, r=tieHoleRadius, center=true);  
}

module cableTieHoleTop(){
    translate([0,0,totalHeight-borderTopVertical/2])
    cube([baseWidth, baseWidth, topBorder], center=true);
}