radius1 = 3;
radius2 = 5;
radius3 = 7;
radius4 = 9;
width = 30;
thickness = 5;
textDepth = .5;
textSize = 4;

$fn=60;
difference(){
    cube([width,width,thickness]);
    
    translate([0,0,0]) rotate([0,0,0]) fillet(radius1,thickness);
    #translate([radius1/2,radius1/2,thickness-textDepth+.1]) rotate([0,0,0]) 
        linear_extrude(textDepth) text(text = str(radius1, "mm"), size = textSize);
    
    translate([width,0,0]) rotate([0,0,90]) fillet(radius2,thickness);
    #translate([width-radius2/2,radius2/2,thickness-textDepth+.1]) rotate([0,0,90]) 
        linear_extrude(textDepth) text(text = str(radius2, "mm"), size = textSize);
    
    translate([width,width,0]) rotate([0,0,180]) fillet(radius3,thickness);
    #translate([width-radius3/2,width-radius3/2,thickness-textDepth+.1]) rotate([0,0,180]) 
        linear_extrude(textDepth) text(text = str(radius3, "mm"), size = textSize);
    
    translate([0,width,0]) rotate([0,0,270]) fillet(radius4,thickness);
    #translate([radius4/2,width-radius4/2,thickness-textDepth+.1]) rotate([0,0,270]) 
        linear_extrude(textDepth) text(text = str(radius4, "mm"), size = textSize);
}
//dispText();

module dispText(whatText = "Hi", size = 5, height = 1){
    
    linear_extrude(height) text(text = str(whatText), size = size);
}

module fillet(radius = 1, height = 1){
    translate([radius, radius, -1]) rotate([0,0,180])
        difference(){
            cube([radius + 1, radius + 1, height + 2]);
            #cylinder(r = radius, h = height + 2);
        }
}



//fillet(radius1,thickness);
