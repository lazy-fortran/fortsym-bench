ClearAll["Global`*"];

root = DirectoryName[DirectoryName[$InputFileName]];
notebookDir = FileNameJoin[{root, "mathematica"}];
figureDir = FileNameJoin[{root, "writeup", "figures"}];
If[!DirectoryQ[figureDir], CreateDirectory[figureDir, CreateIntermediateDirectories -> True]];

checkResults = {};
check[name_, condition_] := AppendTo[checkResults, {name, TrueQ[condition]}];

titleCell[text_] := Cell[text, "Title"];
sectionCell[text_] := Cell[text, "Section"];
subsectionCell[text_] := Cell[text, "Subsection"];
textCell[text_] := Cell[text, "Text"];
equationCell[expr_] := Cell[BoxData[ToBoxes[expr, TraditionalForm]], "DisplayFormula"];
inputCell[expr_] := Cell[BoxData[ToBoxes[Defer[expr], StandardForm]], "Input"];
outputCell[expr_] := Cell[BoxData[ToBoxes[expr, StandardForm]], "Output"];

saveNotebook[base_, cells_] := Module[{expression, object, nbPath, pdfPath},
  expression = Notebook[cells,
    StyleDefinitions -> "Default.nb",
    PrintingOptions -> {"FacingPages" -> False, "PaperOrientation" -> "Portrait", "PaperSize" -> {595, 842}},
    WindowSize -> {1100, 850}
  ];
  nbPath = FileNameJoin[{notebookDir, base <> ".nb"}];
  pdfPath = FileNameJoin[{notebookDir, base <> ".pdf"}];
  Export[nbPath, expression];
  UsingFrontEnd[
    object = NotebookPut[expression];
    SelectionMove[object, Before, Notebook];
    FrontEndExecute[FrontEndToken[object, "SelectAll"]];
    FrontEndExecute[FrontEndToken[object, "SelectionOpenAllGroups"]];
    Export[pdfPath, object];
    NotebookClose[object];
  ];
];

