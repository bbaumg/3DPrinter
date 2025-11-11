// Wall thickness
thickness = 3;
// Base section inner diameter
base_ID = 71;
// Base section length
base_length = 20;
// transition length (must be >0)
transition_length = 1;
// Bend radius 
bend_radius = 20;
// Output section inner diameter
output_ID = 58;
// Output section length
output_length = 20;
// Output angle (how sharp the bend is); >45 may need support structures
output_angle = 45;
// Mounting angle, or which way the bend points (0 deg points left)
mount_angle = 45;  // 0 deg points to the right
// Mounting hole offset (distance to edge)
hole_offset = 4.75;   // distance to hole edge
// Spring pin mounting hole diameter (I tried 6.5 and had to drill the hole)
hole_diam = 6.75;
// Slot hole width (diameter) (this fit on my DW735)
slot_width = 6.5;
// Mounting slot length
slot_length = 16;  

///////////////////////////////////////////////////////

$fa=1;

base_R = base_ID/2;
base_outR = base_ID/2+thickness;
output_R = output_ID/2;
output_outR = output_ID/2+thickness;
slot_angle = (slot_length-slot_width)/(2*PI*base_outR)*360;
hole_angle = slot_width/(2*PI*base_outR)*360;

// Base section with mounting holes

difference(){
    cylinder(r=base_outR, h=base_length);
    cylinder(r=base_R, h=base_length);
    // Create mounting holes
    translate([0,0,hole_offset+hole_diam/2]){
      // simple hole (right side)  
      rotate([90,0,0])   
        cylinder(r=hole_diam/2,h=base_outR+1);
    }
    translate([0,0,hole_offset+slot_width/2]){
      // slot hole (left side)
      hull(){
        rotate([90,0,180])
          cylinder(r=slot_width/2,h=base_outR+1);
        rotate([90,0,180-slot_angle])
          cylinder(r=slot_width/2,h=base_outR+1);
      }
    }
    // notch to connect to slot hole
    rotate([0,0,-slot_angle+hole_angle/2+90])
      rotate_extrude(angle=-hole_angle)
        translate([base_R-0.5,0,0])
          square([thickness+1, hole_offset+slot_width/2]);
}
   

// This creates the transition from the base radius to the output
// radius in a smooth fashion.  The module makes a solid that needs
// to be differenced with the radii as input.  The "extra" parameter
// is to allow the inner object to have a bit extra angular extrusion
// to ensure that the subtracted object doesn't have an extra surface
// at the end.  
module bendsection(baseR,outR,extra){
  hull(){
    // Make bend
    translate([-(base_outR-output_outR), 0, 0])
      rotate([0,0, mount_angle+90])
        translate([-output_outR-bend_radius,0,base_length+transition_length])
          rotate([90,0,0])
            rotate_extrude(angle=output_angle+extra)
              translate([output_outR+bend_radius,0,0])
                circle(r=outR);             
    // Make base circle
    translate([0,0,base_length])
      cylinder(r=baseR, h=0.1);
  } 
}

difference(){
    bendsection(base_outR, output_outR, 0);  
    bendsection(base_R, output_R, 1);
}    


// Output section, the final straight section

translate([-(base_outR-output_outR), 0, 0])
  rotate([0,0, mount_angle+90])
    translate([-output_outR-bend_radius,0,base_length+transition_length])
      rotate([90,0,0])
        rotate([0,0,output_angle])
          translate([output_outR+bend_radius,0,0])
            rotate([-90,0,0])      
              difference(){
                cylinder(r=output_outR, h=output_length);
                cylinder(r=output_R, h=output_length);  
     }  
  
  