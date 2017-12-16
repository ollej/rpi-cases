$fn=120;

//Base thickness
THICKNESS_BASE = 3;
//Wall thickness
THICKNESS_WALL = THICKNESS_BASE;

// Case dimensions
// FIX wider, sd card
CASE_W = 72;
CASE_H = 35;

// Pi Zero dimensions
PI_W = 65;
PI_H = 30;
PI_PCB_H = 1.5;

// Header dimensions
HEADER_W = 54;
HEADER_H = 7;

// Height of mount holes from inner bottom of box
MOUNT_HEIGHT = 10;

// Latch dimensions
LATCH_WIDTH = 10;
LATCH_THICKNESS = 2;
LATCH_HEIGHT = 5;

//CASE_HEIGHT = 39;
CASE_HEIGHT = THICKNESS_BASE + MOUNT_HEIGHT + 32.5 - 3.2 - 2;
// PI + phats = 32.4
// TOP PCB = 1.7 (3.1 with electronics)
// CH = B + M + PI - TOP - 2 (adjustment)

LID_DISTANCE = 2;
LID_REDUCTION_W = 0.4;
LID_REDUCTION_H = 0.3;

module rectangle_rounded(x, y, rad=1) {
	minkowski() {
		circle(r=rad);
		square([(x - 2 * rad), (y - 2 * rad)], true);
	}
}

module header(x, y) {
    translate([x, y, 0]) {
        rectangle_rounded(HEADER_W, HEADER_H);
    }
}

module hole(x, y, d=2.75, hex=false) {
    translate([x, y, 0]) {
        if (hex == true) {
            rotate([0, 0, 90]) circle(d=d, center=true, $fn=6);
        } else {
            circle(d=d, center=true);
        }
    }    
}

module corner_holes(w=75, h=40, hole_pos=3.5, d=2.75, hex=false) {
    hole((w/2) - hole_pos, (h/2) - hole_pos, d, hex);
    hole((w/2) - hole_pos, 0 - (h/2) + hole_pos, d, hex);
    hole(0 - (w/2) + hole_pos, (h/2) - hole_pos, d, hex);
    hole(0 - (w/2) + hole_pos, 0 - (h/2) + hole_pos, d, hex);
}

module m25mount (x,y,z,dia,height) {
	translate([x,y,z]) {
		linear_extrude(height) {
			difference() {
				circle(d=dia);
				circle(d=3.1);
			}
		}
	}
}

module connector_hole(x_offset, z_offset, width, height, invert=false) {
    x_pos = invert ? 0 - PI_W / 2 + x_offset : PI_W / 2 - x_offset;
    y_pos = CASE_H / 2 + THICKNESS_WALL / 2;
    z_pos = z_offset + MOUNT_HEIGHT + THICKNESS_BASE + height / 2;

    translate([x_pos, y_pos, z_pos]) {
        cube([width, THICKNESS_WALL, height], center=true);
    }
}

module side_hole(x_offset, z_offset, width, height, invert=false) {
    x_pos = invert ? 0 - PI_H / 2 + x_offset : PI_H / 2 - x_offset - width/2;
    y_pos = CASE_W / 2 + THICKNESS_WALL / 2;
    z_pos = z_offset + MOUNT_HEIGHT + THICKNESS_BASE + height / 2;

    translate([x_pos, y_pos, z_pos]) {
        cube([width, THICKNESS_WALL, height], center=true);
    }
}
// 12, 15, 5 offset
module power_sd()  {
    rotate([0,0,270])
        side_hole(x_offset=5, z_offset=0, width=15, height=12);
}

//18.2, 11.3
module hdmi_port() {
    // connector size: 11.3x3.3mm
    connector_hole(x_offset=12.5, z_offset=0, width=14, height=6);
}

module usb_power() {
    // connector size: 8x2.8mm
    connector_hole(x_offset=11, z_offset=0, width=10, height=5, invert=true);
}

module usb_otg() {
    // connector size: 8x2.8mm
    connector_hole(x_offset=23.5, z_offset=0, width=10, height=5, invert=true);
}

module temp_sensor() {
    connector_hole(x_offset=13, z_offset=17.5, width=5, height=3);
}

