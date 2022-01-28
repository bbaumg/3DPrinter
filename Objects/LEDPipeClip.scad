// Provided under a Creative Commons Share Alike License
// CC-BY-SA
// Created by MacLemon

// This Clip is used for mounting an LED strip to a pipe. Either place it between LEDs, or print from translucent material. I recommend using PET-G.

//$fn=30; // Usually fine for rendering previews.
//$fn=60; // Used for final rending to .stl. (Yes, this IS slow.)

pipe_diameter = 15.5; //mm Diameter of the pipe the clip shall hold on to.
outer_diameter = 20; //mm Outer diamter of the clip. (How beefy the clip is.
clip_width = 5; //mm Thickness of the clip. Shall fit in between LEDs.
strip_width = 8.5; //mm How wide the LED strip to be mounted is.
strip_height = .5; //mm Thickness, or how tall is the LED strip including an optional Epoxy cover.

rounding = .5; //mm
clip_thickness = outer_diameter - pipe_diameter; // mm

minkowski(){
    difference(){
        hull(){ // ring + LED strip holder block
            cylinder (r = outer_diameter / 2 - rounding / 2, h = clip_width - rounding, center = true); // Clip Ring
            translate ([(pipe_diameter + strip_height) / 2, 0, 0])
                cube ([ strip_height + clip_thickness - rounding, strip_width + clip_thickness, clip_width - rounding], center = true); // LED Block
            translate ([(-pipe_diameter - strip_height) / 2, 0, 0])
                cube ([ strip_height + clip_thickness - rounding, strip_width + clip_thickness, clip_width - rounding], center = true); // grip Block
        }

        // Remove LED strip cutout
        translate ([(pipe_diameter / 2 + strip_height + rounding)/2, 0, 0])
            cube ([(pipe_diameter / 2 + strip_height + (rounding*2)), strip_width + (rounding*2) , clip_width * 2], center = true);

        // Remove clip on section
        translate ([-sqrt(2 * pow(outer_diameter, 2))/2, 0, 0])
            rotate ([0, 0 ,135]) {
                cube ([outer_diameter, outer_diameter, clip_width * 2 ], center = true);
        }

        // Remove pipe
        #cylinder (r = pipe_diameter / 2 + rounding, h = clip_width * 12, center = true);
    }
    sphere (r = rounding);
}
