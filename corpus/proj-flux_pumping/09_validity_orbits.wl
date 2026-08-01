(* Validity domains and orbit widths for the helical-core kinetic programme,
   quantifying Sergei's plan guidance (mail 2026-07-06): NEO-2-QL first,
   GORILLA delta-f near the axis where the trapped-ion width ~ Sqrt[R/r]
   diverges; fluid only at strongly reduced temperature. Gaussian units.
   AUG-like: B = 2 T, R = 170 cm, deuterium, q = 1.
   Exports fig_orbit_widths.pdf and fig_validity_map.pdf. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

figdir = FileNameJoin[{DirectoryName[$InputFileName], "figures"}];
If[!DirectoryQ[figdir], CreateDirectory[figdir]];

clight = 2.99792458 10^10; ee = 4.80320425 10^-10;
mD = 3.34358377 10^-24; me = 9.1093837 10^-28; erg = 1.602176634 10^-12;
B0 = 2 10^4; Rmaj = 170.; qs = 1.; lnL = 16.;

rhoL[Tev_, mass_] := mass Sqrt[2 Tev erg/mass] clight/(ee B0);
drPass[Tev_, mass_] := 2 qs rhoL[Tev, mass];
drTrap[Tev_, mass_, r_] := drPass[Tev, mass] Sqrt[Rmaj/r];
(* Potato regime: banana width equals radius, r^(3/2) = 2 q rhoL Sqrt[R]. *)
rPotato[Tev_, mass_] := (2 qs rhoL[Tev, mass])^(2/3) Rmaj^(1/3);

check["Val: memo orbit numbers reproduce (D, 5 keV): rhoL ~ 0.72 cm",
  Abs[rhoL[5 10^3, mD] - 0.72] < 0.02];
check["Val: trapped-ion width at r = 10 cm ~ 6 cm",
  Abs[drTrap[5 10^3, mD, 10.] - 6.0] < 0.3];
rpot5 = rPotato[5 10^3, mD];
Print["    potato radius (D, 5 keV): ", Round[rpot5, 0.01], " cm"];
check["Val: potato radius (D, 5 keV) ~ 7 cm: ions nonlocal in most of the core",
  6 < rpot5 < 8];
check["Val: electron banana width < 3% of the core size for r >= 2 cm",
  drTrap[5 10^3, me, 2.]/10. < 0.03];

figO = LogPlot[{drPass[5 10^3, mD], drTrap[5 10^3, mD, r],
    drTrap[5 10^3, me, r], r}, {r, 0.5, 25},
  PlotStyle -> {{ColorData[97, 1], Dashed}, {ColorData[97, 1], Thick},
    {ColorData[97, 3], Thick}, {Gray, Dotted}},
  Frame -> True, FrameLabel -> {"r [cm]", "orbit width [cm]"},
  PlotLegends -> Placed[LineLegend[
    {Directive[ColorData[97, 1], Dashed], Directive[ColorData[97, 1], Thick],
     Directive[ColorData[97, 3], Thick], Directive[Gray, Dotted]},
    {"passing D, 2q\!\(\*SubscriptBox[\(\[Rho]\), \(L\)]\)",
     "trapped D, 2q\!\(\*SubscriptBox[\(\[Rho]\), \(L\)]\)\[Sqrt](R/r)",
     "trapped e\!\(\*SuperscriptBox[\(\), \(-\)]\)",
     "width = r"}], {0.78, 0.32}],
  GridLines -> {{rpot5}, None},
  GridLinesStyle -> Directive[Red, Dashed],
  Epilog -> {Text[Style["potato\nboundary", 10, Red], Scaled[{0.33, 0.85}]],
    Text[Style["GORILLA full-f", 10, Bold], Scaled[{0.16, 0.06}]],
    Text[Style["NEO-2-QL local", 10, Bold], Scaled[{0.7, 0.06}]]},
  PlotLabel -> "D and e\!\(\*SuperscriptBox[\(\), \(-\)]\) at 5 keV, B = 2 T, R = 170 cm, q = 1",
  ImageSize -> 460];
Export[FileNameJoin[{figdir, "fig_orbit_widths.pdf"}], figO];
Print["    exported fig_orbit_widths.pdf"];

(* Fluid validity: (i) omega_E << nu_e, (ii) mean free path l_c << R/|dq|.
   l_c = vTe tau_e, tau_e = 3.44 10^5 Te[eV]^(3/2)/(ne lnL). *)
vTe[Tev_] := Sqrt[Tev erg/me];
taue[Tev_, ne_] := 3.44 10^5 Tev^(3/2)/(ne lnL);
lc[Tev_, ne_] := vTe[Tev] taue[Tev, ne];
TevStar[ne_, dq_] := Tev /. FindRoot[lc[Tev, ne] - Rmaj/dq, {Tev, 500., 1., 10^5}];
ne0 = 6 10^13;
Print["    l_c(3 keV, 6e13) = ", Round[lc[3 10^3, ne0]], " cm; R/|dq| at dq = 0.01: ",
  Round[Rmaj/0.01], " cm"];
Print["    fluid boundary T*(dq = 0.01) = ", Round[TevStar[ne0, 0.01]], " eV"];
check["Val: at 3 keV the connection-length condition is violated (kinetic needed)",
  lc[3 10^3, ne0] > Rmaj/0.01];
check["Val: fluid regime survives only below ~1 keV at dq = 0.01",
  500 < TevStar[ne0, 0.01] < 1500];
check["Val: at tens of eV (Sergei's benchmark suggestion) fluid is safely valid",
  lc[50., ne0] < 0.02 Rmaj/0.01];

figV = ContourPlot[
  Log10[lc[10^lT, ne0]/(Rmaj/10^ldq)], {lT, 1.3, 4}, {ldq, -3, -1},
  Contours -> Range[-4, 4], ColorFunction -> "TemperatureMap",
  FrameLabel -> {"log10 \!\(\*SubscriptBox[\(T\), \(e\)]\) [eV]",
    "log10 |q - \!\(\*SubscriptBox[\(q\), \(res\)]\)|"},
  PlotLegends -> BarLegend[Automatic,
    LegendLabel -> "log10 (\!\(\*SubscriptBox[\(l\), \(c\)]\) \[CenterDot] |\[CapitalDelta]q|/R)"],
  Epilog -> {Black, Thick,
    Line[Table[{Log10[TevStar[ne0, 10^ldq]], ldq}, {ldq, -3, -1, 0.1}]],
    Text[Style["fluid", 12, Bold, White], {1.7, -1.6}],
    Text[Style["kinetic", 12, Bold], {3.55, -2.4}],
    Dashed, Line[{{Log10[3000.], -3}, {Log10[3000.], -1}}],
    Text[Style["AUG hybrid core", 10], {Log10[3000.] - 0.12, -1.25}, {0, 0}, {0, 1}]},
  PlotLabel -> "connection-length condition \!\(\*SubscriptBox[\(l\), \(c\)]\) \[LessLess] R/|\[CapitalDelta]q|, \!\(\*SubscriptBox[\(n\), \(e\)]\) = 6\[Times]\!\(\*SuperscriptBox[\(10\), \(13\)]\) \!\(\*SuperscriptBox[\(cm\), \(-3\)]\)",
  ImageSize -> 480];
Export[FileNameJoin[{figdir, "fig_validity_map.pdf"}], figV];
Print["    exported fig_validity_map.pdf"];

reportAndExit[];
