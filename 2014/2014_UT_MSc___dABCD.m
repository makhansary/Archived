function [dA dB dC dD]=dABCD(dOMG1dz,dOMG2dz,dOMG3dz,...
    ijOMG1,ijOMG2,ijOMG3,jIter,iIter,dz)
% This Scriptes Evaluates Derivatives of A, B, C, D / dz
% Subroutins :::
%               CONSTANTS.m
%               FRICTIONCOEF.m
%               dOMGidz.m
% help on
% Loading CONSTANTS.m
[WM1 WM2 WM3]=CONSTANTS();
% Loading FRICTIONCOEF.m
[XI12 XI13 XI23]=FRICTIONCOEF(ijOMG1,ijOMG2,jIter,iIter);
% Loading dOMGidz.m
[dOMG1dz dOMG2dz dOMG3dz]=dOMGidz(dOMG1dz,dOMG2dz,dOMG3dz,...
    ijOMG1,ijOMG2,ijOMG3,jIter,iIter,dz);
% Calculating ...
dA=(-(XI12*ijOMG2(jIter,iIter)/WM2+XI13*(1-ijOMG1(jIter,iIter))...
    /WM3)/(ijOMG1(jIter,iIter)))*dOMG1dz(jIter,iIter)+...
    dOMG2dz(jIter,iIter)*(XI12/WM2-XI13/WM3)/ijOMG1(jIter,iIter);
dB=0;
dC=(XI12/ijOMG2(jIter,iIter)/WM1-XI23/ijOMG2(jIter,iIter)/WM3)...
    *dOMG1dz(jIter,iIter)-((ijOMG1(jIter,iIter)*XI12/WM1+...
    (1-ijOMG1(jIter,iIter))*XI23/WM3)/(ijOMG2(jIter,iIter)^2))...
    *dOMG2dz(jIter,iIter);
dD=0;
end
% End of nested m-file.