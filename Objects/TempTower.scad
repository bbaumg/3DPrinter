

/* ------------------------------------------------------
	Origional Source:  https://www.thingiverse.com/thing:4938357/files
	
	Default Settings:  (See bottom for more preset settings
		// [Basic] //
		// Number Of Levels
		Levels = 6;
		// Temperature Increment Per block
		tempIncrement = 10;
		// Starting Temperature
		startTemp = 240;
		// Temperature Ascending Or Descending
		tempOrder = -1; // [-1:Descending, 1:Ascending]
		//Type Of Base On the Tower
		baseType = 2; // [0:None, 1:Rounded, 2:Basic]
		// Depth Of Each Layer (Values Less Than coneStartRadius Or 4 May Cause Issues)
		levelDepth = 10;
		// Height Of Each Layer (Values Less Than 3 Or More Than 25 May Cause Isues)
		levelHeight = 10;

		// [ Temperature Block ] //
		enableTemperature = 1; // [0, 1]
		//Width Of The Temperature Component (Larger Width Allows For Bigger Text - Scales Automatically)
		temperatureWidth = 10;

		// [ Bridging Test ] //
		enableBridge = 1; // [0, 1]
		// Distance Of Bridge
		bridgeDistance = 30;
		// Thickness Of Bridge
		bridgeThickness = 2;

		// [ Stringing Test] //
		enableStringing = 1; // [0, 1]
		// Stringing Cone Start Radius
		coneStartRadius = 3;
		//Stringing Cone End Radius
		coneEndRadius = 0;
		// Number Of Stringing Cones
		coneAmmount = 1;

		// [ Overhang Test ] //
		enableOverhang = 1; // [0, 1]
		// Max Overhang Angle
		overhangAngle = 90; // [1:90]
		// Total Distance Of Overhang 
		overhangDistance = 10;
		// Number Of Angle Steps In Overhang
		overhangSteps = 10;
		// Thickness Of The Top Of The Overhang
		overhangShelfThickness = 0.5;

		// [Advanced] //
		// Detail Of Round Components (High Values Effect Render Time Significantly)
		Detail = 20;
		// Extra Margin around the base
		baseMargin = 5;
		// Font
		Font = "Liberation Sans:bold";

		$fn = Detail;

		// [Experimental] //
		//Support For These Variables Haven't Properly Been Added So Changing Values Too Much Could Break Things
		NOTE = "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^";
		// Thickness of the base
		baseHeight = 1;
		// Width of the block supporting the bridge
		bridgeSupportWidth = 8;
		// Width of the block supporting the stringing bridge
		stringingSupportWidth = 8;
		// Moves the overhang support (best not to touch)
		overhangSupportWidth = 8;

*/

// [Basic] //
// Number Of Levels
Levels = 4;
// Temperature Increment Per block
tempIncrement = 5;
// Starting Temperature
startTemp = 210;
// Temperature Ascending Or Descending
tempOrder = -1; // [-1:Descending, 1:Ascending]
//Type Of Base On the Tower
baseType = 2; // [0:None, 1:Rounded, 2:Basic]
// Depth Of Each Layer (Values Less Than coneStartRadius Or 4 May Cause Issues)
levelDepth = 10;
// Height Of Each Layer (Values Less Than 3 Or More Than 25 May Cause Isues)
levelHeight = 8;

// [ Temperature Block ] //
enableTemperature = 1; // [0, 1]
//Width Of The Temperature Component (Larger Width Allows For Bigger Text - Scales Automatically)
temperatureWidth = 10;

// [ Bridging Test ] //
enableBridge = 1; // [0, 1]
// Distance Of Bridge
bridgeDistance = 30;
// Thickness Of Bridge
bridgeThickness = 2;

// [ Stringing Test] //
enableStringing = 1; // [0, 1]
// Stringing Cone Start Radius
coneStartRadius = 3;
//Stringing Cone End Radius
coneEndRadius = .2;
// Number Of Stringing Cones
coneAmmount = 1;

// [ Overhang Test ] //
enableOverhang = 1; // [0, 1]
// Max Overhang Angle
overhangAngle = 90; // [1:90]
// Total Distance Of Overhang 
overhangDistance = 10;
// Number Of Angle Steps In Overhang
overhangSteps = 10;
// Thickness Of The Top Of The Overhang
overhangShelfThickness = 0.5;

// [Advanced] //
// Detail Of Round Components (High Values Effect Render Time Significantly)
Detail = 20;
// Extra Margin around the base
baseMargin = 5;
// Font
Font = "Liberation Sans:bold";

