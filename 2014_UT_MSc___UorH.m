function [U1 U2]=UorH(ijOMG1,ijOMG2,jIter,iIter)
% This Scripts Evaluates the Value of u/h binary 12 volume fractions from
% ternary volume fractions
% Subroutine :::
%               INITIALS.m
%               PHIs.m
% help on
% Loading INITIALS.m
[UTOP1 UTOP2]=INITIALS();
% Loading PHIs.m
[PHI1 PHI2]=PHIs(ijOMG1,ijOMG2,jIter,iIter);
% Calculuating binary 12 volume fractions from ternary volume fractions
U1=PHI1/(PHI1+PHI2);
U2=PHI2/(PHI1+PHI2);
if U1>UTOP1 || U2>UTOP2
    U1=UTOP1;
    U2=UTOP2;
end
end
% End