function CF12G12=BDCA(ijOMG1,ijOMG2,ijOMG3,jIter,iIter)
% Reciprocal of (BD-CA) by Dr. Aroon; Coefficient of F1, F2, G1, G2.
% Subroutins :::
%               CONSTANTS.m
%               FRICTIONCOEF.m
% help on
% Loading CONSTANTS.m
[WM1 WM2 WM3]=CONSTANTS();
% Loading FRICTIONCOEF.m
[XI12 XI13 XI23]=FRICTIONCOEF(ijOMG1,ijOMG2,jIter,iIter);
% Calculating ...
TERM1=ijOMG1(jIter,iIter)*ijOMG2(jIter,iIter)*WM1*WM2*(WM3^3);
TERM2=WM1*WM3*XI12*XI23*ijOMG2(jIter,iIter);
TERM3=WM2*WM3*XI13*XI12*ijOMG1(jIter,iIter);
TERM4=WM1*WM2*XI13*XI23*ijOMG3(jIter,iIter);
CF12G12=TERM1/(TERM2+TERM3+TERM4);
end
% End of nested m-file.