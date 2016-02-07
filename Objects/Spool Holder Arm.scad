


Height = 120;           //How tall should it be?
Width = 20;             //How wide should it be (when looking at it mounted on the frame)?
Hole_Diamater = 9;      //How wide should the hole be?
Frame_Thickness = 8;    //How thick is the printer frame?
Frame_Height = 47;     //Giw tall is the printer frame?
Fram_Wall_Thickness = 5;  //  How thick should the part be around the frame?

Thickness = Fram_Wall_Thickness+Frame_Thickness+Fram_Wall_Thickness;
Screw_Clearance = 5;
Screw_Gap = 3;
Screw_Diamater = 1;
Primary_Height = Height-(Thickness/2)+Frame_Height+Screw_Clearance;



difference(){
    //  The primary frame with a cylinder at the top to round it off
    union(){
        translate([Thickness/2*(-1),0,0])cube([Thickness,Primary_Height,Width]);
        translate([0,Primary_Height,0])cylinder(d=Thickness,h=Width);
    }
    //  Remove the main slot for the frame
    translate([Frame_Thickness/2*(-1),Screw_Clearance,-1])cube([Frame_Thickness,Frame_Height,Width+2]);
    //  Remove the small gap at bottom for the screw mounts.
    translate([Screw_Gap/2*(-1),-1,-1])cube([Screw_Gap,Screw_Clearance+2,Width+2]);
    //  Remove the hole at the top the threaded rod goes through
    translate([0,Primary_Height,-1])cylinder(d=Hole_Diamater,h=Width+2);
    //  Remove the screw hole
    if(Width > 2 ) {
        rotate([0,90,0])translate([Width/2*(-1),Screw_Clearance/2,Thickness/2*(-1)-1])cylinder(d=Screw_Diamater, h=Thickness+2);
        rotate([0,90,0])translate([Width/2*(-1),Screw_Clearance/2,Thickness/2*(-1)-1])cylinder(d=Screw_Diamater+1, h=Thickness/2);
    }
}
