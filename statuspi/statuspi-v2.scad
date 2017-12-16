$fn=120;

// Position of screw hole from corner
HOLE_POS = 3.5;

// Size of plate
PLATE_SIZE = 100;

// Pi Zero dimensions
PI_W = 65;
PI_H = 30;

// Header dimensions
HEADER_W = 53;
HEADER_H = 7;

// Pi zero case dimensions
CASE_W = 75;
CASE_H = 40;

// HAT dimensions
HAT_W = 65;
HAT_H = 56.5;

module rectangle_rounded(x, y, rad=1) {
	minkowski() {
		circle(r=rad);
		square([(x - 2 * rad), (y - 2 * rad)], true);
	}
}

module hole(x, y, d=2.75) {
    translate([x, y, 0]) {
        circle(d=d);
    }    
}

module header(x, y) {
    translate([x,y,0]) {
        rectangle_rounded(HEADER_W, HEADER_H);
    }
}

module corner_holes(w=75, h=40, hole_pos=3.5, d=2.75) {
    hole((w/2)-hole_pos, (h/2)-hole_pos, d);
    hole((w/2)-hole_pos, 0 - (h/2) + hole_pos, d);
    hole(0 - (w/2) + hole_pos, (h/2)-hole_pos, d);
    hole(0 - (w/2) + hole_pos, 0 - (h/2) + hole_pos, d);
}

module zeroplate(w=75, h=40) {
    difference() {
        rectangle_rounded(w,h,3);
        corner_holes(w,h);
    }
}

module statuspi_plate() {
    difference() {
        square([PLATE_SIZE, PLATE_SIZE], true);
        corner_holes(PLATE_SIZE, PLATE_SIZE, 5.5);
    }
}

// Front plate
statuspi_plate();

// Middle layer
translate([PLATE_SIZE + 5, 0, 0]) {
    difference() {
        statuspi_plate();
        rectangle_rounded(PI_W + 1, (PI_H * 2) + 1);

        // Pi case holes
        translate([0, PI_H/2, 0]) {
            corner_holes(d=5);
        }

    }
}

// Bottom layer
translate([(PLATE_SIZE + 5) * 2, 0, 0]) {
    difference() {
        statuspi_plate();
        /*
        translate([0, PI_H/2, 0]) {
            zeroplate(PI_W, PI_H);
        }
        translate([0, -PI_H/2, 0]) {
            zeroplate(PI_W, PI_H);
        }
        */
        // Scrollphat HD
        header(0, PI_H - HEADER_H/2);
        hole(PI_W/2 - HOLE_POS, PI_H - HOLE_POS);
        hole(-(PI_W/2 - HOLE_POS), PI_H - HOLE_POS);
        
        // chip cutout
        translate([0, 14, 0]) {
            rectangle_rounded(20, 12);
        }

        // Unicorn pHAT
        header(0, -(PI_H - HEADER_H/2));
        translate([0, -PI_H/2, 0]) {
            corner_holes(65, 30);
        }
        
        // Pi case holes
        translate([0, PI_H/2, 0]) {
            corner_holes();
        }
    }
}

// Bottom layer for Unicorn HAT (untested)
translate([(PLATE_SIZE + 5) * 3, 0, 0]) {
    difference() {
        statuspi_plate();
        // Unicorn HAT
        header(0, PI_H - HEADER_H/2);
        translate([0, 2, 0]) {
            corner_holes(HAT_W, HAT_H);
        }
        
        // Pi case holes
        translate([0, PI_H/2, 0]) {
            corner_holes();
        }
    }
}

