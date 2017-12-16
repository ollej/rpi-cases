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


module rectangle_rounded (x,y,rad=1) {
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
    hole((w/2) - hole_pos, (h/2) - hole_pos, d);
    hole((w/2) - hole_pos, 0 - (h/2) + hole_pos, d);
    hole(0 - (w/2) + hole_pos, (h/2) - hole_pos, d);
    hole(0 - (w/2) + hole_pos, 0 - (h/2) + hole_pos, d);
}

module zeroplate(w=75,h=40) {
    difference() {
        rectangle_rounded(w,h,3);
        corner_holes(w,h);
    }
}

// ----- Pi Zero W case

// Baseplate
difference() {
    zeroplate();
    header(0,11.5);
}

// Plate 2 - surrounding pi pcb
translate([0,45,0]) {
    difference() {
        zeroplate();
        rectangle_rounded(PI_W, PI_H);

        // Camera connector
        translate([31.5, 0, 0]) {
            rectangle_rounded(4, 18);
        }

        // SD Card
        translate([-31.5, 3.5, 0]) {
            rectangle_rounded(6, 12);
        }

        // Connector hole
        translate([0, -20, 0]) {
            square([51, 11], true);
        }
    }
}

// Plate 3
/*
translate([0,90,0]) {
    difference() {
        zeroplate(65,30);
        translate([0,-12,0]) {
            rectangle_rounded(51,8);
        }
        translate([0,12,0]) {
            rectangle_rounded(51,8);
        }
        translate([32.5,0,0]) {
            rectangle_rounded(8,16);
        }
        translate([-32.5,0,0]) {
            rectangle_rounded(8,16);
        }
        
    }
}
*/

// Plate 3 - With hole for On/Off SHIM
translate([0,90,0]) {
    difference() {
        zeroplate();
        header(0,11.5);

        // OnOff SHIM (33x16mm)
        translate([-(PI_W/2 - 17.5), PI_H/2-8, 0]) {
            rectangle_rounded(33, 16);
        }

        //rectangle_rounded(58,23);

        translate([0,-20,0]) {
            square([55, 18], true);
        }
    }
}

// Top plate
translate([0,135,0]) {
    difference() {
        zeroplate();
        header(0,11.5);
        
        translate([0,-20,0]) {
            rectangle_rounded(53,5);
        }
    }
}

// ----- Speaker pHAT stack

// Baseplate
translate([80,0,0]) {
    difference() {
        zeroplate();
        header(0,11.5);
    }
}

// Spacer
translate([80,45,0]) {
    difference() {
        zeroplate();
        rectangle_rounded(PI_W, PI_H);
    }
}

// Spacer
translate([80,90,0]) {
    difference() {
        zeroplate();
        rectangle_rounded(PI_W, PI_H);
    }
}

translate([80,135,0]) {
    difference() {
        zeroplate();
        header(0,11.5);
        corner_holes(PI_W, PI_H);
        translate([0,-5,0]) {
            rectangle_rounded(48,20);
        }
    }
}

// ---- Enviro pHAT stack

// Baseplate
translate([160,0,0]) {
    difference() {
        zeroplate();
        header(0,11.5);
    }
}

// Plate 2 - surrounding enviro pcb
translate([160,45,0]) {
    difference() {
        zeroplate();
        rectangle_rounded(PI_W, PI_H);
    }
}


/// ----- Pi Zero case for Annoyotron

// Baseplate
translate([240,0,0]) {
    difference() {
        zeroplate();
        header(0,11.5);
    }
}

// Plate 2 - surrounding pi pcb
translate([240,45,0]) {
    difference() {
        zeroplate();
        rectangle_rounded(PI_W, PI_H);

        // Camera connector
        translate([31.5, 0, 0]) {
            rectangle_rounded(4, 18);
        }

        // SD Card
        translate([-31.5, 3.5, 0]) {
            rectangle_rounded(6, 12);
        }

        // Connectors hole
        translate([0, -20, 0]) {
            square([51, 11], true);
        }
    }
}

// Plate 3 - Above Pi Zero w/ Zero LiPo SHIM
translate([240, 90, 0]) {
    difference() {
        zeroplate();
        header(0, 11.5);

        // Zero LiPo (40x22mm)
        translate([-(PI_W/2 - 20), PI_H/2-11, 0]) {
            rectangle_rounded(40, 22);
        }
        // Zero LiPo connector
        translate([-(CASE_W/2 - 9), PI_H/2 - 8.5, 0]) {
            square([19, 9], true);
        }

        // Connectors hole
        translate([0,-20,0]) {
            square([55, 18], true);
        }
    }
}

// Plate 4 - Top plate w/ Zero LiPo SHIM
translate([240, 135, 0]) {
    difference() {
        zeroplate();
        header(0, 11.5);

        // Zero LiPo connector
        translate([-(CASE_W/2 - 7), PI_H/2 - 8.5, 0]) {
            square([16, 9], true);
        }

        translate([0,-20,0]) {
            rectangle_rounded(53,5);
        }
    }
}

