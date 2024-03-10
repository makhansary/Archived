function [RH01 RH02 RH03 RH013 RH023 SV1 SV2 SV3 WM1 WM2 WM3 ...
    V1 V2 V3 R V12 V21 V13 V23 ETA LAMBDA GAMMA ALPHA BETA ...
    FUJD0 FUJA FUJB]=CONSTANTS()
% All Constants are provided in This Script.
% component densities (g/cm^3) 
RH01=1.0;
RH02=0.7857;
RH03=1.31;
%
RH013=RH01-RH03;
RH023=RH02-RH03;
% the specific volumes (cm^3/g) 
SV1=1/RH01;
SV2=1/RH02;
SV3=1/RH03;
% Molecular weights (g/mole) 
WM1=18.0;
WM2=58.08;
WM3=40000.0;
%
V1=SV1*WM1;
V2=SV2*WM2;
V3=SV3*WM3;
% universal gas constant(cm3.atm/K.mol)
R=82.05746;
% pure molar volume ratios
V12=V1/V2;
V21=V2/V1;
V13=V1/V3;
V23=V2/V3;
% ratios of pure molar volumes to molecular weights
ETA=V1/WM1;
LAMBDA=V2/WM2;
GAMMA=V3/WM3;
ALPHA=ETA-GAMMA;
BETA=LAMBDA-GAMMA;
% parameters in Fujita's expression (self diffusion coefficients)
FUJD0=7.70133e-17;
FUJA=3.35087e-2;
FUJB=3.37608e-3;
end
% End of nested m-file.