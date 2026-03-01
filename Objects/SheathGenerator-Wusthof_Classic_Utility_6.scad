/*
	CREDIT:		https://makerworld.com/en/models/1313394-parametric-knife-sheath-blade-guard-custom-fit#profileId-1616204
	
	Purpose:    Create parametric generated knife sheaths.
	Knife:      This file will specifically fit:  Wusthof Ikon Chefs 8"
	GitHub:		
	
	History:	
		02/22/2026	Initial copy of origional...

	Notes:
		- Origional code on MakerWorld:  https://makerworld.com/en/models/1313394-parametric-knife-sheath-blade-guard-custom-fit#profileId-1616204
		- Cloned so each knife that I create can be named and saved.
*/


// Parametric Knife Sheath / Blade Guard
// Generated based on blade dimensions and Cubic Bezier curve parameters.

// --- Parameter Definition ---


blade_length = 157;      // Length of the blade section to be covered
blade_tip_offset = -5; // Y-coordinate of the tip (relative to center Y=0)
blade_width_start = 26;  // Blade width at the sheath opening (handle end)
blade_thickness_edge = .6; // NEW: Blade thickness near the cutting edge [mm] (Defines INNER cavity)
blade_thickness_spine = 1.5; // NEW: Blade thickness near the spine [mm] (Defines INNER cavity)

// Spine Control Points
spine_point_1_x = 0;
spine_point_2_x = 135;
spine_point_2_y = 2;  // Positive for spine side from center

// Edge Control Points
edge_point_1_x = 100;
edge_point_2_x = 140;
edge_point_2_y = 12; // Negative for edge side from center

wall_thickness = 1.5;      // Desired wall thickness of the sheath [mm]
clearance = 0.2;         // Space (air gap) between blade and inner wall [mm]

drainage_hole_diameter = 8;       // Diameter of drainage holes [mm]

drainage_hole_spacing = 25; // MODIFIED: Default spacing [mm] between hole centers ALONG THE CENTERLINE PATH. Increased default for clarity.

spine_open = false; // [true, false] Set to true to remove the spine wall

drainage_holes = true;       // [true, false] Set to true to add drainage holes
// Edge Rounding !!changes wall thickness & takes long to compute!!
apply_rounding = false; // [true, false] Apply rounding (fixed radius 2mm) to outer edges?
// WARNING: Enabling rounding (apply_rounding = true) uses minkowski() and WILL INCREASE wall thickness at the rounded edges!

// --- Internal Calculations & Helper Variables ---

// Calculate the varying Z-thickness for the INNER CAVITY
cavity_thickness_at_edge = blade_thickness_edge + 2 * clearance;
cavity_thickness_at_spine = blade_thickness_spine + 2 * clearance;

// Calculate the varying Z-thickness for the OUTER SHELL
outer_thickness_at_edge = blade_thickness_edge + 2 * clearance + 2 * wall_thickness;
outer_thickness_at_spine = blade_thickness_spine + 2 * clearance + 2 * wall_thickness;

// Calculate the MAXIMUM possible overall thickness for helper volumes/extrusions
max_overall_thickness = max(outer_thickness_at_edge, outer_thickness_at_spine);

// --- MODIFIED HELPER VOLUME CALCS based on apply_rounding ---
_rounding_radius_effective = apply_rounding ? 2 : 0; // Effective radius (2 if true, 0 if false) - MATCHED TO SPHERE RADIUS

// Height for extrusions before intersection (needs to be >= max_overall_thickness + rounding)
extrusion_height = max_overall_thickness + 2 * _rounding_radius_effective + 10; // Add margin and account for rounding

// Define Bezier curve points (using blade_width_start for initial Y placement)
P0_edge = [0, -blade_width_start / 2];
P0_spine = [0, blade_width_start / 2];
P3_tip = [blade_length, blade_tip_offset]; // This is the target point for drainage holes
C1_edge = [edge_point_1_x, P0_edge[1]];
C1_spine = [spine_point_1_x, P0_spine[1]];
C2_edge = [edge_point_2_x, - edge_point_2_y];
C2_spine = [spine_point_2_x, spine_point_2_y];


