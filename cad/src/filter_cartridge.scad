use <./lib/graphics/MLAB_logo.scad>
//// FILTER HOLDER LIB1
$fn = 50;

/// PARAMETRY


// Okraje
Ox = 3; // Tloušťka stěny v ose X
Oy = 3; // Tloušťka stěny v ose Y

// Vnější rozměry dílu
D = 61.5; // celková délka dílu
S = 50.5; // celková šířka dílu
V = 20; // celková výška dílu


// Otvor pro filtr
Do = D - 2*Ox; // délka otvoru pro filtr
So = S - 2*Oy; // šířka otvoru pro filtr
Vo = V; // výška prostoru pro filtr


/// VRSTVY
P = 10; // zahloubení nulté vrstvy

// První nosná vrstva (PravouhlaMriz)
H1 = 2; // Výška vrstvy
T1 = 0.8; // Tloušťka stěny v první vrstvě

H2 = V-(P+H1); // Výška spodní vrstvy

A1 = 4+T1;
B1 = 2+T1;

R = 50; // úhel ostnů

module Obal(Do, So, Vo, D, S, V) {
    Ox = (D - Do)/2;
    Oy = (S - So)/2;

    difference(){
      translate([-Ox,-Oy,0])
        cube([D, S, V]);
      translate([0,0,-1])
        cube([Do, So, Vo+2]);}
    }


module PravouhlaMriz(length, width, height, cell_size1, cell_size2, wall_thickness){

    A = floor(length/(cell_size1));
    B = floor(width/(cell_size2));


 for (i = [0 : A]) {
     translate([i * (cell_size1)- wall_thickness/2, 0, 0])
     cube([wall_thickness, width+wall_thickness, height]);
                        }

 for (i = [0 : B]) {
     translate([0, i * (cell_size2) - wall_thickness/2, 0])
     cube([length+wall_thickness, wall_thickness, height]);
                        }

    }

module triceratops(tloustka, uhel, dolni_podstava){

difference(){

    rotate([0,uhel/2,0])
        cube([10,tloustka,10]);


    translate([dolni_podstava,0,0])
    rotate([0,-uhel/2,0]) {
        translate([0,-0.5,0])
            cube([20,tloustka+1,10]);
        translate([0,-0.5,-9])
            cube([20,tloustka+1,10]);
        }
    translate([0,-0.5,-10])
        cube([20,tloustka+1,10]);
}
}
module Palisada(delka_oblasti, sirka_oblasti, vzdalenost_pricek, tloustka_tr, uhel_tr, dolni_podstava_tr){
 A = floor(delka_oblasti/dolni_podstava_tr);

  for (i = [0 : A]) {
     translate([(-1-i) * (dolni_podstava_tr), - tloustka_tr/2, 0])
     triceratops(tloustka_tr, uhel_tr, dolni_podstava_tr);
                        }
                    }


module Pole_Ostnu(delka_oblasti, sirka_oblasti, vzdalenost_pricek, tloustka_tr, uhel_tr, dolni_podstava_tr){
  B = floor(sirka_oblasti/(vzdalenost_pricek));
 for (i= [0 : B]) {
     translate([0, i*(vzdalenost_pricek), 0 ])
     Palisada(delka_oblasti, sirka_oblasti, vzdalenost_pricek, tloustka_tr, uhel_tr, dolni_podstava_tr);
}
}

module Zebra(delka_oblasti, sirka_oblasti, tloustka_pricek, vyska_pricek, roztec_pricek){

    A = floor(delka_oblasti/(tloustka_pricek+roztec_pricek));
    for (i = [0 : A]) {
        translate([i * (tloustka_pricek+roztec_pricek)- tloustka_pricek/2, 0, 0])
            cube([tloustka_pricek, sirka_oblasti, vyska_pricek]);
                       }
    }


module filter_cartridge()
{
  difference(){
    union(){
      translate([-Do,0,-P])
        intersection(){
            union(){
                cube([Do, So, 1.2]);
                translate([Do,So/2,1.2])
                    Palisada(Do, So, B1, So+0.5, R, A1);
                }
          Zebra(Do, So+0.5, 0.5, 15, 0.3); 
        }

      translate([0,0,-P])
        Pole_Ostnu(Do, So, B1, T1, R, A1);

      rotate([0,180,0]){

          translate([0,0,P])
              PravouhlaMriz(Do,So,H1,A1,B1/2, T1);

          translate([0,0, P+H1])
              PravouhlaMriz(Do,So,H2,A1,4*B1,T1);

        Obal(Do, So, Vo, D, S, V);
      }
    }

    // MLAB logo on the side
    union (){
        translate([-D/2 + 2,-2.5,-P])
          rotate ([90,0,0])
              scale(v = [0.4, 0.4, 0.4])
                  MLAB_logo_long();
    }
  }
}

filter_cartridge();
