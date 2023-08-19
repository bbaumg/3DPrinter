
blockX = 200;
//blockY = 20;
blockY = round(blockX / 1.618);
blockHeight = 30;
blockBase = 1;      // minimum thickness at the base of the block
edgePad = 10;		// amount of additional padding around the outer frame.
holeSize = 13.5;     	// 1/4 bit = 7, 1/2 bit = 13.5
holeSpacing = holeSize * .75;  //2 works well for 1/4 & .75 works well for 1/2 in
edgeRounding = 1;





//Calculations
holesX = floor((blockX-(edgePad))/(holeSize+holeSpacing));
echo(holesX);
holesY = floor((blockY-(edgePad))/(holeSize+holeSpacing));
echo(holesY);
paddingX = (blockX-(holesX*(holeSize+holeSpacing))+holeSpacing)/2;
echo(paddingX);
paddingY = (blockY-(holesY*(holeSize+holeSpacing))+holeSpacing)/2;;
echo(paddingY);

$fn=30;

//  Object
difference(){
	minkowski(){
		cube([blockX, blockY, blockHeight-edgeRounding]);
		sphere(edgeRounding);
	}
	for (y=[0:holesY-1]){
		for (x=[0:holesX-1]){
			translate([
				(holeSpacing+holeSize)*x+paddingX+holeSize/2, 
				(holeSpacing+holeSize)*y+paddingY+holeSize/2, 
				blockBase])
				cylinder(h=blockHeight-blockBase+.1, d1=holeSize-.25, d2=holeSize);
			translate([
				(holeSpacing+holeSize)*x+paddingX+holeSize/2, 
				(holeSpacing+holeSize)*y+paddingY+holeSize/2,
				blockHeight-holeSize/2+.1]) 
				#cylinder(h=holeSize/2, d1=1, d2=holeSize+4);
		}
	}
}