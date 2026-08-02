"""Generated SymPy translation of ``corpus/proj-ecnl-gorilla-recovery/equations.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

import hashlib
import json
import re

import sympy as sp

from fortsym_bench.wl_to_sympy import evaluate_assignments


_EQUATION_TEX = {
    "gamma": r"\gamma=\left[1+\frac{p_\parallel^2+2m\Omega I}{m^2c^2}\right]^{1/2},\qquad H_0=mc^2\gamma",
    "resonance": r"\mathcal{R}=\omega-k_\parallel v_\parallel-\frac{s\Omega}{\gamma}=0",
    "wavephase": r"\psi=s\phi+k_\parallel z-\omega t+\psi_0",
    "coupling": r"H_{1s}(I,p_\parallel)=\frac{1}{2\pi}\int_0^{2\pi}\!\mathrm d\phi\,H_1(I,p_\parallel,\phi)e^{-is\phi}",
    "invariants": r"\mathcal{P}=p_\parallel-\frac{k_\parallel}{s}I,\qquad \mathcal{E}=H-\frac{\omega}{s}I",
    "reducedH": r"K(J,\psi)=\frac{a}{2}(J-J_r)^2-b\cos\psi",
    "island": r"\Delta J_{\mathrm{sep}}=2\sqrt{\left|\frac{b}{a}\right|},\qquad \omega_b=\sqrt{|ab|}",
    "nonlinearity": r"\chi=\omega_b\tau_b,\qquad q_c=\nu_c\tau_b,\qquad \epsilon_{\mathrm{NL}}^2\equiv\chi^2",
    "kernel": r"\Gamma_B(z')=\int \mathrm{d}z\,P_{A\to B}(z'|z)\Gamma_A(z),\qquad \int \mathrm{d}z'\,P_{A\to B}(z'|z)=1",
    "markov": r"\Gamma_{n+1}(z')=\int \mathrm{d}z\,P(z'|z)\Gamma_n(z)",
    "moments": r"M_n(z)=\frac{1}{\tau_b}\int \mathrm{d}(\Delta z)\,(\Delta z)^nP(\Delta z|z)",
    "fokkerplanck": r"\frac{\partial f}{\partial t}=-\frac{\partial}{\partial z}(M_1f)+\frac{1}{2}\frac{\partial^2}{\partial z^2}(M_2f)+O(M_3)",
    "phasekick": r"\Delta w=A(w)\sin\psi,\qquad \langle\Delta w\rangle_\psi=0,\qquad \langle(\Delta w)^2\rangle_\psi=\frac{A^2(w)}{2}",
    "diffusion": r"D_{ww}=\frac{M_2}{2}=\frac{A^2(w)}{4\tau_b}",
    "dke": r"\frac{\partial \delta f}{\partial t}+(v_\parallel\mathbf b+\mathbf v_d)\cdot\nabla\delta f+\dot v\,\frac{\partial\delta f}{\partial v}=C[\delta f]-L[\delta f]+S_{\mathrm{RF}}",
    "collision": r"C[f]=\nu_v\frac{1}{v^2}\frac{\partial}{\partial v}\left[v^2\left(vf+\Theta\frac{\partial f}{\partial v}\right)\right]+\frac{\nu_\xi}{2}\frac{\partial}{\partial\xi}\left[(1-\xi^2)\frac{\partial f}{\partial\xi}\right]",
    "maxwell": r"f_M(v)=\mathcal N\exp\left(-\frac{v^2}{2\Theta}\right),\qquad C[f_M]=0",
    "splitting": r"e^{\Delta t(L_o+L_c+L_{\mathrm{RF}})}=e^{\Delta tL_o}e^{\Delta tL_c}e^{\Delta tL_{\mathrm{RF}}}+O(\Delta t^2)",
    "power": r"p_{\mathrm{abs}}(\mathbf x)=\int \mathrm{d}^3v\,f(\mathbf x,\mathbf v)\frac{\langle\Delta E\rangle_{\mathrm{RF}}}{\tau_b}",
    "current": r"j_\parallel(\mathbf x)=-e\int \mathrm{d}^3v\,v_\parallel\delta f(\mathbf x,\mathbf v)",
    "adjoint": r"L^\dagger\chi=-ev_\parallel,\quad L\delta f=S_{\mathrm{RF}}\quad\Longrightarrow\quad j_\parallel=\langle\chi,S_{\mathrm{RF}}\rangle",
    "powerbalance": r"\frac{\mathrm dP_b}{\mathrm dl}=-\int_{A_b(l)}\mathrm dA\,p_{\mathrm{abs}},\qquad P_b(l)+P_{\mathrm{abs}}(0,l)=P_b(0)",
    "wave_momentum": r"\Delta p_\parallel=\frac{k_\parallel}{\omega}\Delta E\quad\text{(single travelling-wave quantum limit)}",
    "radialcurrent": r"j_r^{(e)}=-e\int\mathrm d^3v\,v_{d,r}\delta f,\qquad j_r^{(i)}=-j_r^{(e)}",
    "torque": r"T_\phi^{j\times B}=Rj_r^{(i)}B_\theta,\qquad T_\phi^{\mathrm{coll}}=-R\int\mathrm d^3v\,m_ev_\phi C[\delta f]",
    "fourier": r"Q_{mn}(r)=\frac{1}{(2\pi)^2}\int_0^{2\pi}\!\mathrm d\theta\int_0^{2\pi}\!\mathrm d\phi\,Q(r,\theta,\phi)e^{-i(m\theta-n\phi)}",
    "reconstruct": r"Q^{(1,1)}(r,\theta,\phi)=2\,\mathrm{Re}\left[Q_{11}(r)e^{i(\theta-\phi)}\right]",
    "event": r"(\mathbf X,v_\parallel,\mu,w)_{\mathrm{out}}=\mathcal K_{\mathrm{RF}}\!\left[(\mathbf X,v_\parallel,\mu,w)_{\mathrm{in}};\omega,s,\mathbf k,\mathbf E,\tau_b,\zeta\right]",
    "diagnostics": r"\sum_jP_{ij}=1,\qquad \Delta E_{\mathrm{particles}}+\Delta E_{\mathrm{wave}}=0,\qquad \sigma_{\bar A}^2=\frac{\mathrm{Var}(A)}{N_{\mathrm{eff}}}",
    "regimes": r"\begin{aligned}\chi\ll1&:\;\text{linear/quasilinear},\qquad \chi\sim1:\;\text{finite-crossing nonlinear},\\ \chi\gg1,\;q_c\ll1&:\;\text{adiabatic trapping}\end{aligned}",
    "helicaldecision": r"\mathcal S_{11}=\frac{|j_{\parallel,11}|}{\max(|j_{\parallel,00}|,j_{\mathrm{ref}})},\qquad \Delta\varphi_{11}=\arg j_{\parallel,11}-\arg\xi_{11}",
}


def _string_atom(value):
    literal = json.dumps(value, ensure_ascii=False)
    digest = hashlib.sha256(literal.encode("utf-8")).hexdigest()
    # The comparison normaliser also canonicalises exponent-like text in
    # InputForm identifiers (for example ``e09`` -> ``e9``).
    digest = re.sub(r"([eE][+-]?)0+(\d+)", r"\1\2", digest)
    return sp.Symbol("fortsymString" + digest)


# NOT TRANSLATED: 68 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('root', 'DirectoryName[DirectoryName[$InputFileName]]', ()),
    ('out', 'FileNameJoin[{root, "report", "generated"}]', ()),
]

def results():
    values = evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-ecnl-gorilla-recovery/equations.wl')
    values.update({name: _string_atom(tex) for name, tex in _EQUATION_TEX.items()})
    return values
