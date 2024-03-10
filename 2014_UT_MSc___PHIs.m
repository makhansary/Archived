function [PHI1 PHI2 PHI3]=PHIs(ijOMG1,ijOMG2,jIter,iIter)
% This Script Evaluates the volume fractions from mass fractions
% Subroutines :::
%               CONSTANTS.m
% help on
% Loading CONSTANTS.m
[ETA LAMBDA GAMMA ALPHA BETA]=CONSTANTS();
% Calculuating the volume fractions from mass fractions (PHI)
DUMMY=ALPHA*ijOMG1(jIter,iIter)+BETA*ijOMG2(jIter,iIter)+GAMMA;
PHI1=ETA*ijOMG1(jIter,iIter)/DUMMY;
PHI2=LAMBDA*ijOMG2(jIter,iIter)/DUMMY;
PHI3=GAMMA*(1-ijOMG1(jIter,iIter)-ijOMG2(jIter,iIter))/DUMMY;
end
% End of nested m-file.