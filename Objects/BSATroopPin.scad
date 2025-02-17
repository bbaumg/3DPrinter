
textDepth = .7;
textSize = 12;
textLine1 = "447";
textUpOffset = 2.5;		// How far up to move font from centered
textFont = "Stencil";
fleurdlieHeight = 1.4;

color("green") linear_extrude(height=fleurdlieHeight) 
	import("/home/barrett/Downloads/bsa_logo_clipart_black_50.svg", center=true);
translate([0,textUpOffset,fleurdlieHeight]) color("yellow") linear_extrude(textDepth) text(str(textLine1), size = textSize, halign="center", valign="center", font=textFont);