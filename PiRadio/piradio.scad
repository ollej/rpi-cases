include <SimpleBox.scad>

// Define the size of the box
width = 300;
length = 60;
height = 100;

THICKNESS = 6;

// Text to help for assembly and orientation
ft = "Stencil";

PiRadio();

module PiRadio() {
    difference() {
        FlatView();
        
        Unicorn();
        LeftSpeaker();
        RightSpeaker();
        
        Buttons();
        
        PiZero();
        
        PowerBoost();
    }
}

module LeftSpeaker() {
    translate([60, -height/2 - 2]) Speaker();
}

module RightSpeaker() {
    translate([240, -height/2 - 2]) Speaker();
}

module Speaker() {
    circle(d=65);
    
    rotate([0,0,45]) translate([37, 0]) circle(d=4.2);
    rotate([0,0,135]) translate([37, 0]) circle(d=4.2);
    rotate([0,0,225]) translate([37, 0]) circle(d=4.2);
    rotate([0,0,315]) translate([37, 0]) circle(d=4.2);
}

module PiZero() {
    translate([300/2, length + height/2 + 2])
        corner_holes();
}

module USB() {
    translate([50, length + height - THICKNESS - 5.5, 0])
        rectangle_rounded(10, 7);
}

module PowerBoost() {
    USB();
    x = 50;
    y = length + height + 4 + THICKNESS + 2.75/2 + 2;
    translate([x, y, 0]) {
        hole(-8.25, 0);
        hole(8.25, 0);
    }
}

module Unicorn() {
    translate([width/2, -height/2 - 2, 0]) {
        rectangle_rounded(65, 57);
    }
}

module Buttons() {
    // TODO: Color labels blue
    button_distance = 17.5;
    translate([300/2, length/2, 0]) {
        translate([-button_distance/2, 0, 0]) Button("Vol -");
        translate([-button_distance/2 - button_distance, 0, 0]) Button("Vol +");
        translate([-button_distance/2 - button_distance*2, 0, 0]) Button("Power");
        translate([button_distance/2, 0, 0]) Button("Prev");
        translate([button_distance/2 + button_distance, 0, 0]) Button("Next");
        translate([button_distance/2 + button_distance*2, 0, 0]) Button("Play");
    }
}

module Button(label = "") {
    circle(d=11);
    translate([0, -10, 0])
        color("blue")
            text(label, size=3, valign="center", halign="center", font=ft);
}

// Helper modules
module rectangle_rounded(x, y, rad=1) {
	minkowski() {
		circle(r=rad);
		square([(x - 2 * rad), (y - 2 * rad)], center = true);
	}
}

module hole(x, y, d=2.75) {
    translate([x, y, 0]) {
        circle(d=d);
    }    
}

module corner_holes(w=65, h=30, hole_pos=3.5, d=2.75) {
    hole((w/2) - hole_pos, (h/2) - hole_pos, d);
    hole((w/2) - hole_pos, 0 - (h/2) + hole_pos, d);
    hole(0 - (w/2) + hole_pos, (h/2) - hole_pos, d);
    hole(0 - (w/2) + hole_pos, 0 - (h/2) + hole_pos, d);
}

