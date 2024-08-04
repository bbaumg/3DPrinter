

baseDiamater = 25;
coneBaseDiamater = 17;
coneHeight = 20;
coneHole = 4;
thickness = 1.8;

$fn=180;

difference(){
	union(){
		cylinder(d=baseDiamater, h=thickness);
		cylinder(d1=coneBaseDiamater, d2=coneHole+thickness, h=coneHeight);
	}
	cylinder(d=coneHole, h=thickness+coneHeight);
	#cylinder(d1=coneBaseDiamater-(2*thickness), d2=coneHole+thickness-(2*thickness), h=coneHeight);

}