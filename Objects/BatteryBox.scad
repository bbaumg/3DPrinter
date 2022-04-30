largeLength = 80;
largewidth = 94;
smallLength = 148;
smallWidth = 29;
height = 1;


cube([largeLength,largewidth, height]);
translate([largeLength,0,0]) cube([smallLength, smallWidth, height]);