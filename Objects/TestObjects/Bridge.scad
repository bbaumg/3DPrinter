Height = 7;
Width = 30;
Depth = 20;
Tower = 5;
Bridge = 1;

difference(){
    cube([Width,Depth,Height]);
    translate([Tower,-.1,-.1])cube([Width-(2*Tower),Depth+.2,Height-Bridge]);
}