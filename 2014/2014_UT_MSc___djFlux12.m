function [djFlux1 djFlux2]=djFlux12(d2OMG1dz,d2OMG2dz,...
    dOMG1dz,dOMG2dz,dOMG3dz,ijOMG1,ijOMG2,ijOMG3,jIter,iIter,dz,dzz)
% This Script Evaluates the Right side of Eq. 10 and 11
% Subroutines :::
%               dOMGidz.m
%               d2OMGidz2.m
%               COEFFICIENTS.m
%               dFiGidz.m
% help on
% Loading dOMGidz.m for dw1dz, dw2dz, dw3dz
[dOMG1dz dOMG2dz dOMG3dz]=dOMGidz(dOMG1dz,dOMG2dz,dOMG3dz,...
    ijOMG1,ijOMG2,ijOMG3,jIter,iIter,dz);
% Loading d2OMGidz2.m for d2w1dz, d2w2dz, d2w3dz
[d2OMG1dz d2OMG2dz]=d2OMGidz2(d2OMG1dz,d2OMG2dz,...
    ijOMG1,ijOMG2,ijOMG3,jIter,iIter,dz,dzz);
% Loading COEFFICIENTS.m for F1, F2, G1, G2
[F1 F2 G1 G2]=COEFFICIENTS(ijOMG1,ijOMG2,ijOMG3,jIter,iIter);
% Loading dFiGidz.m
[dF1dz dG1dz dF2dz dG2dz]=dFiGidz(dOMG1dz,dOMG2dz,dOMG3dz,...
    ijOMG1,ijOMG2,ijOMG3,jIter,iIter,dz);
% Calculating dj1, dj2
djFlux1=dF1dz*dOMG1dz(jIter,iIter)+dG1dz*dOMG2dz(jIter,iIter)...
    +F1*d2OMG1dz(jIter,iIter)+G1*d2OMG2dz(jIter,iIter);
djFlux2=dF2dz*dOMG1dz(jIter,iIter)+dG2dz*dOMG2dz(jIter,iIter)...
    +F2*d2OMG1dz(jIter,iIter)+G2*d2OMG2dz(jIter,iIter);
if djFlux1==0 || djFlux2==0
    djFlux1=2.5e-4;
    djFlux2=2.5e-4;
end
end
% End of nested m-file.