// --- Helper Functions ---
function bezier_point_cubic(p0, c1, c2, p3, t) = pow(1-t,3)*p0 + 3*pow(1-t,2)*t*c1 + 3*(1-t)*pow(t,2)*c2 + pow(t,3)*p3;
function reverse(list) = [for (i = [len(list)-1:-1:0]) list[i]];

function get_total_length_recursive(the_path_points, max_segment_idx, current_idx, current_len) =
    (current_idx >= max_segment_idx) ? current_len :
    get_total_length_recursive( the_path_points, max_segment_idx, current_idx + 1, current_len + norm(the_path_points[current_idx+1] - the_path_points[current_idx]) );


// --- Recursive Module to Place Holes (Defined Globally) ---
module place_holes_recursive(
    the_path_points, num_path_segments, max_hole_placement_distance, // Path data
    segment_index, current_cumulative_length, target_hole_distance, hole_counter, // Recursion state
    the_spacing, the_drainage_hole_diameter, the_hole_cylinder_height // Hole parameters
) {
    // --- Base Case: Stop recursion ---
    if (segment_index >= num_path_segments || target_hole_distance > max_hole_placement_distance + 1e-6) {
         echo(str("  Recursive search finished. Placed ", hole_counter, " holes."));
    } else {
        // --- Recursive Step ---
        p_start = the_path_points[segment_index];
        p_end = the_path_points[segment_index+1];
        segment_vector = p_end - p_start;
        segment_length = norm(segment_vector);
        segment_end_cumulative_length = current_cumulative_length + segment_length;

        can_place_in_segment =
            segment_length > 1e-6 &&
            target_hole_distance >= current_cumulative_length - 1e-6 &&
            target_hole_distance < segment_end_cumulative_length &&
            target_hole_distance <= max_hole_placement_distance + 1e-6;

        if (can_place_in_segment) {
            // Placement Condition Met
            distance_into_segment = target_hole_distance - current_cumulative_length;
            t_segment = (segment_length < 1e-9) ? 0 : distance_into_segment / segment_length;
            hole_pos_xy = p_start + t_segment * segment_vector;

            translate([hole_pos_xy[0], hole_pos_xy[1], 0])
                cylinder(d=the_drainage_hole_diameter, h=the_hole_cylinder_height, center=true, $fn=32);
             echo(str("      -> Placed hole ", hole_counter + 1, " at distance ~", target_hole_distance));

            // Recurse for the next hole, starting from the current segment index
            place_holes_recursive(
                the_path_points, num_path_segments, max_hole_placement_distance, // Path data
                segment_index, current_cumulative_length, target_hole_distance + the_spacing, hole_counter + 1, // State
                the_spacing, the_drainage_hole_diameter, the_hole_cylinder_height // Hole params
            );
        } else {
            // Placement Condition Not Met
            // Move to the next segment, keeping the same target distance.
            place_holes_recursive(
                the_path_points, num_path_segments, max_hole_placement_distance, // Path data
                segment_index + 1, segment_end_cumulative_length, target_hole_distance, hole_counter, // State
                the_spacing, the_drainage_hole_diameter, the_hole_cylinder_height // Hole params
            );
        }
    }
} // End of place_holes_recursive module definition


// --- Point Generation for Blade Profile ---
fixed_number_of_segments = 100;
edge_point_list = [ for (i = [0 : fixed_number_of_segments]) bezier_point_cubic(P0_edge, C1_edge, C2_edge, P3_tip, i/fixed_number_of_segments) ];
spine_point_list = [ for (i = [0 : fixed_number_of_segments]) bezier_point_cubic(P0_spine, C1_spine, C2_spine, P3_tip, i/fixed_number_of_segments) ];
blade_profile_points = concat(edge_point_list, reverse(spine_point_list));

