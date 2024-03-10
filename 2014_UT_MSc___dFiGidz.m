function [dF1dz dG1dz dF2dz dG2dz]=dFiGidz(dOMG1dz,dOMG2dz,dOMG3dz,...
    ijOMG1,ijOMG2,ijOMG3,jIter,iIter,dz)
% This Script Calculates the derivatives of A, B, C, D / dz
% Subroutines :::
%               ABCD.m
%               dABCD.m
%               DMiOi.m
%               BDCA.m
%               dBDCA.m
%               dMiOidz.m
% help on
% Loading ABCD.m
[A B C D]=ABCD(ijOMG1,ijOMG2,jIter,iIter);
% Loading dABCD.m
[dA dB dC dD]=dABCD(dOMG1dz,dOMG2dz,dOMG3dz,...
    ijOMG1,ijOMG2,ijOMG3,jIter,iIter,dz);
% Loading DMiOi.m
[DM1O1 DM1O2 DM2O1 DM2O2]=DMiOi(ijOMG1,ijOMG2,jIter,iIter);
% Loading BDCA.m
CF12G12=BDCA(ijOMG1,ijOMG2,ijOMG3,jIter,iIter);
% Loading dBDCA.m
diffBDCA=dBDCA(dOMG1dz,dOMG2dz,dOMG3dz,ijOMG1,ijOMG2,ijOMG3,jIter,iIter,dz);
% Loading dMiOidz.m
[dDM1O1dz dDM1O2dz dDM2O1dz ...
    dDM2O2dz]=dMiOidz(ijOMG1,ijOMG2,jIter,iIter,dz);
% Calculating ...
dF1dz=diffBDCA*(C*DM1O1+B*DM2O1)+...
    CF12G12*(C*dDM1O1dz+DM1O1*dC+B*dDM2O1dz+dB*DM2O1);
dG1dz=diffBDCA*(C*DM1O2+B*DM2O2)+...
    CF12G12*(C*dDM1O2dz+DM1O2*dC+B*dDM2O2dz+dB*DM2O2);
dF2dz=diffBDCA*(D*DM1O1+A*DM2O1)+...
    CF12G12*(D*dDM1O1dz+DM1O1*dD+A*dDM2O1dz+dA*DM2O1);
dG2dz=diffBDCA*(D*DM1O2+A*DM2O2)+...
    CF12G12*(D*dDM1O2dz+DM1O2*dD+A*dDM2O2dz+dA*DM2O2);
end
% End of nested m-file.