$fn = Detail;

// [Experimental] //
//Support For These Variables Haven't Properly Been Added So Changing Values Too Much Could Break Things
NOTE = "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^";
// Thickness of the base
baseHeight = 1;
// Width of the block supporting the bridge
bridgeSupportWidth = 3;
// Width of the block supporting the stringing bridge
stringingSupportWidth = 8;
// Moves the overhang support (best not to touch)
overhangSupportWidth = 8;

//Create Empty Module To Stop Below Variables From Being Shown In The Customizer
module __Customizer_Limit__ () {}

stringingWidth = coneStartRadius*coneAmmount*2;
baseDepth = levelDepth+baseMargin;

module tower()
{
    // Create The Base And Pass In The Width Based Of Which Modules Are Enabled And How Large Each One Is
    base((temperatureWidth*enableTemperature)+(bridgeDistance*enableBridge+bridgeSupportWidth)+(enableStringing*(stringingWidth+stringingSupportWidth))+(enableOverhang*(overhangSupportWidth/2+overhangDistance))+baseMargin);

    // Itterate Through Each Level And Create Enabled Blocks
    for (x = [0:Levels-1])
    {
        // Create Temperature Block If Enabled
        if (enableTemperature == 1)
        {
             translate([baseMargin/2, baseMargin/2, x*levelHeight+1])
            {
            temperature(x, startTemp+(x*(tempIncrement*tempOrder)));
            }
        }
        
        // Create Bridge Test If Enabled
        if (enableBridge == 1)
        {
            translate([(enableTemperature*temperatureWidth)+baseMargin/2, baseMargin/2, x*levelHeight+1])
            {
                bridge();
            }
        }
        
        // Create Stringing Test If Enabled
        if (enableStringing == 1)
        {
            translate([(enableTemperature*temperatureWidth)+(enableBridge*(bridgeDistance+bridgeSupportWidth))+baseMargin/2, baseMargin/2, x*levelHeight+1])
            {
                stringing();
            }
        }
        
        // Create Overhang Test If Enabled
        if (enableOverhang == 1)
        {
            translate([(enableTemperature*temperatureWidth)+(enableBridge*(bridgeDistance+bridgeSupportWidth))+(enableStringing*(stringingSupportWidth+coneStartRadius*coneAmmount*2))+baseMargin/2, baseMargin/2, x*levelHeight+1])
            {
                overhang();
            }
        }
    }
}

//Module For Creating The Overhang Test
module overhang()
{
    //Add Support Tower For Attaching The Component
    translate([0, 0, 1]) cube([stringingSupportWidth/2,levelDepth,levelHeight-1]);
    translate([1, 1, 0]) cube([stringingSupportWidth/2-1,levelDepth-2,1]);
    
    
    
    translate([0, 0, 0])
    {
        //Use Triganometry To Calculate How Long And High Each Overhang Test Needs To Be
        a = 180-90-overhangAngle;
        b = overhangDistance*sin(a)/sin(90);
        dist = overhangDistance-b; //Distance Of Overhang
        
        height = overhangDistance*sin(overhangAngle)/sin(90); //Height Of Overhang
        
        // If The Height Of The OverHang Is Less Than The Height Of Each Level
        if (height <= levelHeight)
        {
            difference()
            {
                translate([overhangSupportWidth/2, 0, 0])
                {               
                    cube([dist-0.01, levelDepth, height]);
                }
                
                translate([overhangSupportWidth/2+overhangDistance, levelDepth+1, -overhangShelfThickness])
                {
                        //Create A 2D Sqaure The Length Of The Overhang And Rotate Extrude It To overhangAngle Setting $fn To Equal overhangSteps Multiplied By The Ammount Of OverhangAngles Needed To Make A Full 360 Degrees
                    rotate([90, -(90+(90-overhangAngle)), 0]) rotate_extrude(angle = overhangAngle, $fn = overhangSteps*(360/overhangAngle)) square([overhangDistance, levelDepth+2]);
                }
            }
        }
        else // If The Height Of The OverHang Is More Than The Height Of Each Level, Cut The Bottom Of The OverHang Block Off To Match The Height Of The Layer And Move It Up To Match The Height Of The Layer
        {
            translate([0, 0, -(height-levelHeight)])
            {
                difference()
                {
                    translate([overhangSupportWidth/2, 0, 0])
                    {              
                        cube([dist-0.01, levelDepth, height]);
                    }
                    
                    translate([overhangSupportWidth/2+overhangDistance, levelDepth+1, 0])
                    {
                        
                        //Create A 2D Sqaure The Length Of The Overhang And Rotate Extrude It To overhangAngle Setting $fn To Equal overhangSteps Multiplied By The Ammount Of OverhangAngles Needed To Make A Full 360 Degrees
                        rotate([90, -(90+(90-overhangAngle)), 0]) rotate_extrude(angle = overhangAngle, $fn = overhangSteps*(360/overhangAngle)) square([overhangDistance, levelDepth+2]);
                    }
                    translate([overhangSupportWidth/2-1, -1, -1]) cube([dist+1, levelDepth+2, height-levelHeight]);   
                }
            }
        }
    }
    
}

