// the point of this file is to be a sort of DSL for constructing keycaps.
// when you create a method chain you are just changing the parameters
// key.scad uses, it doesn't generate anything itself until the end. This
// lets it remain easy to use key.scad like before (except without key profiles)
// without having to rely on this file. Unfortunately that means setting tons of
// special variables, but that's a limitation of SCAD we have to work around

use <src/key.scad>

include <src/settings.scad>
include <src/key_sizes.scad>
include <src/key_profiles.scad>
include <src/key_types.scad>
include <src/key_transformations.scad>

// General printability for my printers
$has_brim = true;
$stem_slop = 0.4;
$support_type = "bars"; // ["flared", "flat", "bars", false]
$stem_throw = 5.0;

// Shape preferences
$key_bump_edge = 0.8;
$enable_more_side_sculpting = true;
$side_sculpting_factor = 5;
$corner_sculpting_factor = 1.5;
$more_side_sculpting_factor = 0.3;
regular_dish_depth = 1.3;
homing_dish_depth = 2.3;

module translate_u(x=0, y=0, z=0){
    translate([x * unit, y*unit, z*unit]) children();
}

module one_single_key(profile, row, unsculpted, u = 1) {
    key_profile(profile, unsculpted ? 3 : row) // If you want to change $dish_depth, it needs to come below here
        render()
        cherry($dish_depth = regular_dish_depth)
        u(u)
        key();
}

module one_row_profile(profile, unsculpted = false, u = 1) {
    rowscols = [[1, 2, 3, 4, 3]];
    for(col = [0:len(rowscols)-1]) {
        rows = rowscols[col];
        for(row = [0:len(rows)-1]) {
            translate_u(u*col+row*0.0, -row) one_single_key(profile, rows[row], unsculpted, u);
        }
    }
}

// One set of all the key types needed for a redox
translate_u(-1, 1) key_profile("sa", 3) render() bump() cherry($dish_depth = regular_dish_depth) key();
translate_u(-1, 2) key_profile("sa", 3) render() cherry($dish_depth = homing_dish_depth) key();
translate_u(0, 3) one_row_profile("sa", u = 1);
translate_u(1.125, 3) one_row_profile("sa", u = 1.25);
translate_u(2.5, 3) one_row_profile("sa", u = 1.5);
translate_u(3.75, -0.75) key_profile("sa", 3) render() cherry($dish_depth = regular_dish_depth) 1_5uh() key();
translate_u(3.75, 1) key_profile("sa", 2) render() cherry($dish_depth = regular_dish_depth) 1_5uh() key();
translate_u(3.75, 2.5) key_profile("sa", 1) render() cherry($dish_depth = regular_dish_depth) 1_5uh() key();
