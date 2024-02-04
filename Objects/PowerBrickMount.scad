/*************************************************************************************

	Name:		PowerBrickMount
	Purpose:	Use velcro straps to mount power bricks to a surface
	
*************************************************************************************/

include <modules/RoundedCube.scad>
include <modules/Modules.scad>

shortSide = 76;
longSide = 154;
velcroWidth = 22;
velcroThick = 3;

// These should not need to be modified much if at all
thickness = 7;
cornerRadius = 3;
screwInset = 10;
velcroIndent = 20;
velcroThreshold = .2;

// Calculations
velcroPct = velcroWidth/longSide;
echo(velcroPct);


difference(){
	roundedsquare(x=longSide, y=shortSide, z=thickness, radius=cornerRadius);
	// Remove gap for velcro straps
	// If to determine if 1 or 2 velcro straps (based on velcroThreshold.
	if (velcroPct > velcroThreshold) {
		#translate([(longSide-velcroWidth)/2,-1,0])roundedsquare(x=velcroWidth, y=shortSide+2, z=velcroThick, radius=1);
	} else {
		#translate([velcroIndent,-1,0])roundedsquare(x=velcroWidth, y=shortSide+2, z=velcroThick, radius=1);
		#translate([longSide-velcroIndent-velcroWidth,-1,0])roundedsquare(x=velcroWidth, y=shortSide+2, z=velcroThick, radius=1);		
	}
	// Left screw hole
	#translate ([screwInset,shortSide/2,thickness])screwHole(screwHole=4.5, screwDepth = 10, screwHead = 9, headTaper = 2.3, screwHeadDepth = 5);
	// Right screw hole
	#translate ([longSide-screwInset,shortSide/2,thickness])screwHole(screwHole=4.5, screwDepth = 10, screwHead = 9, headTaper = 2.3, screwHeadDepth = 5);
}