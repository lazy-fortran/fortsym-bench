Get["VectorAnalysis`"]

Get["VectorAnalysis`"]

Needs["VectorAnalysis`"]; 

Needs["VectorAnalysis`"]; 

CoordinateSystem

SetCoordinates[Cylindrical]

SetCoordinates[Cylindrical[r, φ, z]]

{CoordinateSystem, Coordinates[]}

SetCoordinates[Spherical[r, θ, φ]]

SetCoordinates[Paraboloidal[μ, ν, φ]]

SetCoordinates[Cylindrical[r, φ, z]]

CoordinatesToCartesian[{r, φ, z}]

CoordinatesToCartesian[{5., N[Pi]/3., 2.}]

{5.*Cos[N[Pi]/3.], 5.*Sin[N[Pi]/3.], 2.}

CoordinatesFromCartesian[{x, y, z}]

CoordinatesFromCartesian[{1., 1., 2}]

N[Pi]/4.

CoordinatesToCartesian[{r, ϑ, φ}, Spherical]

CoordinatesFromCartesian[{x, y, z}, Spherical]

CoordinatesToCartesian[{μ, ν, ψ}, Paraboloidal]

CoordinatesFromCartesian[{x, y, z}, Paraboloidal]

SetCoordinates[Cylindrical[r, φ, z]]

a . b

DotProduct[a, b]

DotProduct[a, b, Cartesian]

DotProduct[a, b, Cylindrical]

DotProduct[a, b, Spherical]

CrossProduct[a, b, Cartesian]

CrossProduct[a, b]

CrossProduct[a, b, Cylindrical]

ScalarTripleProduct[a, b, c, Cartesian]

ScalarTripleProduct[a, b, c]

Needs["VectorAnalysis`"]; 

SetCoordinates[Cylindrical[r, φ, z]]

Grad[ψ[r, φ, z]]

Grad[ψ[r, ϑ, φ], Spherical[r, ϑ, φ]]

Clear[a, b, c]; a = {ar[r, φ, z], aφ[r, φ, z], az[r, φ, z]}; 

Expand[Div[a]]

Expand[Curl[a]]

Expand[Laplacian[ψ[r, φ, z]]]

Expand[Grad[Div[a]] - Curl[Curl[a]]]

Simplify[Laplacian[a] - %]

Needs["VectorAnalysis`"]

SetCoordinates[Cylindrical[r, φ, z]]

SetCoordinates[Paraboloidal[μ, ν, ψ]]

(* UNCONVERTED CELL *)

CoordinateRanges[]

ParameterRanges[]

SetCoordinates[ProlateSpheroidal[]]

(* UNCONVERTED CELL *)

Clear[a]; SetCoordinates[ProlateSpheroidal[η, θ, ψ, a]]

CoordinateRanges[]

ParameterRanges[]

CoordinatesToCartesian[{η, θ, ψ}]

SetCoordinates[Bipolar]

SetCoordinates[Bipolar[u, v, z, a]]

ParameterRanges[]

CoordinateRanges[]

CoordinatesToCartesian[{u, v, z}]

CoordinatesFromCartesian[{x, y, z}]

CoordinatesToCartesian[{0.2*N[Pi/2], 0.7*N[Pi/2], 0}]

CoordinatesFromCartesian[{1.86, 0.43, z}]

SetCoordinates[ConfocalEllipsoidal[λ, μ, ν]]

CoordinateRanges[]

CoordinatesToCartesian[{λ, μ, ν}]

ParameterRanges[]

Clear[x, y, z]*SetCoordinates[Cartesian[x, y, z]]

ArcLengthFactor[{x, y, z}, t]

ArcLengthFactor[{r, φ, z}, t, Cylindrical]

ArcLengthFactor[{r, θ, φ}, t, Spherical]

screw = {5*Cos[t], 5*Sin[t], 3*t}; 

Integrate[ArcLengthFactor[screw, t, Cartesian], {t, 0, 2*Pi}]

kreis = {1, t, 0}; 

Integrate[ArcLengthFactor[kreis, t, Cylindrical], {t, 0, 2*Pi}]

kreis = {a, t, 0}; SetAttributes[a, Constant]

Integrate[ArcLengthFactor[kreis, t, Cylindrical], {t, 0, 2*Pi}]

ScaleFactors[Cylindrical[r, φ, z]]

ScaleFactors[Spherical]

MatrixForm[JacobianMatrix[Cylindrical[r, φ, z]]]

JacobianDeterminant[Cylindrical]

SetCoordinates[Spherical[r, θ, φ]]; 

jm = JacobianMatrix[]; MatrixForm[jm]

JacobianDeterminant[]

Integrate[JacobianDeterminant[], {r, 0, a}, {θ, 0, Pi}, {φ, 0, 2*Pi}]

Needs["VectorAnalysis`"]

SetCoordinates[Cylindrical[r, φ, z]]

a = {0, 0, 1}; 

(* UNCONVERTED CELL *)

Div[m]

c = Expand[Curl[Curl[m]] - k^2*m]

Simplify[c[[1]]]

(* UNCONVERTED CELL *)

FullForm[rps]

(* UNCONVERTED CELL *)

drsps = Flatten[D[sps, r]]

dpsps = Flatten[D[sps, φ]]

dzsps = Flatten[D[sps, z]]

dsps = Join[drsps, dpsps, dzsps]; 

Expand[c[[1]] /. dsps]

Together[c[[2]] /. dsps]

Together[c[[3]] /. dsps]

Together[c /. dsps]

(* UNCONVERTED CELL *)

c = Expand[Curl[Curl[n]] - k^2*n]

ddsps = Flatten[Union[D[sps, r, r], D[sps, φ, φ], D[sps, z, z], D[sps, r, φ], D[sps, φ, z], D[sps, r, z], dsps]]; 

Together[c /. ddsps]

l = Grad[ψ[r, φ, z]]

Curl[l]

c = Grad[Div[l]] + k^2*l; 

Expand[c /. dsps]