phase = phi;
hPert = h[j] Cos[phase];
delta = m capitalOmega[j] - omega;
aCoef = m h[j] f0'[j] delta/(delta^2 + nu^2);
bCoef = m h[j] f0'[j] nu/(delta^2 + nu^2);
fPert = aCoef Cos[phase] - bCoef Sin[phase];
poissonBracket = m (D[fPert, phi] D[hPert, j] - D[fPert, j] D[hPert, phi]);
averagedBracket = Simplify[Integrate[TrigExpand[poissonBracket], {phi, 0, 2 Pi}]/(2 Pi)];
expectedBracket = -D[m^2 h[j]^2 f0'[j] nu/(2 (delta^2 + nu^2)), j];
check["Fourier Poisson-bracket average is a divergence", Simplify[averagedBracket - expectedBracket] === 0];

lorentzianArea = Assuming[nu > 0, Integrate[nu/(x^2 + nu^2), {x, -Infinity, Infinity}]];
check["Causal Lorentzian has area pi", lorentzianArea === Pi];

projectorSample = a0[j, t] + aC[j, t] Cos[phi] + aS[j, t] Sin[2 phi];
projector[expr_] := Simplify[Integrate[expr, {phi, 0, 2 Pi}]/(2 Pi)];
projectorTimeCommutator = Simplify[D[projector[projectorSample], t] - projector[D[projectorSample, t]]];
check["Fixed angle projector commutes with time differentiation", projectorTimeCommutator === 0];

qProjectorSample = Expand[projectorSample - projector[projectorSample]];
check["Complementary projection has zero mean", Simplify[projector[qProjectorSample]] === 0];

barDistribution = fBar[j, t];
tildeHamiltonian = hC[j] Cos[phi] + hS[j] Sin[phi];
mixedBracket = D[barDistribution, phi] D[tildeHamiltonian, j] - D[barDistribution, j] D[tildeHamiltonian, phi];
check["Mean-fluctuation Poisson bracket averages to zero", Simplify[projector[mixedBracket]] === 0];

firstHamiltonian = hBar[j] + hC[j] Cos[phi] + hS[j] Sin[phi];
firstDistribution = fMean1[j] + fC[j] Cos[phi] + fS[j] Sin[phi];
h1Oscillating = Expand[firstHamiltonian - projector[firstHamiltonian]];
f1Oscillating = Expand[firstDistribution - projector[firstDistribution]];
check["Projected first-order Hamiltonian has zero mean", Simplify[projector[h1Oscillating]] === 0];
check["Projected first-order response has zero mean", Simplify[projector[f1Oscillating]] === 0];

realProductAverage = Assuming[Element[{aR, aI, bR, bI}, Reals],
  FullSimplify[projector[Re[(aR + I aI) Exp[I phi]] Re[(bR + I bI) Exp[I phi]]]]
];
check["Real harmonic product supplies factor one half", realProductAverage === (aR bR + aI bI)/2];

slowFastPlot = Plot[
  Evaluate[{1 + 0.16 t, 1 + 0.16 t + 0.13 Cos[10 t]}],
  {t, 0, 5},
  PlotStyle -> {{Thick, RGBColor[0.1, 0.35, 0.75]}, {Thin, RGBColor[0.85, 0.25, 0.18]}},
  PlotLegends -> Placed[{"slow background", "background + fast response"}, Above],
  AxesLabel -> {"t", "f"},
  PlotRange -> All,
  ImageSize -> 520,
  BaseStyle -> {FontFamily -> "Latin Modern Roman", 13}
];
Export[FileNameJoin[{figureDir, "scale_separation.pdf"}], slowFastPlot];

orderingCells = {
  titleCell["Quasilinear ordering: exact split, linear response, slow evolution"],
  textCell["The exact mean/oscillating split and the small-amplitude expansion are different operations. This notebook applies the projector to a general first-order coefficient before naming its mean and oscillating parts."],
  sectionCell["1. Fixed canonical-angle projector"],
  textCell["On a regular invariant torus define P a as the integral over the canonical angles at fixed actions and fixed time. The domain and measure have no time dependence. Differentiation under this fixed integral proves that P commutes with partial_t; it is not an extra physical assumption."],
  equationCell[HoldForm[Projector[a] == 1/(2 Pi)^capitalN Integrate[a[jVec, thetaVec, t], angleTorus]]],
  equationCell[HoldForm[D[Projector[a], t] == Projector[D[a, t]]]],
  inputCell[projectorTimeCommutator],
  outputCell[projectorTimeCommutator],
  textCell["If the orbit chart or measure changes with time, the operator is P_t and the commutator equals (partial_t P_t) a. That term must be estimated before it is dropped."],
  equationCell[HoldForm[D[ProjectorT[t][a], t] - ProjectorT[t][D[a, t]] == D[ProjectorT[t], t][a]]],
  sectionCell["2. Exact decomposition"],
  textCell["Define Q=1-P, f-bar=P f, f-tilde=Q f, H-bar=P H, and H-tilde=Q H. Idempotence P^2=P implies P f-tilde=P H-tilde=0. Periodicity gives P partial_theta a=0, so both mixed Poisson brackets average to zero."],
  equationCell[HoldForm[f == OverBar[f] + Overscript[f, "~"]]],
  equationCell[HoldForm[Average[Overscript[f, "~"]] == 0]],
  inputCell[projector[qProjectorSample]],
  outputCell[projector[qProjectorSample]],
  inputCell[projector[mixedBracket]],
  outputCell[projector[mixedBracket]],
  textCell["Projecting the collision term is always valid. Replacing P C[f] by C[P f] is valid only for a linear collision model that commutes with P."],
  equationCell[HoldForm[D[OverBar[f], t] + Projector[PoissonBracket[Overscript[f, "~"], Overscript[H, "~"]]] == Projector[Collision[f]]]],
  equationCell[HoldForm[D[Overscript[f, "~"], t] + PoissonBracket[OverBar[f], Overscript[H, "~"]] + PoissonBracket[Overscript[f, "~"], OverBar[H]] + Q[PoissonBracket[Overscript[f, "~"], Overscript[H, "~"]]] == Q[Collision[f]]]],
  sectionCell["3. Apply P and Q to the perturbation expansion"],
  textCell["Start with H=H0+epsilon h^(1)+... and f=F0+epsilon g^(1)+... without assigning a mean to the first-order coefficients. Define H1=Q h^(1), hbar1=P h^(1), f1=Q g^(1), and F1=P g^(1). Then P H1=P f1=0 follows from P Q=0."],
  equationCell[HoldForm[{hBar1 == Projector[hFirst], H1 == Q[hFirst], F1 == Projector[gFirst], f1 == Q[gFirst]}]],
  equationCell[HoldForm[{Projector[H1] == 0, Projector[f1] == 0}]],
  inputCell[{projector[firstHamiltonian], h1Oscillating, projector[h1Oscillating]}],
  outputCell[{projector[firstHamiltonian], h1Oscillating, projector[h1Oscillating]}],
  inputCell[{projector[firstDistribution], f1Oscillating, projector[f1Oscillating]}],
  outputCell[{projector[firstDistribution], f1Oscillating, projector[f1Oscillating]}],
  textCell["A nonzero P h^(1) belongs in the background and shifts the unperturbed frequencies. For the NTV spectrum every retained canonical Fourier vector is nonzero, so its angle average vanishes. The order-epsilon mean distribution F1 vanishes only when its initial value and mean forcing vanish and the collision model preserves the projected subspaces; otherwise F1 remains part of f0."],
  equationCell[HoldForm[{OverBar[H] == H0 + epsilon hBar1 + O[epsilon^2], Overscript[H, "~"] == epsilon H1 + O[epsilon^2]}]],
  equationCell[HoldForm[{OverBar[f] == F0 + epsilon F1 + O[epsilon^2], Overscript[f, "~"] == epsilon f1 + O[epsilon^2]}]],
  sectionCell["4. Slow-time closure"],
  textCell["Set T=epsilon^2 t and freeze f0 on the fast orbit time. The oscillating order-epsilon equation determines f1. The mean of {f1,H1} first enters at order epsilon^2 and drives f0. The oscillating order-epsilon^2 term is omitted from the linear response but its mean is retained."],
  equationCell[HoldForm[D[f1, t] + PoissonBracket[f1, H0] + PoissonBracket[f0, H1] == CollisionLinear[f1]]],
  equationCell[HoldForm[D[f0, capitalT] + Projector[PoissonBracket[f1, H1]] == CollisionSlow[f0]]],
  textCell["The angle projector is exact. Scale separation is instead what permits f0 and the harmonic amplitudes to remain frozen during the response solve."],
  equationCell[HoldForm[1/Abs[capitalOmegaFast] < deltaTAverage < tauBackground]],
  outputCell[slowFastPlot],
  sectionCell["5. Retarded first-order harmonic response"],
  textCell["For one harmonic, the scalar Krook model gives a first-order ODE. Integrating it from the remote past removes the homogeneous transient and fixes the sign of -i nu. A physical collision operator may give another finite-width shape; the scalar model is used only for the causal pole and weak zero-width limit."],
  equationCell[HoldForm[D[fHatSubm[t], t] + (nu + I mVec . capitalOmegaVec) fHatSubm[t] == I hSubm (mVec . Grad[f0, jVec]) Exp[-I omega t]]],
  equationCell[HoldForm[fHatSubm[t] == I hSubm (mVec . Grad[f0, jVec]) Integrate[Exp[-(nu + I mVec . capitalOmegaVec) (t - tp)] Exp[-I omega tp], {tp, -Infinity, t}]]],
  equationCell[HoldForm[fSubm == hSubm/(mVec . capitalOmegaVec - omega - I nu) (mVec . Grad[f0, jVec])]],
  sectionCell["6. Why the evolution is quasilinear"],
  textCell["The product of two real harmonics has mean one half the real part of the product with one amplitude conjugated. This fixes the factor one half. The explicit one-action calculation then verifies that the averaged Poisson bracket is an action divergence."],
  inputCell[realProductAverage],
  outputCell[realProductAverage],
  inputCell[averagedBracket],
  outputCell[averagedBracket],
  equationCell[HoldForm[D[f0, t] == D[(m^2 h[j]^2 f0'[j])/2 (nu/(delta[j]^2 + nu^2)), j]]],
  textCell["The Lorentzian has fixed area pi and converges distributionally to pi delta(delta). This produces the resonant kernel and makes the perturbation-amplitude scaling explicit."],
  inputCell[lorentzianArea],
  outputCell[lorentzianArea],
  equationCell[HoldForm[QSubm == Pi/2 Abs[hSubm]^2 DiracDelta[mVec . capitalOmegaVec - omega] (mVec . Grad[f0, jVec])]],
  equationCell[HoldForm[D[f0, t] == Sum[mVec . Grad[QSubm, jVec], mVec]]],
  sectionCell["7. Conditions attached to the result"],
  textCell["Particle number is conserved only when the normal action-space flux vanishes and the collision operator conserves particles. Collisionless energy is conserved for a static drive; an oscillatory drive exchanges energy. The scalar Krook regulator does not conserve momentum or energy and is removed after the causal integral is formed."],
  outputCell[Grid[{{"check", "result"}, {"P commutes with partial_t", projectorTimeCommutator === 0}, {"P Q h1", projector[h1Oscillating] === 0}, {"P Q f1", projector[f1Oscillating] === 0}, {"mixed bracket", projector[mixedBracket] === 0}, {"real product factor", realProductAverage === (aR bR + aI bI)/2}, {"Poisson bracket", averagedBracket === expectedBracket}, {"Lorentzian area", lorentzianArea === Pi}}, Frame -> All]]
};

nuValues = {1., 0.35, 0.1};
lorentzianPlot = Plot[
  Evaluate@Table[n/(x^2 + n^2)/Pi, {n, nuValues}],
  {x, -3, 3},
  PlotStyle -> {Thick, Dashed, DotDashed},
  PlotLegends -> Placed[Map["nu = " <> ToString[#] &, nuValues], Above],
  AxesLabel -> {"resonance mismatch", "delta_nu"},
  PlotRange -> {0, 3.4},
  ImageSize -> 500,
  BaseStyle -> {FontFamily -> "Latin Modern Roman", 13}
];
Export[FileNameJoin[{figureDir, "resonance_broadening.pdf"}], lorentzianPlot];

pendulumHamiltonian = y^2/2 + 1 - Cos[theta];
pendulumPlot = ContourPlot[
  pendulumHamiltonian,
  {theta, -Pi, Pi}, {y, -3, 3},
  Contours -> {0.25, 0.75, 1.4, 2, 2.7, 3.6},
  ContourStyle -> {Directive[Thin, Gray], Directive[Thin, Gray], Directive[Thin, Gray], Directive[Thick, RGBColor[0.8, 0.15, 0.15]], Directive[Thin, RGBColor[0.15, 0.35, 0.75]], Directive[Thin, RGBColor[0.15, 0.35, 0.75]]},
  ContourShading -> None,
  FrameLabel -> {"resonant phase", "scaled resonant action y"},
  PlotLegends -> Placed[LineLegend[{Directive[Thick, RGBColor[0.8, 0.15, 0.15]]}, {"separatrix H = 2"}], Above],
  ImageSize -> 520,
  BaseStyle -> {FontFamily -> "Latin Modern Roman", 13}
];
Export[FileNameJoin[{figureDir, "pendulum_phase_space.pdf"}], pendulumPlot];

dDefinition = dRes Sqrt[omegaPrimeAbs]/hAbs^(3/2);
check["Dimensionless diffusivity is dimensionless under pendulum scaling", Simplify[dDefinition hAbs^(3/2)/(dRes Sqrt[omegaPrimeAbs])] === 1];

pendulumK = aPend iRes^2/2 - hPend Cos[alpha];
pendulumAlphaDot = D[pendulumK, iRes];
pendulumIDot = -D[pendulumK, alpha];
pendulumFrequencySquared = D[pendulumK, {iRes, 2}] D[pendulumK, {alpha, 2}] /. {iRes -> 0, alpha -> 0};
check["Pendulum linearisation gives nonlinear frequency squared", pendulumFrequencySquared === aPend hPend];

separatrixWidthCheck = FullSimplify[
  (pendulumK /. {iRes -> 2 Sqrt[hPend/aPend], alpha -> 0}) == (pendulumK /. {iRes -> 0, alpha -> Pi}),
  Assumptions -> aPend > 0 && hPend > 0
];
check["Pendulum separatrix half-width", separatrixWidthCheck];

diffusionCrossingTime = FullSimplify[(2 Sqrt[hPend/aPend])^2/(2 dPend), Assumptions -> aPend > 0 && hPend > 0 && dPend > 0];
check["Diffusion time across pendulum half-width", diffusionCrossingTime === 2 hPend/(aPend dPend)];

validityPlot = LogLogPlot[
  Evaluate[{1, d}],
  {d, 0.03, 30},
  PlotStyle -> {{Thick, Gray}, {Thick, RGBColor[0.1, 0.35, 0.75]}},
  Filling -> {2 -> {1}},
  FillingStyle -> Directive[Opacity[0.16], RGBColor[0.1, 0.35, 0.75]],
  Frame -> True,
  FrameLabel -> {"D", "relative phase randomisation"},
  PlotRange -> {0.03, 30},
  Epilog -> {Text[Style["nonlinear", 13], {0.12, 0.18}], Text[Style["quasilinear", 13], {8, 8}]},
  ImageSize -> 500,
  BaseStyle -> {FontFamily -> "Latin Modern Roman", 13}
];
Export[FileNameJoin[{figureDir, "validity_parameter.pdf"}], validityPlot];

resonanceCells = {
  titleCell["Resonant pendulum, collisional decorrelation, and validity of quasilinear theory"],
  textCell["The nonlinear frequency and island width follow from Hamilton's equations for a locally transformed resonant pair. This notebook keeps the numerical factors until the conventional scaling parameter is defined."],
  sectionCell["1. Canonical resonant pair"],
  textCell["Choose alpha = m dot theta - omega t and a conjugate action I. In extended phase space the derivative of the unperturbed transformed Hamiltonian with respect to I is the resonance mismatch. At the resonant surface the first derivative is zero."],
  equationCell[HoldForm[D[K0[Ires], Ires] == mVec . capitalOmegaVec - omega]],
  equationCell[HoldForm[mVec . capitalOmegaVec[jRes] - omega == 0]],
  textCell["Taylor expansion therefore begins with one half Omega-prime I^2. Retaining one resonant harmonic, shifting its phase, and choosing the action orientation gives K = a I^2/2 - h cos(alpha), with a=|Omega-prime| and h=|H_m|."],
  equationCell[HoldForm[KRes == a iRes^2/2 - h Cos[alpha]]],
  equationCell[HoldForm[a == Abs[D[mVec . capitalOmegaVec - omega, Ires]]]],
  textCell["The reduction needs a nonzero detuning slope, a narrow island so cubic detuning is small, and separation from other resonances."],
  sectionCell["2. Hamilton equations and nonlinear frequency"],
  textCell["Differentiate K. The two first-order Hamilton equations combine into the pendulum equation. Linearising sin(alpha) about the stable point gives the small-libration frequency."],
  inputCell[{pendulumAlphaDot, pendulumIDot}],
  outputCell[{pendulumAlphaDot, pendulumIDot}],
  equationCell[HoldForm[{D[alpha, t] == a iRes, D[iRes, t] == -h Sin[alpha]}]],
  equationCell[HoldForm[D[alpha, {t, 2}] + a h Sin[alpha] == 0]],
  equationCell[HoldForm[omegaNonlinear == Sqrt[a h]]],
  inputCell[pendulumFrequencySquared],
  outputCell[pendulumFrequencySquared],
  textCell["This is the frequency near the island centre. The finite-amplitude libration frequency decreases with orbit energy and reaches zero at the separatrix."],
  sectionCell["3. Separatrix width"],
  textCell["The stable point has energy -h and the unstable point has energy +h. Evaluate the separatrix at alpha=0 and set its energy equal to +h. Solving a I_max^2/2 - h = +h gives the half-width 2 sqrt(h/a); the full width is twice that."],
  equationCell[HoldForm[a iMax^2/2 - h == h]],
  equationCell[HoldForm[deltaIHalf == 2 Sqrt[h/a]]],
  inputCell[separatrixWidthCheck],
  outputCell[separatrixWidthCheck],
  textCell["The separatrix in the plot separates libration and rotation in resonant phase space. It is not a magnetic-flux separatrix."],
  outputCell[pendulumPlot],
  sectionCell["4. Diffusion time and validity parameter"],
  textCell["For locally constant action diffusion, mean-square displacement is 2 D_res t. Crossing one exact half-width therefore takes 2 h/(a D_res). The characteristic nonlinear time is 1/sqrt(a h). Their ratio contains an order-one factor one half."],
  equationCell[HoldForm[Mean[(iRes[t] - iRes[0])^2] == 2 dRes t]],
  equationCell[HoldForm[tauDiffusion == (2 Sqrt[h/a])^2/(2 dRes) == 2 h/(a dRes)]],
  equationCell[HoldForm[tauNonlinear == 1/Sqrt[a h]]],
  equationCell[HoldForm[tauNonlinear/tauDiffusion == dRes Sqrt[a]/(2 h^(3/2))]],
  inputCell[diffusionCrossingTime],
  outputCell[diffusionCrossingTime],
  textCell["The thesis parameter D drops order-one choices such as half-width versus full width and inverse frequency versus full 2 pi period. D much greater than one means diffusion crosses the island before coherent libration develops; D near one is a scaling boundary, not a universal threshold."],
  equationCell[HoldForm[d == dRes Sqrt[omegaPrimeAbs]/hAbs^(3/2)]],
  outputCell[validityPlot],
  sectionCell["5. Universal kinetic equation"],
  textCell["After the same scaling of the perturbed distribution, the kinetic equation near the resonance is universal. Its only parameter is D."],
  equationCell[HoldForm[y D[g[thetaBar, y], thetaBar] - Sin[thetaBar] (D[g[thetaBar, y], y] + 1) - d D[g[thetaBar, y], {y, 2}] == 0]],
  equationCell[HoldForm[d == dRes Sqrt[omegaPrimeAbs]/hAbs^(3/2)]],
  textCell["Large D means that diffusion randomises the phase faster than nonlinear trapping organises it. Small D means coherent pendulum motion survives and the quasilinear result must be attenuated."],
  sectionCell["6. Two collisionality bounds"],
  textCell["Canonical averaging needs the effective collision frequency to be small compared with the bounce or transit frequency. Quasilinear closure needs enough resonant diffusion to decorrelate phase over a nonlinear super-bounce. Together they define a window rather than the one-sided statement 'low collisionality'."],
  equationCell[HoldForm[nuEffective < omegaBounce]],
  equationCell[HoldForm[dRes > hAbs^(3/2)/Sqrt[omegaPrimeAbs]]],
  textCell["The second inequality is D much greater than one. It becomes a lower bound on collision frequency only after a particular collision model supplies D_res(nu_eff); there is no universal conversion."],
  sectionCell["7. Causal resonance broadening"],
  textCell["For finite nu the delta distribution is a Lorentzian. Its narrowing illustrates why setting nu to zero before integration loses the resonant contribution."],
  outputCell[lorentzianPlot],
  sectionCell["8. Assumptions and boundaries"],
  textCell["The model requires a weak physical harmonic, nonzero detuning slope, separated resonances, slow profile variation across the island and orbit, periodic resonant phase, decay of the perturbed distribution at large |I|, and a physical mechanism for action diffusion. The trapped-passing boundary requires another coordinate treatment because the bounce time diverges there."],
  outputCell[Grid[{{"quantity", "result"}, {"half-width", 2 Sqrt[hAbs/omegaPrimeAbs]}, {"centre frequency", Sqrt[hAbs omegaPrimeAbs]}, {"diffusion time", 2 hAbs/(omegaPrimeAbs dRes)}, {"validity parameter D", dDefinition}}, Frame -> All]]
};

ClearAll[r, nFun, temp, phi0, energy, charge, mass];
maxwellian = nFun[r]/(2 Pi mass temp[r])^(3/2) Exp[-(energy - charge phi0[r])/temp[r]];
maxwellianGradient = FullSimplify[D[maxwellian, r]/maxwellian];
expectedGradient = nFun'[r]/nFun[r] + charge phi0'[r]/temp[r] - 3 temp'[r]/(2 temp[r]) + (energy - charge phi0[r]) temp'[r]/temp[r]^2;
check["Local Maxwellian radial derivative", Simplify[maxwellianGradient - expectedGradient] === 0];

deltaJacobian = Assuming[a > 0, Integrate[DiracDelta[a p], {p, -Infinity, Infinity}]];
check["Delta-function Jacobian", deltaJacobian === 1/a];

thetaAverageMode = Assuming[Element[mMode, Integers] && mMode != 0, Integrate[Exp[I mMode theta], {theta, 0, 2 Pi}]/(2 Pi)];
check["Nonzero angular Fourier mode averages to zero", thetaAverageMode === 0];

fluxForceCheck = Simplify[
  (-Abs[pPrime] sourceIntegral) - pPrime (-Sign[pPrime] sourceIntegral),
  Assumptions -> Element[pPrime, Reals] && pPrime != 0
];
check["Flux-force relation", fluxForceCheck === 0];

liouvilleCheck = Simplify[D[D[hCanonical[xCanonical, pCanonical], pCanonical], xCanonical] + D[-D[hCanonical[xCanonical, pCanonical], xCanonical], pCanonical]];
check["Canonical Hamiltonian flow is incompressible", liouvilleCheck === 0];

angularDivergenceSample = D[Cos[2 theta] + Sin[theta], theta] + D[Sin[3 phi] + Cos[phi], phi];
angularDivergenceAverage = Integrate[angularDivergenceSample, {theta, 0, 2 Pi}, {phi, 0, 2 Pi}]/(2 Pi)^2;
check["Periodic angular divergence averages to zero", angularDivergenceAverage === 0];

ntvEnergy = jPerp omegaC0 (1 + eps bRelative) + mass vParallel0^2 (1 + eps bRelative)^2/2;
ntvFirstOrder = Expand[SeriesCoefficient[ntvEnergy, {eps, 0, 1}]];
ntvExpected = Expand[(jPerp omegaC0 + mass vParallel0^2) bRelative];
check["First-order NTV Hamiltonian expansion", ntvFirstOrder === ntvExpected];

resonanceDecomposition = Expand[m2 omegaBounce + nMode (qSafety deltaTP omegaBounce + omegaTE + omegaTB) - omega];
resonanceExpected = Expand[(m2 + nMode qSafety deltaTP) omegaBounce + nMode (omegaTE + omegaTB) - omega];
check["Tokamak resonance-frequency decomposition", resonanceDecomposition === resonanceExpected];

mirrorPlot = Plot[
  Evaluate[{1/(1 + 0.3 Cos[theta]), 1.18}],
  {theta, -Pi, Pi},
  PlotStyle -> {{Thick, RGBColor[0.1, 0.35, 0.75]}, {Dashed, RGBColor[0.8, 0.15, 0.15]}},
  PlotLegends -> Placed[{"B(theta)/B0", "turning threshold 1/lambda"}, Above],
  Frame -> True,
  FrameLabel -> {"poloidal angle", "normalised field"},
  Filling -> {1 -> {2}},
  FillingStyle -> Directive[Opacity[0.12], RGBColor[0.8, 0.15, 0.15]],
  ImageSize -> 500,
  BaseStyle -> {FontFamily -> "Latin Modern Roman", 13}
];
Export[FileNameJoin[{figureDir, "magnetic_mirror.pdf"}], mirrorPlot];

orbitGraphic = Graphics[
  {
    {Thick, GrayLevel[0.35], Circle[{0, 0}, 1.7]},
    {Directive[Thick, RGBColor[0.1, 0.35, 0.75]], Circle[{0, 0}, 1.36]},
    {Directive[Thick, RGBColor[0.8, 0.15, 0.15]], BezierCurve[{{0.25, -1.1}, {1.15, -0.55}, {1.35, 0}, {1.15, 0.55}, {0.25, 1.1}}], BezierCurve[{{0.25, 1.1}, {-0.05, 0.55}, {-0.05, -0.55}, {0.25, -1.1}}]},
    Text[Style["passing", 13, RGBColor[0.1, 0.35, 0.75]], {-1.05, 1.25}],
    Text[Style["trapped banana", 13, RGBColor[0.8, 0.15, 0.15]], {0.95, 1.38}],
    Arrow[{{-2.1, 0}, {-1.75, 0}}],
    Text[Style["stronger B", 12], {-2.35, 0}],
    Arrow[{{2.1, 0}, {1.75, 0}}],
    Text[Style["weaker B", 12], {2.35, 0}]
  },
  PlotRange -> {{-3, 3}, {-2, 2}},
  ImageSize -> 520,
  BaseStyle -> {FontFamily -> "Latin Modern Roman", 13}
];
Export[FileNameJoin[{figureDir, "trapped_passing_orbits.pdf"}], orbitGraphic];

overlapPlot = Plot[
  Evaluate[{0.7 v - 0.4, 0.7 v - 0.4 + 0.18 (v^2 - 1)}],
  {v, -1.2, 1.7},
  PlotStyle -> {{Thick, RGBColor[0.8, 0.15, 0.15]}, {Thick, RGBColor[0.1, 0.35, 0.75]}},
  PlotLegends -> Placed[{"cylindrical transit resonance", "toroidal resonance with drift"}, Above],
  AxesLabel -> {"parallel velocity", "resonance mismatch"},
  Epilog -> {Directive[Dashed, Gray], Line[{{-1.2, 0}, {1.7, 0}}]},
  ImageSize -> 520,
  BaseStyle -> {FontFamily -> "Latin Modern Roman", 13}
];
Export[FileNameJoin[{figureDir, "model_overlap.pdf"}], overlapPlot];

transportCells = {
  titleCell["From the kinetic equation to radial flux and toroidal torque"],
  textCell["Each reduction in this notebook states the measure, boundary condition, coordinate restriction, or reference choice that makes it valid."],
  sectionCell["1. Local moment equation"],
  textCell["Canonical Hamiltonian flow is incompressible. The kinetic equation can therefore be written as a phase-space divergence. In noncanonical guiding-centre variables, the invariant Jacobian must be retained instead."],
  inputCell[liouvilleCheck],
  outputCell[liouvilleCheck],
  equationCell[HoldForm[D[f, t] + Div[xDot f, xVec] + Div[pDot f, pVec] == Collision[f]]],
  textCell["For an observable a(r,p,t), apply the product rule before integrating. The momentum boundary term vanishes only if a p-dot f decays at infinity. The Hamiltonian source is the total collisionless derivative of a, and the collisional source is its collision moment."],
  equationCell[HoldForm[A[r, t] == Integrate[a[r, p] f[r, p, t], {p, -Infinity, Infinity}]]],
  equationCell[HoldForm[D[A, t] + Div[GammaA, rVec] == sourceHamiltonian + sourceCollision]],
  equationCell[HoldForm[GammaA == Integrate[PoissonBracket[rVec, H] a f, momentumSpace]]],
  equationCell[HoldForm[sourceHamiltonian == Integrate[f (D[a, t] + PoissonBracket[a, H]), momentumSpace]]],
  equationCell[HoldForm[sourceCollision == Integrate[a Collision[f], momentumSpace]]],
  textCell["For a=1, particle conservation additionally requires the collision integral to vanish. Momentum and energy moments require the corresponding conservative multi-species collision operator."],
  sectionCell["2. Flux-surface average"],
  textCell["In static magnetic coordinates, S = integral sqrt(g) dtheta dphi is dV/dr. It is a geometrical area only for an effective radius normalised by <|grad r|>=1. Periodic angular divergences integrate to zero, leaving the radial part. A moving surface would add a Reynolds-transport term."],
  equationCell[HoldForm[AverageFluxSurface[q] == 1/S Integrate[Sqrt[g] q, {theta, -Pi, Pi}, {phi, -Pi, Pi}]]],
  equationCell[HoldForm[D[AverageFluxSurface[A], t] + 1/S D[S AverageFluxSurface[GammaA^r], r] == AverageFluxSurface[sourceHamiltonian + sourceCollision]]],
  inputCell[angularDivergenceAverage],
  outputCell[angularDivergenceAverage],
  sectionCell["3. Particle flux and torque"],
  textCell["A canonical action-angle transformation preserves d^3x d^3p. A spatial delta distribution selects crossings of one flux surface. Set a=1 for particle flux and a=p_phi for toroidal canonical momentum. Hamilton's equation gives p_phi-dot = -partial_phi H."],
  equationCell[HoldForm[GammaN == 1/S Integrate[DiracDelta[rC[thetaVec, jVec] - r] PoissonBracket[r, H] f, thetaSpace, actionSpace]]],
  equationCell[HoldForm[torquePhi == -1/S Integrate[DiracDelta[rC[thetaVec, jVec] - r] D[H, phiCanonical] f, thetaSpace, actionSpace]]],
  sectionCell["4. Thin-orbit flux-force relation"],
  textCell["At lowest order in orbit width, replace the instantaneous radius by a single-valued r_phi(p_phi). Then r_phi-dot=(dr_phi/dp_phi) p_phi-dot pointwise. The same surface selector and distribution occur in flux and torque, so dp_phi/dr_phi can be taken outside the integral."],
  inputCell[deltaJacobian],
  outputCell[deltaJacobian],
  equationCell[HoldForm[D[rPhi, t] == D[rPhi, pPhi] D[pPhi, t]]],
  equationCell[HoldForm[torquePhi == D[pPhi[rPhi], rPhi] GammaN]],
  inputCell[fluxForceCheck],
  outputCell[fluxForceCheck],
  textCell["The displayed sign uses p_phi approximately equal to -e psi_pol/c. It changes with vector-potential, angle, flux, and charge conventions. Finite orbit width breaks the pointwise one-variable mapping."],
  sectionCell["5. Magnetic perturbation Hamiltonian"],
  textCell["Use H_gc = J_perp omega_c + m v_parallel^2/2 + e Phi. At fixed canonical momentum in the distorted-surface Boozer representation, p_theta-e A_theta/c = m v_parallel B_theta/B implies delta v_parallel/v_parallel = delta B/B. Also delta omega_c/omega_c = delta B/B. Expanding the energy then gives the first-order NTV Hamiltonian."],
  equationCell[HoldForm[deltaVParallel == vParallel0 bRelative]],
  equationCell[HoldForm[deltaOmegaC == omegaC0 bRelative]],
  inputCell[ntvFirstOrder],
  outputCell[ntvFirstOrder],
  equationCell[HoldForm[H1 == (jPerp omegaC0 + mass vParallel0^2) bRelative]],
  textCell["This result excludes electrostatic perturbations, topology-changing magnetic terms, and perturbed reference orbits."],
  sectionCell["6. Canonical resonance frequency"],
  textCell["The harmonic phase is Psi=m dot theta-omega t, so its time derivative is m dot Omega-omega. In the chosen tokamak coordinates, the toroidal canonical frequency contains field-line advance for passing particles plus electric and magnetic precession."],
  equationCell[HoldForm[D[PsiSubm, t] == mVec . capitalOmegaVec - omega]],
  equationCell[HoldForm[capitalOmegaPhi == qSafety deltaTP omegaBounce + omegaTE + Average[omegaTB]]],
  inputCell[resonanceDecomposition],
  outputCell[resonanceDecomposition],
  equationCell[HoldForm[(m2 + nMode qSafety deltaTP) omegaBounce + nMode (omegaTE + Average[omegaTB]) - omega == 0]],
  textCell["deltaTP is zero for trapped orbits and one for passing orbits because only a passing transit accumulates the q-times toroidal field-line advance. Sign changes in the canonical angles change the displayed integers but not m dot Omega-omega=0."],
  sectionCell["7. Maxwellian gradients and transport forces"],
  textCell["For profiles evaluated at r_phi, differentiate the local Maxwellian at fixed unperturbed energy. Writing u^2 = (H0-e Phi)/T separates density/electric and temperature forces."],
  inputCell[maxwellianGradient],
  outputCell[maxwellianGradient],
  equationCell[HoldForm[A1 == n'[r]/n[r] + charge Phi'[r]/T[r] - 3 T'[r]/(2 T[r])]],
  equationCell[HoldForm[A2 == T'[r]/T[r]]],
  equationCell[HoldForm[GammaN == -n (D11 A1 + D12 A2)]],
  textCell["At a static resonance m dot Omega=0, the separate energy derivative does not contribute along m. For omega nonzero, energy exchange remains and must be included."],
  sectionCell["8. Quadratic torque scaling"],
  textCell["The quasilinear source contains |H_m|^2. Therefore doubling a fixed-shape perturbation multiplies torque and radial flux by four, provided the ordering and isolated-resonance assumptions remain valid."],
  equationCell[HoldForm[{HSubm -> scale HSubm, QSubm -> scale^2 QSubm, torquePhi -> scale^2 torquePhi}]],
  sectionCell["9. Passing and trapped orbits"],
  textCell["In a circular tokamak B is stronger on the inboard side and weaker on the outboard side. Conservation of magnetic moment gives v_parallel^2 = v^2(1-lambda B). A turning point occurs where lambda B = 1; particles without a turning point pass around the torus, while particles with two turning points form banana orbits."],
  equationCell[HoldForm[vParallel^2 == v^2 (1 - lambda B[theta])]],
  outputCell[mirrorPlot],
  outputCell[orbitGraphic],
  sectionCell["10. NEO-RT versus KiLCA/QL-Balance"],
  textCell["Turning off magnetic drift in the cylindrical KiLCA equation does not remove every passing-particle resonance. Its mismatch remains k_parallel v_parallel + omega_E - omega. NEO-RT uses canonical resonances m2 omega_b + n Omega_phi - omega. Passing-particle branches can overlap after mode and geometry mapping, so the two torques cannot be declared complementary solely from the drift switch."],
  equationCell[HoldForm[deltaKiLCA == kParallel vParallel + omegaE - omega]],
  equationCell[HoldForm[deltaNEORT == m2 omegaBounce + nMode capitalOmegaPhi - omega]],
  outputCell[overlapPlot],
  textCell["The physical expectation discussed in the meeting remains useful: trapped and marginally passing particles often dominate NEO-RT torque. That expectation is not a proof of zero overlap and should be tested mode by mode before adding model outputs."],
  outputCell[Grid[Prepend[checkResults, {"symbolic check", "passed"}], Frame -> All]]
};

saveNotebook["01_ordering_and_averaging", orderingCells];
saveNotebook["02_resonance_and_decorrelation", resonanceCells];
saveNotebook["03_flux_torque_and_orbits", transportCells];

reportPath = FileNameJoin[{notebookDir, "verification.txt"}];
Export[reportPath, StringRiffle[Map[(#[[1]] <> ": " <> If[#[[2]], "PASS", "FAIL"]) &, checkResults], "\n"] <> "\n", "Text"];
If[!And @@ checkResults[[All, 2]], Exit[1]];
