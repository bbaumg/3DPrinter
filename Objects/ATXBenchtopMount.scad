


//  ATX Standards:  https://landing.coolermaster.com/faq/what-are-the-mounting-hole-dimensions-for-my-atx-power-supply/


faceHeight = 160;
faceWidth = 90;
faceThick = 4;
frameSpaceX = 7;
frameSpaceY = 15;
dispHeight = 30;
dispWidth = 46;
dispSpaceX = frameSpaceX;
dispSpaceY = 10;
fuseDiamater = 10;
plugDiamater = 7;


$fn = 60;



difference(){
	cube([faceWidth, faceHeight, faceThick]);
	for (i = [0:1:2]){
		echo(i);
		// Remove displays
		translate([dispSpaceX,frameSpaceY+(i*(dispHeight+dispSpaceY)),-1]) cube([dispWidth, dispHeight, faceThick+2]);
		// Remove screw holes

		// Remove fuse holes
		translate([faceWidth-frameSpaceX-(fuseDiamater/2),frameSpaceY+(i*(dispHeight+dispSpaceY))+(dispHeight/2),-1]) rotate([0,0,0]) cylinder(d=fuseDiamater, h=faceThick+2);
		// calculate plug placement on X axis
		//plugSpaceX = frameSpace*2+dispWidth+(plugDiamater/2);
		test = (faceWidth-2*frameSpaceX-dispWidth-fuseDiamater)/2;
		echo(test);
		plugSpaceX = frameSpaceX+dispWidth+(faceWidth-2*frameSpaceX-dispWidth-fuseDiamater)/2;
		// Remove + plug hole
		translate([plugSpaceX,frameSpaceY+(i*(dispHeight+dispSpaceY))+(dispHeight/5*1),-1]) rotate([0,0,0]) cylinder(d=plugDiamater, h=faceThick+2);
		// Remove - plug Hole
		translate([plugSpaceX,frameSpaceY+(i*(dispHeight+dispSpaceY))+(dispHeight/5*4),-1]) rotate([0,0,0]) cylinder(d=plugDiamater, h=faceThick+2);
	}
}

