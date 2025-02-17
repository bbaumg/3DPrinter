// Main product thanks to https://www.thingiverse.com/thing:1394486
//   Added comments and made some tweaks.

$fn=120;

// Deck dimensions
cx=61.0;
cy=18;
cz=88.5;

// Case thickness
dx=2;
dy=2;
dz=2;

// Top/bottom ratio (should equal 100%)
zp1=0.60;
zp2=0.40;

// Dimensions of the lip that connects the parts together
dxlip=1.2;
dylip=1.2;
dzlip=15.0;

// Tolerance spacing between parts that connect together
tol=0.1;

// Rounded edge radius
radius = 1;

module card_box_end()
{
    rounded_rect([cx + dx * 2, cy + dy * 2, dz]);
}

module card_box_middle_bottom()
{
    difference()
    {
        rounded_rect([cx + dx * 2, cy + dy * 2, cz * zp1]);
        
        translate([dx, dy, 0])
        cube([cx, cy, cz]);
    }
}

module card_box_middle_top()
{
    difference()
    {
        rounded_rect([cx + dx * 2, cy + dy * 2, cz * zp2]);
        
        translate([dx, dy, 0])
        cube([cx, cy, cz]);
        
        translate([0, 0, cz * zp2 - dzlip - tol])
        card_box_top_lip();
    }
}
module card_box_bottom_lip()
{
    translate([dx - dxlip, dy - dylip, 0])
    difference()
    {
        translate([tol, tol, 0])
        cube([cx + dxlip * 2 - tol * 2, cy + dylip * 2 - tol * 2, dzlip - tol]);
        
        translate([dxlip, dylip, 0])
        cube([cx, cy, dzlip]);
    }
}

module card_box_top_lip()
{
    translate([dx - dxlip, dy - dylip, 0])
    cube([cx + dxlip * 2, cy + dylip * 2, dzlip + tol]);
}

module card_box_bottom()
{
    card_box_end();

    translate([0, 0, dz])
    card_box_middle_bottom();
    
    translate([0, 0, dz + cz * zp1])
    card_box_bottom_lip();   
}

module card_box_top()
{
    card_box_end();

    translate([0, 0, dz])
    card_box_middle_top();
}

module rounded_rect(size, radius=radius)
{
	x = size[0];
	y = size[1];
	z = size[2];
	
	hull()
	{
		translate([radius, radius, 0])
		cylinder(r=radius,h=z);
		
		translate([x-radius, radius, 0])
		cylinder(r=radius,h=z);
		
		translate([x-radius, y-radius, 0])
		cylinder(r=radius,h=z);
		
		translate([radius, y-radius, 0])
		cylinder(r=radius,h=z);
	}
}

module card_box_print()
{
    translate([0, (cy + dy) * 2, 0])
    card_box_bottom();

    card_box_top();
}

module card_box_exploded()
{
    card_box_bottom();

    translate([0, 0, dzlip * 10])
    translate([0, cy + dy * 2, cz + dz])
    rotate([180,0,0])
    card_box_top();
}

//card_box_end();

//card_box_bottom();
//card_box_top();

//card_box_exploded();

card_box_print();

