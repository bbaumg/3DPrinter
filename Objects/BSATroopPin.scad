
textDepth = .4;
textSize = 12;
textLine1 = "447";
textUpOffset = 2.5;
textFont = "Stencil";
fleurdlieHeight = .8;


color("green") linear_extrude(height=fleurdlieHeight) 
	import("/home/barrett/Downloads/bsa_logo_clipart_black_50.svg", center=true);
translate([0,textUpOffset,fleurdlieHeight]) color("yellow") linear_extrude(textDepth) text(str(textLine1), size = textSize, halign="center", valign="center", font=textFont);