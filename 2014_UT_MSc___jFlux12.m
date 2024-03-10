function JJ=jFlux12(ijOMG1,ijOMG2,ijOMG3,dOMG1dz,dOMG2dz,jIter,iIter)
% This Script Evaluates the Values of j1 and j2
% Subroutine :::
%               COEFFICIENTS.m
% help on
% Loading COEFFICIENTS.m
[F1 F2 G1 G2]=COEFFICIENTS(ijOMG1,ijOMG2,ijOMG3,jIter,iIter);
% Calculating ...
j1=F1*dOMG1dz(jIter,iIter)+G1*dOMG2dz(jIter,iIter);
j2=F2*dOMG1dz(jIter,iIter)+G2*dOMG2dz(jIter,iIter);
if j1==0 || j2==0
    j1=2.5e-3;
    j2=2.5e-3;
end
JJ=[j1 j2];
end
% End of nested m-file.