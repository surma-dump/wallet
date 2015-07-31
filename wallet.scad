// Flags
enable_cutout = true;
enable_clip = true;

// ISO/IEC 7810 ID-1 card measurements
id1_width = 85.60;
id1_height = 53.98;
// Additional margins on the side for hooks
margin = 7;
// Diameter of cutout
cutout_d = id1_height/2;
// Additional offset towards center of cutout
cutout_offset = 5;
// Rounded corners 
radius_rounded_corners = 1;

// Gap size of hooks
hook_gap = 4;
// Length of a hook (incl. gap)
hook_length = 50;
// Width of stem of hook
hook_stem = hook_length - 4*hook_gap;
// Number of hooks per side
hook_per_side = 1;

// Money clip
clip_width = 40;
clip_height = 30;
clip_gap = 1;
// Diameter of holes of clip
clip_hole_d = 3;

// Here be dragons
$fn = 50;
full_height = id1_height+2*margin;
full_width = id1_width;
cutout_d_pre = cutout_d+2*radius_rounded_corners;
hook_margin = (full_width - hook_per_side*hook_length)/(hook_per_side+1);

module card() {
    difference() {
        square([full_width, full_height]);
        if(enable_cutout)
            translate([full_width-cutout_offset, full_height/2, 0])
                union() {
                    circle(d=cutout_d);
                    translate([0, -cutout_d/2])
                        square([cutout_offset, cutout_d]);
                }
    }
}

module round_corners(r=1) {
    offset(r=r)
        offset(delta=-r)
            children();
}

module hook() {
    difference() {
        union() {
            translate([0, margin-hook_gap])
                square([hook_length, hook_gap]);
            square([hook_gap, margin]);
            translate([hook_length-hook_gap, 0])
                square([hook_gap, margin]);
        }
        translate([(hook_length-hook_stem)/2, margin-hook_gap])
            square([hook_stem, hook_gap]);
    }
}

module copy_mirror(vec=[0,1,0]) { 
    children(); 
    mirror(vec)
        children();
} 

module clip() {
    union() {
        copy_mirror([0, 1, 0])
            translate([0, clip_height/2])
                union() {
                    translate([0, -clip_gap/2]) 
                        square([clip_width, clip_gap]);
                    circle(d=clip_hole_d);
                }
        translate([clip_width-clip_gap, -clip_height/2])
            square([clip_gap, clip_height]);
    }
}

round_corners(r=radius_rounded_corners)
    difference() {
        card();
        for(i = [0:hook_per_side-1])
            translate([hook_margin+i*(hook_length+hook_margin), 0, 0])
                hook();
        for(i = [0:hook_per_side-1])
            translate([hook_margin+i*(hook_length+hook_margin), full_height, 0])
                mirror([0, 1, 0])
                    hook();
        if(enable_clip)
            translate([(full_width-clip_width-cutout_d/2-cutout_offset)/2, full_height/2])
                clip();
    }
