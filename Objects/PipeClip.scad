// This Clip is used for mounting an LED strips, wires, or antying small and relatively flat to a pipe.
//-------------------------------------------------------------------------------------

//$fn=20;   // Used when doing prototyping design (faster rendering)
$fn=60;     // Used for final rending to .stl. (Very SLOW rendering.)

pipeDiameter = 15.5;    // Diamater of the pipe, inner diamater of the clip
outerDiameter = 20;     // Outer diamater of the clip
clipWidth = 5;          // Thickness of the clip
objectWidth = 3.5;      // Width of the object to hold
objectHeight = 1.5;     // Height of the object to hold
rounding = .5;          // How much to round off the edges

// Common settings:
    // LED Strip
        //pipeDiameter = 15.5;    // Diamater of the pipe, inner diamater of the clip
        //outerDiameter = 20;     // Outer diamater of the clip
        //clipWidth = 5;          // Thickness of the clip
        //objectWidth = 8;      // Width of the object to hold
        //objectHeight = .5;     // Height of the object to hold
    //  Strip
        //pipeDiameter = 15.5;    // Diamater of the pipe, inner diamater of the clip
        //outerDiameter = 20;     // Outer diamater of the clip
        //clipWidth = 5;          // Thickness of the clip
        //objectWidth = 3.5;      // Width of the object to hold
        //objectHeight = 1.5;     // Height of the object to hold

//-------------------------------------------------------------------------------------
clipThickness = outerDiameter - pipeDiameter;

minkowski(){
    difference(){
        hull(){ // ring + object holder block
            cylinder (r = outerDiameter / 2 - rounding / 2, h = clipWidth - rounding, center = true); // Clip ring
            translate ([(pipeDiameter + objectHeight) / 2, 0, 0])
                cube ([ objectHeight + clipThickness - rounding, objectWidth + clipThickness, clipWidth - rounding], center = true); // Object block
            translate ([(-pipeDiameter - objectHeight) / 2, 0, 0])
                cube ([ objectHeight + clipThickness - rounding, objectWidth + clipThickness, clipWidth - rounding], center = true); // Grip block
        }

        // Remove object cutout
        translate ([(pipeDiameter / 2 + objectHeight + rounding)/2, 0, 0])
            cube ([(pipeDiameter / 2 + objectHeight + (rounding*2)), objectWidth + (rounding*2) , clipWidth * 2], center = true);

        // Remove clip on section
        translate ([-sqrt(2 * pow(outerDiameter, 2))/2, 0, 0])
            rotate ([0, 0 ,135]) {
                cube ([outerDiameter, outerDiameter, clipWidth * 2 ], center = true);
        }

        // Remove pipe
        #cylinder (r = pipeDiameter / 2 + rounding, h = clipWidth * 12, center = true);
    }
    sphere (r = rounding);
}
