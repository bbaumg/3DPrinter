

startingHeight = .2;
startingWidth = 10;
boxThickness = 1;
boxSpacing = 65;
boxCount = 5;

for (i = [0 : boxCount-1] ){
    echo(i);
    thisWidth = startingWidth +(boxSpacing * i);

    difference(){
        cube([thisWidth, thisWidth, startingHeight], center=true);
        cube([thisWidth-boxThickness*2, thisWidth-boxThickness*2, startingHeight+2], center=true);
    }
}