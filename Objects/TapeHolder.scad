/*
 * Holder for tape rolls or similar spooled objects.  
 * Default settings will hold a role of Leukotape P
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * See <http://www.gnu.org/licenses/>.
 *
 * Relies on module from revarbat / BOSL 
 *  https://github.com/revarbat/BOSL
*/


include <../BOSL/threading.scad>

////////////////////////////////////////////////////////////////////////
//  Variables
////////////////////////////////////////////////////////////////////////

outerDiamater = 77;
innerDiamater = 24.5;
innerThickness = 5;
outerHeight = 41;
lidHeight = 5;
lidSpace = .5;
wallThickness = 1;
threadSets = 3;
threadPitch = 5;
smoothness = 180;		// 20 while testing 180 for final

// Enable or disable the objectd parts
translate([outerDiamater/1.9,0,0]) objBody();  //Body
translate([-outerDiamater/1.9,0,0]) objLid();		//Lid

////////////////////////////////////////////////////////////////////////
//  Start Program
////////////////////////////////////////////////////////////////////////

$fn=smoothness;
// Bottom

module objBody(){
	difference(){
			// Combine bottom and inner shaft as one
			union(){
					// Bottom
					cylinder(d=outerDiamater, h=wallThickness);
					// Inner shaft
					cylinder(d=innerDiamater, h=outerHeight);
					// Outer Side
					translate([0,0,0])
					difference(){
							cylinder(d=outerDiamater, h=outerHeight);
							cylinder(d=outerDiamater-(wallThickness*2), h=outerHeight+.1);
					}
			}
			// Remove the inner threads
			translate([0,0,-1])
				#trapezoidal_threaded_rod(
						d=innerDiamater-innerThickness, 
						l=outerHeight+2, pitch=threadPitch, thread_angle=30, 
						starts=threadSets, align=V_TOP, internal=true);
			
			// Bottom Rounding
			pad = 0.1;	// Padding to maintain manifold
			r = 1;      // Radius of the curve 1 is a good soft number
			translate([0,0,0])
					difference() {
							#rotate_extrude(convexity=10,  $fn = smoothness)
									translate([outerDiamater/2-r+pad,-pad,0])
											square(r+pad,r+pad);
							rotate_extrude(convexity=10,  $fn = smoothness)
									translate([outerDiamater/2-r,r,0])
											circle(r=r,$fn=smoothness);
					}
	}
}

// Lid
module objLid(){
	difference(){
		// Combine bottom and inner shaft as one
		union(){
			// Bottom
			cylinder(d=outerDiamater+wallThickness*2+lidSpace, h=wallThickness);
			// Inner shaft with threads
			trapezoidal_threaded_rod(
					d=innerDiamater-innerThickness, 
					l=outerHeight/4, pitch=threadPitch, thread_angle=30, 
					starts=threadSets, align=V_TOP, bevel2=true);
			// Outer Side
			translate([0,0,0])
			difference(){
					cylinder(d=outerDiamater+wallThickness*2+lidSpace, h=lidHeight);
					cylinder(d=outerDiamater+lidSpace, h=lidHeight+.1);
			}
		}
		
		// Bottom Rounding
		pad = 0.1;	// Padding to maintain manifold
		r = 1;      // Radius of the curve 1 is a good soft number
		translate([0,0,0])
		difference() {
				#rotate_extrude(convexity=10,  $fn = smoothness)
						translate([outerDiamater/2+wallThickness+lidSpace-r+pad,-pad,0])
								square(r+pad,r+pad);
				rotate_extrude(convexity=10,  $fn = smoothness)
						translate([outerDiamater/2+wallThickness+lidSpace-r,r,0])
								circle(r=r,$fn=smoothness);
		}
	}
}
