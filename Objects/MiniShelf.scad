/*
    Multi-level mini storage shelving.  Can be customized for the number of identical sections.
    
    Settings for 3x 100g isobutane shelves
        shelves = 3;
        insideWidth = 110;
        insideDepth = 80;
        insideHeight = 73;
        wallThickness = 2;
        backThickness = 1;

*/

// Configuration Settings
shelves = 3;
insideWidth = 110;
insideDepth = 80;
insideHeight = 73;
wallThickness = 2;
backThickness = 1;

// Calculated values
totalHeight = (insideHeight*shelves)+(wallThickness*(shelves+1));
echo()
echo("** Total Height = ", totalHeight, "mm");
echo()

// Left side
cube([
    wallThickness,
    insideDepth+backThickness,
    (insideHeight*shelves)+(wallThickness*(shelves+1))]);

// Right side
translate([insideWidth + wallThickness,0,0]) cube([
    wallThickness,
    insideDepth+backThickness,
    (insideHeight*shelves)+(wallThickness*(shelves+1))]);

// Back
translate([0,insideDepth,0]) cube([
    insideWidth + wallThickness*2,
    backThickness,
    (insideHeight * shelves) + (wallThickness * (shelves+1))]);

// Bottom
cube([
    insideWidth + wallThickness*2,
    insideDepth + backThickness,
    wallThickness
    ]);

// Top
translate([0,0,(insideHeight*shelves)+(wallThickness*(shelves))]) cube([
    insideWidth + wallThickness*2,
    insideDepth + backThickness,
    wallThickness
    ]);

// Inside shelves
for (i = [1 : shelves]) {
    translate([0, 0, i * (insideHeight + wallThickness)]) 
    cube([
        insideWidth + wallThickness*2,
        insideDepth + backThickness,
        wallThickness
        ]);
}