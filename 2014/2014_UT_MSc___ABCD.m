function [A B C D]=ABCD(ijOMG1,ijOMG2,jIter,iIter)
% This Script Calculates various parts of Fi, Gi.
% Subroutines :::
%               CONSTANTS.m
%               FRICTIONCOEF.m
% help on
% Loading CONSTANTS.m
[WM1 WM2 WM3]=CONSTANTS();
% Loading FRICTIONCOEF.m
[XI12 XI13 XI23]=FRICTIONCOEF(ijOMG1,ijOMG2,jIter,iIter);
% Calculating ...
A=ijOMG2(jIter,iIter)*XI12/(WM2*ijOMG1(jIter,iIter))...
    +XI13*(1-ijOMG2(jIter,iIter))/(WM3*ijOMG1(jIter,iIter));
B=XI12/WM2-XI13/WM3;
C=ijOMG1(jIter,iIter)*XI12/(WM1*ijOMG2(jIter,iIter))...
    +XI23*(1-ijOMG1(jIter,iIter))/(WM3*ijOMG2(jIter,iIter));
D=XI12/WM1-XI23/WM3;
end
% End of nested m-file.