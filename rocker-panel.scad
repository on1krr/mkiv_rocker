w = 52.5;  //rocker x dimension
l = 70;    //rocker y dimension
h = 25;    //0;    //length of rocker to print; 20 for tabbed part

x_delta = 0; //.5;  //manual compensation for rotation of the elipse
y_delta = 0; //1;  //manual compensation for rotation of the elipse

wall = 1.2; //1.2;
delta = 0.01;

cut = 5;

comp = 4.7; //was 4.5 in print //elipse compensation to extend beyond y dimension

plate_points = [ [0,0], [-20,0], [-50,-l+20+wall], [-50,-l], [0,-l] ];
tab_points = [ [10,h,0], [10,h+20,0], [45,h+20,0], [45,h,0] ];
//tab_cut = [ [20+cut,h+cut,0], [20+cut,h+20-cut,0], [40-cut,h+20-cut,0], [40-cut,h+cut,0] ];
tab_cut = [ [w-35,5,0], [w-35,h-5,0], [w-20,h-5,0], [w-20,5,0] ];

left_side = 0;  //referenced rocker panel section, for tab section use opposite
mount_plate = 1;
mount_tab = 1;

$fn=100;

module oval(w,h, height, center = false) {
 scale([1, h/w, 1]) cylinder(h=height, r=w, center=center);
}

module elipse(w,h, height, center = false) {
 scale([1, h/w, 1]) cylinder(h=height, r=w, center=center);
}

module rounded_box(points, radius, height){
    hull(){
        for (p = points){
            translate(p) cylinder(r=radius, h=height, $fn=60);
        }
    }
}

mirror([left_side,0,0]) {

    difference() {
        union () {
            difference() {
                rotate([0,0,90]) elipse(w=l+comp, h=w, height=h);
                rotate([0,0,90]) translate([0,0,wall]) elipse(w=l+comp-wall, h=w-wall, height=h+delta);
            }
            if (mount_tab == 0 ) {
               translate([-w,-wall,0]) cube([2*(w+x_delta),wall,h],center = false);
            }
            else {
               translate([-w,-3*wall,0]) cube([2*(w+x_delta),3*wall,h],center = false);
            }
                
            translate([-wall,-l,0]) cube([19,wall,h],center = false);
            rotate([0,0,90]) translate([-l+wall+y_delta,0,0]) cube([2*w,wall,h],center = false);
            rotate([0,0,90]) translate([-l+wall+y_delta,-wall,0]) cube([2*w,wall,h],center = false);
        }       
        translate([-100,0,-delta]) cube(200,center = false);
        rotate([0,0,90]) translate([-100,0,-delta]) cube(200,center = false);
        translate([0,-l+y_delta-20,-delta]) cube([20,20,200],center = false);
        if ( mount_tab == 1) {
            rotate([90,0,0])translate([0,0,-delta])rounded_box(tab_cut,0.01,3*wall+2*delta);
        }

    }    
    if ( mount_plate == 1) {
        rounded_box(plate_points,0.01,wall);
    }
        
}