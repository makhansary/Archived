function [DP1O1 DP2O1 DP1O2 DP2O2]=dPHIs(ijOMG1,ijOMG2,jIter,iIter)
% Calculuate derivatives of ternary volume frac w.r.t. mass frac.
% Sunroutine :::
%               CONSTANTS.m
% help on
% Loading CONSTANTS.m
[ETA LAMBDA GAMMA ALPHA BETA]=CONSTANTS();
% Calculating ....
ABODON=GAMMA+ALPHA*ijOMG1(jIter,iIter)+BETA*ijOMG2(jIter,iIter); % Dominator of PHI
DP1O1=ETA*(BETA*ijOMG2(jIter,iIter)+GAMMA)/(ABODON^2);
DP2O1=-LAMBDA*ijOMG2(jIter,iIter)*ALPHA/(ABODON^2);
DP1O2=-ETA*ijOMG1(jIter,iIter)*BETA/(ABODON^2);
DP2O2=LAMBDA*(ALPHA*ijOMG1(jIter,iIter)+GAMMA)/(ABODON^2);
end
% End of m-file.