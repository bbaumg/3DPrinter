

length = 200;       // total lenght
width = 40;         // total width
height = 12;        // total height
base = 10;          // offset approximate width of base
thickness = .5;     // how thick is the main part, but that is not a real number...
slopeInner = 10;    // degrees of angle for inner cutout
slopeOutter = 5;    // degrees of angle for the outter (bottom)side
innerBevel = 30;    // degrees of angle for the inside bevel
outterBevel = 20;   // angle to remove some outside material
screwOffset = 20;   // how far to move the srew in from the end
screwDepth = 5;     // how deep to set the screw


difference(){
    cube([width, length, height]);
    // Remove the top inner section
    translate([-base,0,thickness]) rotate([0,-slopeInner,0]) cube([width, length, height]);
    // Remove the bottom slope
    translate([0,0,-height]) rotate([0,-slopeOutter,0]) cube([width*2, length, height]);
    // Remove the inner bevel
    translate([0,0,0]) rotate([0,-innerBevel,0]) cube([width, length, height]);
    // Remove the outter bevel
    translate([width,0,height]) rotate([0,outterBevel+90,0]) cube([width, length, height*2]);
    // Remove the front screw
    translate([width-(base/2),screwOffset,screwDepth]) rotate([180,0,0]) screwHole();  // Screw hole
    translate([width-(base/2),length-screwOffset,screwDepth]) rotate([180,0,0]) screwHole();  // Screw head
}


module screwHole(){
    screwHole = 4.5;
    screwDepth = 10;
    screwHead = 9;
    headTaper = 2.3;
    screwHeadDepth = 5;
    translate([0,0,-headTaper])cylinder(d1=screwHole, d2=screwHead, h = headTaper, $fn=20);
    translate([0,0,-headTaper-screwDepth])cylinder(d=screwHole, h=screwDepth, $fn=10);
    translate([0,0,-headTaper-screwDepth])cylinder(d=screwHole, h=screwDepth, $fn=10);
    translate([0,0,0]) cylinder(d=screwHead, h=screwHeadDepth, $fn=10);
}