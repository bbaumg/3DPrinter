



Base_Width = 110;
Base_Depth = 125;
Height = 25;
Angle = 10; // Degrees
Lip_Thickness = 9;
Slot_Width = 15;
Slot_Rise = 8;
Back_Bevel = -17;  // Degrees

echo(Angle);

module fillet(r,h){
    difference(){
        cube([r, r, h]);
        translate([r,r,-.1])cylinder(r=r, h=h+.1, $fn=90);
    }
}


difference(){
    cube([Base_Width, Base_Depth, Height]);
    // Bevel the front edge
    translate([-1,Slot_Width*(-1),0])rotate([Angle*(-1),0,0])cube([Base_Width+2,Slot_Width,Height+10]);
    // Remove the tablet slot
    translate([-1,Lip_Thickness,Slot_Rise])rotate([Angle*(-1),0,0])cube([Base_Width+2,Slot_Width,Height]);
    // Taper the back half
    translate([0,Base_Depth/4,Height])rotate([Back_Bevel,0,0])cube([Base_Width, Base_Depth, Height*2]);
    // Taper the left side
    translate([0,Base_Depth/4,-1])rotate([0,0,80])cube([Base_Depth, Base_Depth/2, Height+2]);
    // Taper the right side
    translate([Base_Width,Base_Depth/4,-01])rotate([0,0,10])cube([Base_Depth/2, Base_Depth, Height+2]);
    // Round front bottom
    translate([-1,0,-.1])rotate([90,0,90])fillet(r=2,h=Base_Width+2);
    // Round left straight
    translate([-.1,0,-.1])rotate([0,-90,-90])fillet(r=2,h=Base_Depth+2);
    // Round right straight
    translate([Base_Width+.1,0,-.1])rotate([90,0,180])fillet(r=2,h=Base_Depth+.2);
    // Round left side bottom
    translate([-.1,Base_Depth/4,-.1])rotate([-10,-90,-90])fillet(r=2,h=Base_Width);
    // Round right side bottom
    translate([Base_Width+.1,Base_Depth/4,-.1])rotate([-90,180,10])fillet(r=2,h=Base_Width);
    // Round back bottom
    translate([.1,Base_Depth+.1,-.1])rotate([0,-90,180])fillet(r=2,h=Base_Width);
    // Round front left
    translate([-.1,0,0,])rotate([Angle*(-1),0,0])fillet(r=5, h=Height+2);
    // Round front right
    translate([Base_Width+.1,0,0])rotate([Angle*(-1),0,0])rotate([0,0,90])fillet(r=5, h=Height+2);
    // Round slot front left
    translate([-.01,Lip_Thickness+.1,Slot_Rise])rotate([Angle*(-1),0,0])rotate([0,0,-90])fillet(r=2, h=Height+1);
    // Round slot front right
    translate([Base_Width+.01,Lip_Thickness+.1,Slot_Rise])rotate([Angle*(-1),0,0])rotate([0,0,180])fillet(r=2, h=Height+1);
    // Round slot back left
    translate([-.01,Lip_Thickness+Slot_Width-.4,Slot_Rise-(tan(Angle)*Slot_Width)])rotate([Angle*(-1),0,0])fillet(r=2, h=Height+1);
    // Round slot back right
    translate([Base_Width+.1,Lip_Thickness+Slot_Width-.4,Slot_Rise-(tan(Angle)*Slot_Width)])rotate([Angle*(-1),0,0])rotate([0,0,90])fillet(r=2, h=Height+1);
}
//translate([-.01,Lip_Thickness+Slot_Width-(),Slot_Rise-(tan(Angle)*Slot_Width)])rotate([Angle*(-1),0,0])fillet(r=2, h=Height+1);