//Module For Creating The Stringing Test
module stringing()
{
    //Add Support Tower For Attaching The Component
    translate([0, 0, 1]) cube([stringingSupportWidth/2,levelDepth,levelHeight-1]);
    translate([1, 1, 0]) cube([stringingSupportWidth/2-1,levelDepth-2,1]);
    
    translate([stringingWidth+stringingSupportWidth/2, 0, 0]) 
    {
        translate([0, 0, 1]) cube([stringingSupportWidth/2,levelDepth,levelHeight-1]);
        translate([0, 1, 0]) cube([stringingSupportWidth/2-1,levelDepth-2,1]);
    }
    
    translate([stringingSupportWidth/2, 1, 0]) cube([stringingWidth, levelDepth-2, levelHeight/8]);  
    
    //Create coneAmmount Number Of Cones And Space Them So Base Of The Cones Touch Each Other
    for (n = [1:coneAmmount])
    {
        translate([coneStartRadius*2*n-coneStartRadius+stringingSupportWidth/2, levelDepth/2, 0]) cylinder(levelHeight-levelHeight/8, coneStartRadius, coneEndRadius);
    }
}


//Module For Creating The Bridging Test
module bridge()
{
    //Add Support Tower For Attaching The Component
    translate([0, 0, 1]) cube([bridgeSupportWidth/2,levelDepth,levelHeight-1]);
    translate([0, 1, 0]) cube([bridgeSupportWidth/2,levelDepth-2,1]);
    
    translate([bridgeDistance+bridgeSupportWidth/2, 0, 0]) 
    {
        translate([0, 0, 1]) cube([4,levelDepth,levelHeight-1]);
        translate([0, 1, 0]) cube([bridgeSupportWidth/2,levelDepth-2,1]);
    }
    
    translate([bridgeSupportWidth/2, 1, (levelHeight/2)-(bridgeThickness)/2]) cube([bridgeDistance, levelDepth-2, bridgeThickness]);
    
    difference()
    {
        translate([bridgeSupportWidth/2, 1, levelHeight/2])
        {
            rotate([-90, 0, 0]) cylinder(levelDepth-2, levelHeight/1.5, levelHeight/1.5, $fn = 3);
        }
        //Remove The Top Half Of The Triangles From The Champhered Supports So That The Top Of The Bridges Are Flat
        translate([-levelHeight/2, 0, levelHeight/2]) cube([bridgeDistance+bridgeSupportWidth+levelHeight, levelDepth, levelHeight]);
        //Remove The Tips Of The Triangles From The Bottom Of The Champhered Supports That Protrude Below The Layer
        translate([-levelHeight/2, 0, -levelHeight+1]) cube([bridgeDistance+bridgeSupportWidth+levelHeight, levelDepth, levelHeight]);
    }
    
    difference()
    {
        translate([bridgeDistance+bridgeSupportWidth/2, 1, levelHeight/2])
        {
            rotate([-90, 180, 0]) cylinder(levelDepth-2, levelHeight/1.5, levelHeight/1.5, $fn = 3);
        }
        //Remove The Top Half Of The Triangles From The Champhered Supports So That The Top Of The Bridges Are Flat
        translate([-levelHeight/2, 0, levelHeight/2]) cube([bridgeDistance+bridgeSupportWidth+levelHeight, levelDepth, levelHeight]);
        //Remove The Tips Of The Triangles From The Bottom Of The Champhered Supports That Protrude Below The Layer
        translate([-levelHeight/2, 0, -levelHeight+1]) cube([bridgeDistance+bridgeSupportWidth+levelHeight, levelDepth, levelHeight]);
    }
}

