canisters = 3;
insideWidth = 110;
insideDepth = 80;
insideHeight = 75;
wallThickness = 2;
backThickness = 1;

// Calculated values
totalHeight = (insideHeight*canisters)+(wallThickness*(canisters+1));
echo()
echo("** Total Height = ", totalHeight, "mm");
echo()

// Left side
cube([
    wallThickness,
    insideDepth+backThickness,
    (insideHeight*canisters)+(wallThickness*(canisters+1))]);
// Right side
translate([insideWidth + wallThickness,0,0]) cube([
    wallThickness,
    insideDepth+backThickness,
    (insideHeight*canisters)+(wallThickness*(canisters+1))]);
// Back
translate([0,insideDepth,0]) cube([
    insideWidth + wallThickness*2,
    backThickness,
    (insideHeight * canisters) + (wallThickness * (canisters+1))]);
// Bottom
cube([
    insideWidth + wallThickness*2,
    insideDepth + backThickness,
    wallThickness
    ]);
// Top
translate([0,0,(insideHeight*canisters)+(wallThickness*(canisters))]) cube([
    insideWidth + wallThickness*2,
    insideDepth + backThickness,
    wallThickness
    ]);
// Inside shelves
for (i = [1 : canisters]) {
    translate([0, 0, i * (insideHeight + wallThickness)]) 
    cube([
        insideWidth + wallThickness*2,
        insideDepth + backThickness,
        wallThickness
        ]);
}


//difference(){
//    //cube([
//    //    insideWidth + wallThickness*2, 
//    //    insideDepth + wallThickness,
//    //    insideHeight + wallThickness*2]);
//    //cube([insideWidth, insideDepth,insideHeight]);
//}
