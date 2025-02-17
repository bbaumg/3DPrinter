/*************************************************************************************

	Name:					PowerBrickMount
	Purpose:			Use velcro straps to mount power bricks to a surface
	
	Version History:
	- 01/20/2025	Can now add a lip to hold object in place.
								Will now add 2 screws on a side for wider objects.
	
*************************************************************************************/

include <modules/RoundedCube.scad>
include <modules/Modules.scad>

screwSide = 154;				// If you add a lip, be sure to add 2x that to this
velcroSide = 76;				// If you add a lip, be sure to add 2x that to this
velcroWidth = 22;				// Width of ths lot for the velcro
velcroThick = 3;				// Height of the slot for the velcro
withLip = true;					// Enable or disable the lip
lipWidth = 2;						// How wide is the lip if enabled?
lipHeight = 4;					// How tall is the lip if enabled?

// These should not need to be modified much if at all
thickness = 6;					// Object thickness (velcroThick +3 is good, less is flimsy)
cornerRadius = 2;				// Roundness of corner
screwInset = 10;				// How far inset from the edge
screwThreshold = 80;		// One screw per side below and two above
velcroIndent = 20;			// Based on the thickness of the velcro
velcroThreshold = .2;		// Decimial value of percent.  Defualt = .2 or 20%

// Calculations
velcroPct = velcroWidth/velcroSide;
echo(velcroPct);


difference(){
	// Will if have a lip or not
	if (!withLip) {
		// Without lip
		roundedsquare(x=velcroSide, y=screwSide, z=thickness, radius=cornerRadius);
	} else {
		// With lip
		difference(){
			// Create upper block to cut from
			roundedsquare(x=velcroSide, y=screwSide, z=thickness + lipHeight, radius=cornerRadius);
			// Remove lip
			translate([lipWidth,lipWidth,thickness])roundedsquare(x=velcroSide-2*lipWidth, y=screwSide-2*lipWidth, z=thickness + lipHeight, radius=0);
		}
	}
	
	// Remove gap for velcro straps
	// If to determine if 1 or 2 velcro straps (based on velcroThreshold.
	if (velcroPct > velcroThreshold) {
		#translate([(velcroSide-velcroWidth)/2,-1,0])roundedsquare(x=velcroWidth, y=screwSide+2, z=velcroThick, radius=1);
	} else {
		#translate([velcroIndent,-1,0])roundedsquare(x=velcroWidth, y=screwSide+2, z=velcroThick, radius=1);
		#translate([velcroSide-velcroIndent-velcroWidth,-1,0])roundedsquare(x=velcroWidth, y=screwSide+2, z=velcroThick, radius=1);		
	}
	
	// Determine if 1 or 2 screws per side
	if (screwSide <= screwThreshold) {
		// Left screw hole
		#translate ([screwInset,screwSide/2,thickness])screwHole(screwHole=4.5, screwDepth = 10, screwHead = 9, headTaper = 2.3, screwHeadDepth = 5);
		// Right screw hole
		#translate ([velcroSide-screwInset,screwSide/2,thickness])screwHole(screwHole=4.5, screwDepth = 10, screwHead = 9, headTaper = 2.3, screwHeadDepth = 5);
	} else {
		// Left screw hole closer to x axis
		#translate ([screwInset,screwSide/4,thickness])screwHole(screwHole=4.5, screwDepth = 10, screwHead = 9, headTaper = 2.3, screwHeadDepth = 5);
		// Left screw hole further from x axis
		#translate ([screwInset,screwSide/4*3,thickness])screwHole(screwHole=4.5, screwDepth = 10, screwHead = 9, headTaper = 2.3, screwHeadDepth = 5);
		// Right screw holes closer to x axis
		#translate ([velcroSide-screwInset,screwSide/4,thickness])screwHole(screwHole=4.5, screwDepth = 10, screwHead = 9, headTaper = 2.3, screwHeadDepth = 5);
		// Right screw holes further from x axis
		#translate ([velcroSide-screwInset,screwSide/4*3,thickness])screwHole(screwHole=4.5, screwDepth = 10, screwHead = 9, headTaper = 2.3, screwHeadDepth = 5);
	}
}





