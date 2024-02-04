

height = 60;
width = 80;
thick = 10;
logSize = 3;
logDepth = 3;
logSpace = .5;

// Calculations
logCount = round(height/((logSize*2)+logSpace));
echo(logCount);

actualHight = (logCount*((logSize*2)+logSpace))+logSpace;
echo(actualHight);

// Object
difference(){
	cube([width, actualHight, thick]);
	for (i = [0 : logCount-1]){
		translate([0,(logSize*2*i)+(logSpace*i)+logSize+logSpace,thick+(logSize-logDepth)]) 
			rotate([0,90,0]) cylinder(h=width, r=logSize);
	}
}