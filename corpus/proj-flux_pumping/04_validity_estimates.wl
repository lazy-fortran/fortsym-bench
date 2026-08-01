(* Memo Sec. 4: numerical validity estimates for the ion orbit widths in the
   helical core. Gaussian units. Deuterium, E = 5 keV, B = 2 T = 2 10^4 G,
   q = 1, R = 170 cm, r = 10 cm. Verifies the quoted numbers:
   rhoL ~ 0.7 cm, drp = 2 q rhoL ~ 1.4 cm, drt = drp Sqrt[R/r] ~ 6 cm,
   trapped fraction Sqrt[r/R] ~ 0.25. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

clight = 2.99792458 10^10;         (* cm/s *)
e      = 4.80320425 10^-10;        (* statcoulomb *)
mD     = 3.34358377 10^-24;        (* deuteron mass, g (CODATA) *)
erg    = 1.602176634 10^-12;       (* erg per eV *)

EkeV = 5 10^3 erg;                 (* 5 keV in erg *)
B0   = 2 10^4;                     (* 2 T in G *)
qsaf = 1; Rmaj = 170.; rmin = 10.;

vD   = Sqrt[2 EkeV/mD];
rhoL = mD vD clight/(e B0);
drp  = 2 qsaf rhoL;
drt  = drp Sqrt[Rmaj/rmin];
ft   = Sqrt[rmin/Rmaj];

Print["v_D          = ", Round[vD, 10^4], " cm/s"];
Print["rho_L        = ", Round[rhoL, 0.001], " cm   (memo: ~0.7)"];
Print["dr_passing   = ", Round[drp, 0.001], " cm   (memo: ~1.4)"];
Print["dr_trapped   = ", Round[drt, 0.001], " cm   (memo: ~6)"];
Print["trapped frac = ", Round[ft, 0.001], "      (memo: ~0.25)"];

check["Sec4: rho_L ~ 0.7 cm", Abs[rhoL - 0.7] < 0.1];
check["Sec4: passing orbit width 2 q rho_L ~ 1.4 cm", Abs[drp - 1.4] < 0.2];
check["Sec4: trapped orbit width ~ 6 cm", Abs[drt - 6] < 0.5];
check["Sec4: trapped fraction ~ 0.25", Abs[ft - 0.25] < 0.02];

reportAndExit[];