// --- Centerline Calculation ---
centerline_point_list = [ for (i = [0 : fixed_number_of_segments]) (edge_point_list[i] + spine_point_list[i]) / 2 ];

// --- Global Profile Bounds Calculation ---
all_x_coords = [for (p = blade_profile_points) p[0]];
all_y_coords = [for (p = blade_profile_points) p[1]];
min_x_global = len(all_x_coords) > 0 ? min(all_x_coords) : -5;
max_x_global = len(all_x_coords) > 0 ? max(all_x_coords) : blade_length + 5;
min_y_global = len(all_y_coords) > 0 ? min(all_y_coords) : -blade_width_start/2 - 5;
max_y_global = len(all_y_coords) > 0 ? max(all_y_coords) : blade_width_start/2 + 5;


// --- 2D Geometry Modules ---
module blade_polygon_2d() { polygon(blade_profile_points); }
module inner_profile_2d() { offset(delta = clearance) blade_polygon_2d(); }
module outer_profile_2d() { offset(delta = wall_thickness) inner_profile_2d(); }


// --- 3D Geometry Modules ---

module spine_cutout_volume_3d() { /* ... definition remains the same ... */
    cut_min_x = min_x_global - 5; cut_max_x = max_x_global + 5; cut_width_x = cut_max_x - cut_min_x;
    cut_start_y = max_y_global - clearance / 2; cut_end_y = max_y_global + wall_thickness + 10 + _rounding_radius_effective;
    cut_height_y = cut_end_y - cut_start_y;
    cut_min_z = -(max_overall_thickness/2 + _rounding_radius_effective + 5);
    cut_depth_z = max_overall_thickness + 2 * _rounding_radius_effective + 10;
    translate([cut_min_x, cut_start_y, cut_min_z]) cube([cut_width_x, cut_height_y, cut_depth_z]);
 }
module final_form_block_3d() { /* ... definition remains the same ... */
    margin = 5;
    min_y_block = min_y_global - margin; max_y_block = max_y_global + margin; height_y_block = max_y_block - min_y_block;
    block_min_x = min_x_global - margin; block_max_x = max_x_global + margin; block_width_x = block_max_x - block_min_x;
    block_min_z = -(max_overall_thickness/2 + _rounding_radius_effective + margin);
    block_depth_z = max_overall_thickness + 2*_rounding_radius_effective + 2*margin;
    difference() {
        translate([block_min_x, min_y_block, block_min_z]) cube([block_width_x, height_y_block, block_depth_z]);
        opening_cut_start_x = block_min_x - 1; opening_cut_end_x = 0.01; opening_cut_width_x = opening_cut_end_x - opening_cut_start_x;
        translate([opening_cut_start_x, min_y_block, block_min_z]) cube([opening_cut_width_x, height_y_block, block_depth_z]);
    }
 }


// --- DRAINAGE HOLES MODULE (Now calls the global recursive module) ---
module drainage_holes_3d() {
    hole_cylinder_height = max_overall_thickness + 2 * _rounding_radius_effective + 2;
    spacing = drainage_hole_spacing;
    tip_buffer = max(spacing / 2, drainage_hole_diameter);
    path_points = centerline_point_list;
    num_path_segments = len(path_points) - 1;

    if (num_path_segments > 0) {
         echo("Generating drainage holes along CENTERLINE path (Recursive)...");
         echo(str("  Target spacing: ", spacing, ", Tip buffer: ", tip_buffer));

        total_path_length = get_total_length_recursive(path_points, num_path_segments, 0, 0);
         echo(str("  Calculated Total Centerline Path Length: ", total_path_length));

        max_hole_placement_distance = total_path_length - tip_buffer;
         echo(str("  Max hole placement distance (path length - buffer): ", max_hole_placement_distance));

        // Initial call to the GLOBAL recursive module
        if (total_path_length >= spacing && spacing <= max_hole_placement_distance + 1e-6) {
             place_holes_recursive(
                path_points, num_path_segments, max_hole_placement_distance, // Path data
                0, 0, spacing, 0, // Initial state
                spacing, drainage_hole_diameter, hole_cylinder_height // Hole params
             );
        } else {
             echo("  Total path length too short for specified spacing or buffer. No holes placed.");
        }
    } else {
         echo("  Centerline path has no segments, skipping holes.");
    }
} // End of drainage_holes_3d module