//Module For Creating The Temperature Block
module temperature(x, temp)
{
    difference()
    {
        translate([0, 0, 1]) cube([temperatureWidth, levelDepth, levelHeight-1]);
        
        translate([0.5, 0.5, 1.5]) 
        {
            // Check If The Width Of The Temperature Block Will Be The Limiting Factor For Temperature
            if (temperatureWidth/2.5 <= levelHeight/2)
            {
                //Create, Scale And Extrude The Text Into The Block
                rotate([90, 0, 0]) linear_extrude(2) text(str(temp), font = Font, size=temperatureWidth/2.5);
            }
            // If The Height Of The Temperature Block Will Be The Limiting Factor For Temperature
            else
            {
                //Create, Scale And Extrude The Text Into The Block
                rotate([90, 0, 0]) linear_extrude(2) text(str(temp), font = Font, size=levelHeight/2);
            }
        }
    }
        translate([1, 1, 0]) cube([temperatureWidth-2, levelDepth-2, levelHeight-1]);
}


//Module For Creating The Base    
module base(width)
{
    //If baseType = 0 Don't Create Any Base
    
    //Create Rounded Base
    if (baseType == 1)
    {
        translate([width/2, baseDepth/2, baseHeight/2])
        {
            rounded_rectangle(width, baseDepth, baseHeight, 5);
        }
    }
    //Create Square Base
    else if (baseType == 2)
    {
        cube([width, baseDepth, 1]);
    }
}

//Module For Creating Rounded Rectangles
// Created By papachristoumarios - https://www.thingiverse.com/thing:213733
// Licensed under theGNU - GPLlicense.
module rounded_rectangle(x,y,z,roundness) {
    intersection() {
        semi_rounded_rectangle(x,y,z,roundness);
        mirror([1,0,0]) semi_rounded_rectangle(x,y,z,roundness);


    }
}

// Module For Creating Rounded Rectangles
// Created By papachristoumarios - https://www.thingiverse.com/thing:213733
// Licensed under theGNU - GPLlicense.
module semi_rounded_rectangle(x,y,z,roundness) {

    difference() {	
        cube([x,y,z],center=true);
        translate([-x/2,-y/2,0]) rounded_edge(roundness,z+1);
        rotate([0,0,-180]) translate([-x/2,-y/2,0]) rounded_edge(roundness,z+1);
        rotate([0,0,90]) translate([x/2,y/2,0]) rounded_edge(roundness,z+1);

    }
}

// Module For Creating Rounded Edges
// Created By papachristoumarios - https://www.thingiverse.com/thing:213733
// Licensed under theGNU - GPLlicense.
module rounded_edge(r, h) {
    translate([r / 2, r / 2, 0])

        difference() {
            
				cube([r + 0.01, r + 0.01, h], center = true);

            translate([r/2, r/2, 0])
                cylinder(r = r, h = h + 1, center = true);
        }
}

//Create Tower
tower();             





/* ------------------------------------------------------
Smaller-Mini Tower:
	// [Basic] //
	// Number Of Levels
	Levels = 6;
	// Temperature Increment Per block
	tempIncrement = 10;
	// Starting Temperature
	startTemp = 240;
	// Temperature Ascending Or Descending
	tempOrder = -1; // [-1:Descending, 1:Ascending]
	//Type Of Base On the Tower
	baseType = 2; // [0:None, 1:Rounded, 2:Basic]
	// Depth Of Each Layer (Values Less Than coneStartRadius Or 4 May Cause Issues)
	levelDepth = 10;
	// Height Of Each Layer (Values Less Than 3 Or More Than 25 May Cause Isues)
	levelHeight = 10;

	// [ Temperature Block ] //
	enableTemperature = 1; // [0, 1]
	//Width Of The Temperature Component (Larger Width Allows For Bigger Text - Scales Automatically)
	temperatureWidth = 10;

	// [ Bridging Test ] //
	enableBridge = 1; // [0, 1]
	// Distance Of Bridge
	bridgeDistance = 30;
	// Thickness Of Bridge
	bridgeThickness = 2;

	// [ Stringing Test] //
	enableStringing = 1; // [0, 1]
	// Stringing Cone Start Radius
	coneStartRadius = 3;
	//Stringing Cone End Radius
	coneEndRadius = 0;
	// Number Of Stringing Cones
	coneAmmount = 1;

	// [ Overhang Test ] //
	enableOverhang = 1; // [0, 1]
	// Max Overhang Angle
	overhangAngle = 90; // [1:90]
	// Total Distance Of Overhang 
	overhangDistance = 10;
	// Number Of Angle Steps In Overhang
	overhangSteps = 10;
	// Thickness Of The Top Of The Overhang
	overhangShelfThickness = 0.5;
*/