module light_sensor() {
    // 17.5mm + MOUNT_HEIGHT + THICKNESS_BASE
    // width = 11,5mm
    connector_hole(x_offset=PI_W/2, z_offset=17.5, width=12, height=3);
}

// Box
module picase_box() {
    // Define baseplate
    linear_extrude(THICKNESS_BASE) {
        minkowski() {
            circle(THICKNESS_WALL);
            rectangle_rounded(CASE_W, CASE_H, 3);
        }
    }

    difference() {
        //i Define wall
        translate([0,0,THICKNESS_BASE]) {
            // 33mm height, 3mm for mounting holes + 3 mm for lid + 5 mm extra for battery
            // 10 mm (mounting holes/battery) + 29 mm (pi0 + hats)
            linear_extrude(CASE_HEIGHT - THICKNESS_BASE) {	
                difference() {
                    minkowski() {
                        circle(THICKNESS_WALL);
                        rectangle_rounded(CASE_W, CASE_H, 3);
                    }
                    rectangle_rounded(CASE_W, CASE_H, 3);
                }
            }
        }

        // Additional holes
        light_sensor();
        temp_sensor();
        usb_power();
        usb_otg();
        hdmi_port();
        power_sd();
        
        // Latch holes
        latch_holes();
    }

    // Mount holes, M2.5, no thread
    //3 mm height originally
    //(+5 mm added for battery space)
    //(+ 2mm for gpio pins)
    m25mount(58/2, 23/2, THICKNESS_BASE, 5, MOUNT_HEIGHT);
    m25mount(58/2, -23/2, THICKNESS_BASE, 5, MOUNT_HEIGHT);
    m25mount(-58/2, -23/2, THICKNESS_BASE, 5, MOUNT_HEIGHT);
    m25mount(-58/2, 23/2, THICKNESS_BASE, 5, MOUNT_HEIGHT);
    
}

// Lid
module picase_lid() {
    difference() {
        union() {
            // Lid top
            linear_extrude(THICKNESS_BASE) {
                minkowski() {
                    circle(THICKNESS_WALL);
                    rectangle_rounded(CASE_W, CASE_H, 3);
                }
            }
            // Lid inner extrusion
            linear_extrude(2 * THICKNESS_BASE) {
                rectangle_rounded(CASE_W - LID_REDUCTION_W * 2, CASE_H - LID_REDUCTION_H * 2, 3);
            }
            
            // Latches
            latches(2 * THICKNESS_BASE, LID_REDUCTION_W);
        }

        // Lid holes
        translate([0,0,-1]) {
            linear_extrude(2 * THICKNESS_BASE + 2) {
                header(0, PI_H/2 - HEADER_H/2);
                corner_holes(PI_W, PI_H, d=5.6, hex=false);
                translate([0,-4.5,0]) {
                    rectangle_rounded(50, 21);
                }
            }
        }
    }
}

// z_offset = Z offset to place base of latch
// reduction = Distance to move latch in to center 
module latches(z_offset=0, reduction=0) {
    translate([CASE_W/2 - LATCH_THICKNESS/2 - reduction, 0, z_offset])
        latch();
    translate([0 - CASE_W/2 + LATCH_THICKNESS/2 + reduction, 0, z_offset])
        rotate([0, 0, 180])
            latch();
}

module latch_holes() {
    translate([0, 0, CASE_HEIGHT])
        rotate([180, 0, 0]) latches(0);
}

module latch() {
    linear_extrude(LATCH_HEIGHT)
        square([LATCH_THICKNESS, LATCH_WIDTH], center=true);
    
    // Cylinder lock
    translate([LATCH_THICKNESS/2, LATCH_WIDTH/2, LATCH_HEIGHT - LATCH_THICKNESS/2])
        rotate([90, 0, 0])
            scale([0.5, 1, 1])
                linear_extrude(LATCH_WIDTH)
                    circle(d=LATCH_THICKNESS, center=true);
}

module picase() {
    //picase_box();
    translate([0,CASE_H+THICKNESS_BASE*2+LID_DISTANCE,0]) picase_lid();
}

// DXF drawing
/*
projection(cut=true) {
    translate([0,0,-6]) {
        picase_box();
    }
    translate([0,0,-3]) {
        picase_lid();
    }
}
*/

picase();