// Wedge volume generator - Remains the same
module wedge_volume_3d(len_x, min_y, max_y, thickness_at_min_y, thickness_at_max_y) { /* ... definition remains the same ... */
    p0=[0,min_y,-thickness_at_min_y/2]; p1=[len_x,min_y,-thickness_at_min_y/2]; p2=[len_x,max_y,-thickness_at_max_y/2]; p3=[0,max_y,-thickness_at_max_y/2];
    p4=[0,min_y,thickness_at_min_y/2]; p5=[len_x,min_y,thickness_at_min_y/2]; p6=[len_x,max_y,thickness_at_max_y/2]; p7=[0,max_y,thickness_at_max_y/2];
    polyhedron( points=[ p0,p1,p2,p3, p4,p5,p6,p7 ], faces=[ [0,1,2,3],[7,6,5,4],[0,4,5,1],[1,5,6,2],[2,6,7,3],[3,7,4,0] ]);
 }

// --- Intermediate Assembly Modules ---
module hollow_wedge_sheath() { /* ... definition remains the same ... */
    wedge_margin = 5;
    wedge_min_x = min_x_global - wedge_margin;
    wedge_max_x = max_x_global + wedge_margin;
    wedge_len_x = wedge_max_x - wedge_min_x;
    wedge_min_y = min_y_global - wedge_margin;
    wedge_max_y = max_y_global + wedge_margin;
    module outer_shell_base_volume() { intersection() { linear_extrude(height = extrusion_height, center = true) { outer_profile_2d(); } translate([wedge_min_x, 0, 0]) { wedge_volume_3d( wedge_len_x, wedge_min_y, wedge_max_y, outer_thickness_at_edge, outer_thickness_at_spine ); } } }
    module inner_cavity_subtraction_volume() { intersection() { linear_extrude(height = extrusion_height + 0.1, center = true) { inner_profile_2d(); } translate([wedge_min_x, 0, 0]) { wedge_volume_3d( wedge_len_x, wedge_min_y, wedge_max_y, cavity_thickness_at_edge, cavity_thickness_at_spine ); } } }
    difference() { if (apply_rounding) { echo(str("Applying Minkowski rounding with fixed radius: ", _rounding_radius_effective)); minkowski($fn=max(16, $fn/2)) { outer_shell_base_volume(); sphere(r = _rounding_radius_effective, $fn=max(8, $fn/4)); } } else { outer_shell_base_volume(); } inner_cavity_subtraction_volume(); }
}

module sheath_with_optional_features() { /* ... definition remains the same ... */
    echo("Applying optional features...");
    if (spine_open) { echo(" -> Applying open spine cut..."); difference() { if (drainage_holes) { echo("   -> Subtracting drainage holes (before spine cut)..."); difference() { hollow_wedge_sheath(); drainage_holes_3d(); } echo("   -> Holes subtracted."); } else { echo("   -> Drainage holes skipped (before spine cut)."); hollow_wedge_sheath(); } spine_cutout_volume_3d(); } echo(" -> Open spine cut applied."); } else { echo(" -> Closed spine (no cut)."); if (drainage_holes) { echo("   -> Subtracting drainage holes..."); difference() { hollow_wedge_sheath(); drainage_holes_3d(); } echo("   -> Holes subtracted."); } else { echo("   -> Drainage holes skipped."); hollow_wedge_sheath(); } }
}


// --- Final Assembly ---
$fn=64;
echo("INFO: Starting final assembly...");
echo("INFO: Rotating final assembly.");
rotate([0, -90, 0])
{
    echo("INFO: Applying final form block intersection.");
    intersection() {
        sheath_with_optional_features();
        final_form_block_3d();
    }
}
echo("INFO: Rendering complete.");