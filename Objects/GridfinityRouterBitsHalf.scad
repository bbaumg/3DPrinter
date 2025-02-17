use <../../gridfinity-openscad-model-model_files/gridfinity_cup_modules.scad>

// X dimension in grid units
width = 2; // [ 0.5, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 ]
// Y dimension in grid units
depth = 3; // [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 ]
// Z dimension (multiples of 7mm)
height = 3;
// (Zack's design uses magnet diameter of 6.5)
magnet_diameter = 0;  // .1
// (Zack's design uses depth of 6)
screw_depth = 0;
// Hole overhang remedy is active only when both screws and magnets are nonzero (and this option is selected)
hole_overhang_remedy = true;
//Only add attachments (magnets and screw) to box corners (prints faster).
box_corner_attachments_only = false;
// Fill in solid block (overrides all following options)
filled_in = true;
// X dimension subdivisions
chambers = 0;
// Include overhang for labeling (and specify left/right/center justification)
withLabel = "disabled"; // ["disabled", "left", "right", "center", "leftchamber", "rightchamber", "centerchamber"]
// Include larger corner fillet
fingerslide = true;
// Width of the label in number of units, or zero means full width
labelWidth = 0;  // .01
// Minimum thickness above cutouts in base (Zack's design is effectively 1.2)
floor_thickness = 0.7;
// Wall thickness (Zack's design is 0.95)
wall_thickness = 0.95;  // .01
// Efficient floor option saves material and time, but the floor is not smooth (only applies if no magnets, screws, or finger-slide used)
efficient_floor = false;
// When enabled, irregular subdivisions have to be defined in code
irregular_subdivisions = false;
// Enable to subdivide bottom pads to allow half-cell offsets
half_pitch = false;
// Remove some or all of lip
lip_style = "normal";  // [ "normal", "reduced", "none" ]

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


difference(){
	grid_block(width, depth, height, magnet_diameter=magnet_diameter, screw_depth=screw_depth, hole_overhang_remedy=hole_overhang_remedy, half_pitch=half_pitch, box_corner_attachments_only=box_corner_attachments_only);
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