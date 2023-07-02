blockWidth = 10;
blockHeight = 3;
screwDiameter = 2.5;

difference(){
	cube([blockWidth,blockWidth,blockHeight]);
	translate([blockWidth/2,blockWidth/2,-1]) cylinder(d=screwDiameter, h=blockHeight+2);
}