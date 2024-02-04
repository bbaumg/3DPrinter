bedWidth = 300;
bedDepth = 300;
maxSpace = 10;
squareSpacing = 10;
lineWidth = .4;

// Calculations
squares = floor((bedWidth - maxSpace)/squareSpacing);
cubeDifference = lineWidth*2;

for (y=[1:squares]){
	difference(){
		cube([y*squareSpacing,y*squareSpacing,.2], center=true);
		cube([y*squareSpacing-cubeDifference,y*squareSpacing-cubeDifference,.2], center=true);
	}
}
