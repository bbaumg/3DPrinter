
//Made putting on a mason jar using the metal ring.

jarSize = 85;
baseThick = 1.2;
coneBase = 35;
coneHeight = 25;
coneHole = 5;
coneThick = 4;

difference(){
	union(){
		cylinder(h=baseThick, d=jarSize);
		cylinder(h=coneHeight, d1=coneBase+coneThick, d2=coneHole+coneThick);
	}
	cylinder(h=coneHeight, d1=coneBase, d2=coneHole);
}
