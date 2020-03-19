//// FILTER HOLDER LIB1

/// PARAMETRY

// Otvor pro filtr
Do = 62; // délka otvoru pro filtr
So = 51; // šířka otvoru pro filtr
Vo = 20; // výška prostoru pro filtr

// Okraje
Ox = 3; // Tloušťka stěny v ose X
Oy = 3; // Tloušťka stěny v ose Y

// Vnější rozměry dílu
D = Do + 2*Ox; // celková délka dílu
S = So + 2*Oy; // celková šířka dílu
V = Vo; // celková výška dílu

// První vrstva (honeycomb)
P = 3; // zahloubení první vrstvy
H1 = 3; // Výška první vrstvy
S1 = 2; // Velikost buňky v první vrstvě
T1 = 1; // Tloušťka stěny v první vrstvě

// Druhá vrstva(honeycomb)
H2 = 2; // Výška druhé vrstvy
S2 = 5; // Velikost buňky v druhé vrstvě
T2 = 1; // Tloušťka stěny v první vrstvě

// Třetí vrstva (PravouhlaMriz)
H3 = 2; // Výška třetí vrstvy
S3 = 1.5; // Strana čtverce jedné buňky
T3 = 1; // Tloušťka stěny v třetí vrstvě

// Čtvrtá vrstva

H4 = V-(P+H1+H2+H3);
S4 = 4;
T4 = 1;




module Obal(Do, So, Vo, D, S, V) {
    Ox = (D - Do)/2;
    Oy = (S - So)/2;
    
    difference(){
        translate([-Ox,-Oy,0])
        cube([D, S, V]); 
        cube([Do, So, Vo+1]);}    
    
    }
  
    
module hc_hexagon(size, height) {
	box_width = size/1.75;
	for (r = [-60, 0, 60]) rotate([0,0,r]) cube([box_width, size, height],
true);
}

module hc_column(length, height, cell_size, wall_thickness) {
   no_of_cells = floor(1 + length / (cell_size + wall_thickness)) ;

        for (i = [0 : no_of_cells]) {
                translate([0,(i * (cell_size + wall_thickness)),0])
                        hc_hexagon(cell_size, height + 1);
        }
}

module honeycomb (length, width, height, cell_size, wall_thickness) {
    length = length - 6*wall_thickness;
    width = width - 6*wall_thickness;
 
   
            no_of_rows = floor(1.75 * length / (cell_size + wall_thickness)) ;

            tr_mod = cell_size + wall_thickness;
            tr_x = sqrt(3)/2 * tr_mod;
            tr_y = tr_mod / 2;
            off_x = -cell_size/2 + 2 * wall_thickness;
            off_y = -wall_thickness/2;
            difference(){
                        cube([length, width, height]);
                        for (i = [0 : no_of_rows]) {
                                translate([i * tr_x + off_x, (i % 2) * tr_y + off_y, height-10])
                                        hc_column(width, height+20, cell_size, wall_thickness);
                        }
            }
     
}

module PravouhlaMriz(length, width, height, cell_size, wall_thickness){
    
    A = length/(cell_size+wall_thickness);
    B = width/(cell_size+wall_thickness);
    
   
 for (i = [0 : A-1]) {
     translate([i * (cell_size + wall_thickness) - wall_thickness, 0, 0])
     cube([wall_thickness, width-3*wall_thickness, height]);
                        }


 for (i = [0 : B-1]) {
     translate([0, i * (cell_size + wall_thickness) - wall_thickness, 0])
     cube([length-3*wall_thickness, wall_thickness, height]);
                        }
    
    }
    
    

rotate([0,180,0]){
translate([0,0,P])
honeycomb(D,S,H1,S1,T1);
    
translate([0,0,P+H1])
honeycomb(D,S,H2,S2,T2);
    
translate([0,0, P+H1+H2])
PravouhlaMriz(D,S,H3,S3,T3);

translate([0,0,P+H1+H2+H3])
honeycomb(D,S,H4,S4,T4);


Obal(Do, So, Vo, D, S, V);
}
