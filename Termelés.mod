set Termekek;
set Nyersanyagok;

param Keszlet {ny in Nyersanyagok}, >=0, default 1e100;
param Fogyasztasiarany {ny in Nyersanyagok, t in Termekek}, >=0, default 0;
param Ar {t in Termekek}, >=0, default 0;
param Minimumfelhasznalas {ny in Nyersanyagok}, >=0, <=Keszlet[ny], default 0;
param Minimumtermeles {t in Termekek}, >=0, default 0;
param Maximumtermeles {t in Termekek}, >=Minimumtermeles[t], default 1e100;


var termeles {t in Termekek}, >=0;


s.t. Anyag_Keszlet {ny in Nyersanyagok}:
    sum {t in Termekek} Fogyasztasiarany[ny,t] * termeles[t] <= Keszlet[ny];

s.t. Felh_Minimumfelhasznalas {ny in Nyersanyagok}:
    sum {t in Termekek} Fogyasztasiarany[ny,t] * termeles[t] >= Minimumfelhasznalas[ny];

s.t. Felh_Minimumtermeles {t in Termekek}:
    termeles[t] >= Minimumtermeles[t];

s.t. Felh_Maximumtermeles {t in Termekek}:
    termeles[t] <= Maximumtermeles[t];

maximize Teljes_Bevetel: sum {t in Termekek} Ar[t] * termeles[t];


solve;

param Felhasznaltnyersanyag {ny in Nyersanyagok} :=
    sum {t in Termekek} Fogyasztasiarany[ny,t] * termeles[t];
param Maradeknyersanyag {ny in Nyersanyagok} :=
    Keszlet[ny] - Felhasznaltnyersanyag[ny];

printf "Teljes bevetel: %g\n", sum {t in Termekek} Ar[t] * termeles[t];

printf "\n";

for {t in Termekek}
{
printf "- %s: %g\n", t, termeles[t];
}

printf "\n";

for {ny in Nyersanyagok}
{
printf "Felhasznalt %s: %g, maradek: %g\n",
ny, Felhasznaltnyersanyag[ny], Maradeknyersanyag[ny];
}

data;

set Termekek := Ajto Ablak Szek Asztal;
set Nyersanyagok := Aram Munkaora Anyagmennyiseg;

param Keszlet :=
    Aram 23000
    Munkaora 31000
    Anyagmennyiseg 450000
    ;

param Fogyasztasiarany:

                    Ajto    Ablak   Szek  Asztal:=
    Aram            200     50      0     20
    Munkaora        25      180     75    100
    Anyagmennyiseg  3200    1000    4500  2500
    ;

param Ar :=

    Ajto 252 
    Ablak 89
    Szek 139
    Asztal 120
    ;
    

param Minimumfelhasznalas :=

    Munkaora 21000
    Aram 10000
    ;

param Minimumtermeles :=

    Ablak 100
    ;

param Maximumtermeles :=

    Szek 10
    Ajto 30
    ;

end;