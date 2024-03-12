function [DM1O1 DM1O2 DM2O1 DM2O2]=DMiOi(ijOMG1,ijOMG2,jIter,iIter)
% Calculates the gradient of chemical potentials w.r.t. mass frac.
% the gradients will be evaluated without the RT part
% Subroutines :::
%               FGcomponents.m
%               dPHIs.m
% help on
% Loading FGcomponents.m
[Q1 Q2 S1 S2]=FGcomponents(ijOMG1,ijOMG2,jIter,iIter);
% Loading dPHIs.m
[DP1O1 DP2O1 DP1O2 DP2O2]=dPHIs(ijOMG1,ijOMG2,jIter,iIter);
% Calculating ....
DM1O1=Q1*DP1O1+Q2*DP2O1;
DM1O2=Q1*DP1O2+Q2*DP2O2;
DM2O1=S1*DP1O1+S2*DP2O1;
DM2O2=S1*DP1O2+S2*DP2O2;
end
% End of nested m-file.