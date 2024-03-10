function [G12 G23 G13 DG12 DG23 DG13 DDG12 ...
    DDG23 DDG13]=FLORYHOGGINSCOEFF(ijOMG1,ijOMG2,jIter,iIter)
% this Script calculates the Flory-Huggins interactions parameters and
% their various derivatives.
% Subroutines :::
%               PHIs.m
%               UorH.m
% help on
% Loading PHIs.m
[PHI1 PHI2 PHI3]=PHIs(ijOMG1,ijOMG2,jIter,iIter);
% Loading UorH.m
[U1 U2]=UorH(ijOMG1,ijOMG2,jIter,iIter);
% for Ternary (polymer/solent/nonsolvent) system
G12=0.661+(0.417/(1-(U2*0.755)));
G23=0.535+0.11*PHI3;
G13=1.4;
% d
DG12=0.417*0.755/((1-U2*0.755)^2);
DG23=0.11;
DG13=0;
% d2
DDG12=(2*0.755/(1-U2*0.755))*DG12;
DDG23=0;
DDG13=0;
end
% End of nested m-file.