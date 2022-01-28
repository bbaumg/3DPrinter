


shape = "curve";        //"curve" or "flat"
radius = 20;            // how big should the curve, or angle be?
overallThickness = 4;
wallThickness = 4;
wallHeight = 10;
wallLength = 50;
overallWidth = 100;     //default = 100.  If radius > 90 then set "radius + 25 + wallLength"
fingerHole = 15;
textSize = 5;
textDepth = .5;         // .5mm is pretty good...

//Inch Conversions
    // 1/4"     =  6.35 mm
    // 5/16"    =  7.94 mm
    // 3/8"     =  9.53 mm
    // 7/16"    = 11.11 mm
    // 1/2"     = 12.70 mm
    // 3/4"     = 19.05 mm
    // 1"       = 25.40 mm
    // 1 1/2"   = 31.75 mm
    // 1 3/4"   = 44.45 mm
    // 2"       = 50.80 mm

//--  Don't Change these values
measurement = "mm";
$fn = 100;


//The main object


difference(){
    union(){
        cube([overallWidth, overallWidth, overallThickness]);                   //The main cube
        translate([overallWidth/2,-wallThickness,0])
            cube([overallWidth/2,wallThickness,wallHeight+overallThickness]);   //X Axis Wall
        translate([-wallThickness,overallWidth/2,0])
            cube([wallThickness,overallWidth/2,wallHeight+overallThickness]);   //Y Axis Wall
    }
    //Remove the raidus or angle
    if (shape=="curve"){
        translate([radius, radius, -1]) rotate([0,0,180])
            difference(){
                cube([radius + 1, radius + 1, overallThickness + 2]);
                #cylinder(r = radius, h = overallThickness + 2);
            }
    } else if (shape=="flat"){
        #translate([0,0,overallThickness/2]) 
            rotate([0,0,-45])
                cube([radius*2, radius, overallThickness + 2], center = true);
    }
    //Remove the outter curve
    translate([0, 0, -1]) rotate([0,0,0])
        difference(){
            cube(size = [overallWidth + 1, overallWidth + 1, overallThickness + 2]);
            cylinder(r = overallWidth, h = overallThickness + 2);
        }
    //Remove the text
    #translate([overallWidth/6, overallWidth/6, overallThickness-textDepth+.1]) 
        rotate([0,0,0])
            linear_extrude(textDepth) 
                text(text = str(radius, "mm"), size = textSize);
    //Remove the finger hole
    translate([overallWidth/2,overallWidth/2,-1])
        cylinder(r = fingerHole, h = overallThickness + 2);
    //Remove text on X Axis Wall
    #translate([overallWidth/2+5,-wallThickness+textDepth-.1, (overallThickness+wallHeight-textSize)/2])
        rotate([90,0,0])
            linear_extrude(textDepth) 
                text(text = str(radius, "mm"), size = textSize);
    //Remove text on Y Axis Wall
    #translate([-wallThickness+textDepth-.1,overallWidth-5,(overallThickness+wallHeight-textSize)/2])
        rotate([90,0,-90])
            linear_extrude(textDepth) 
                text(text = str(radius, "mm"), size = textSize);
}


















