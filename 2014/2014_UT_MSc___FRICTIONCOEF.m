function [XI12 XI13 XI23]=FRICTIONCOEF(ijOMG1,ijOMG2,jIter,iIter)
% This Script evaluates the friction coefficients XIij.
% friction coefficients are evaluate without the RT part.
% Subroutines :::
%               CONSTANTS.m
%               PHIs.m
% help on
% Loading CONSTANTS.m 
[RH03 WM3 V2 V12 FUJD0 FUJA FUJB]=CONSTANTS();
% Loading PHIs.m
% Calculuating ternary volume fractions.
[PHI1 PHI2]=PHIs(ijOMG1,ijOMG2,jIter,iIter);
% Calculuating the self diffusion coefficients from Fujita's experssion. 
D2STAR=FUJD0*exp(PHI2/(FUJA*PHI2+FUJB*(1-PHI1)));
% Calculuating the friction coefficients XIij ... 
XI12=V2/5.03e-5;
XI23=(RH03*WM3)/D2STAR;
% Shojai's C value is 2.05D-08
XI13=2.05e-8*V12*XI23;
end
% End of nested m-file.