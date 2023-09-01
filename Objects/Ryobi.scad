

Margin = 1.01; //percentage of margin in the opening
fn = 100;
rnd = .01; //small amount to fix rounding errors
Delta = .01;

//other dimensions
RS = 4; //small radius  (inner DIM)
RL = 14.1*Margin; //large end radius (inner DIM)
W = RL*2;//width equals the large circule diamter I.E. 2*R (inner DIM)
L = 33.25*Margin;//length (inner DIM)
H = 49;//height (inner DIM)
THK = 2;//was 1.5 material thickness

//keying on bottom of battery base
KEY_W = 3.5;//width of key 
KEY_H = 10;//height of key
KEY_OS = 1.3;//key offset

//Electrical connection holes
EC = 8; //8x 8 mm is the correct hole size (for access)
EC_OS = 29.5;//offset from base to electrical connections
EC_PM = 12;//offsetfor the + and - electrical connections


difference(){
	body();
	// Remove the key slot in the base
	translate([-KEY_W-KEY_OS,-1.5*THK,Delta+(H+THK)/2-KEY_H])cube([KEY_W,2*THK,KEY_H]);
	//create hole for front electrical connection
	translate([0,0,((H+THK)/2-EC/2)-EC_OS])
	cube([EC, 4*THK, EC], center = true);
	//create hole for the + and - electrical connections
	translate([0,EC_PM,((H+THK)/2-EC/2)-EC_OS])
	cube([2*W, EC, EC], center = true);

}



/////////////////////////////////////////////////////
// create the entire body
/////////////////////////////////////////////////////
module body()
{
		union() 
		{
			//left (from top) small radius
			translate([-((W/2)-RS),RS,0])
			rotate([0,0,90])
			corner();
			//right (from top) small radius
			translate([((W/2)-RS),RS,0])
			rotate([0,0,180])
			corner();
			//the wall between the corners
			translate([0,-THK/2,0])
			cube([W-2*RS+rnd, THK, H+THK], center = true);
			//with the floor
			translate([0,((RS+THK)/2)-THK,-H/2])
			cube([W-2*RS+rnd, RS+THK, THK], center = true);
			//the left wall
			translate([-(W/2+THK/2),RS+((L-RS-RL)/2),0])
			cube([THK, rnd+(L-RS-RL), H+THK], center = true);
			//the right wall
			translate([(W/2+THK/2),RS+((L-RS-RL)/2),0])
			cube([THK, rnd+(L-RS-RL), H+THK], center = true);
			//the floor
			translate([0,RS+((L-RS-RL)/2),-H/2])
			cube([W, rnd+(L-RS-RL), THK], center = true);
			//the end
			translate([0,L-RL,0])
			rotate([0,0,-90])
			end();
		}//end of union
}

/////////////////////////////////////////////////////
//  Create the corner shell including the "Floor"
/////////////////////////////////////////////////////
module corner()
{
	difference ()
	{
		//the outer cylinder is the part we keep
		cylinder(H+THK, RS+THK, RS+THK, $fn=fn, center = true);
		//remove the inner circle to form the shell
		translate([0,0,Delta+THK/2])
		cylinder(H, RS, RS, $fn=fn, center = true);
		//now remove 25% of the circle (one corner)
		translate([-RS,-RS,0])
		cube([2*RS+Delta,2*RS, H+THK+2*Delta], center = true);
		//now remove 50% of the circle (one corner)
		translate([RS,0,0])
		cube([2*RS,4*RS, H+THK+2*Delta], center = true);
	}//end of differnce
}

/////////////////////////////////////////////////////
//  Create the wall shell including the "Floor"
/////////////////////////////////////////////////////
module end()
{
	difference ()
	{
		//the outer cylinder is the part we keep
		cylinder(H+THK, RL+THK, RL+THK, $fn=fn, center = true);
		//remove the inner circle to form the shell
		translate([0,0,Delta+THK/2])
		cylinder(H, RL, RL, $fn=fn, center = true);
		//now remove 50% of the circle (one corner)
		translate([RL,0,0])
		cube([2*RL,4*RL, H+THK+2*Delta], center = true);
	}//end of differnce
}
