function [F1 F2 G1 G2]=COEFFICIENTS(ijOMG1,ijOMG2,ijOMG3,jIter,iIter)
% This Script calculates the coefficients of the PDE.  
% f1, f2, g1, g2.
% Subroutins :::
%               PHIs.m
%               DMiOi.m
%               BDCA.m
%               ABCD.m
% help on
%
% Loading PHIs.m
[PHI1 PHI2 PHI3]=PHIs(ijOMG1,ijOMG2,jIter,iIter);
% Checking Phis
if PHI1<0 || PHI2<0 || PHI3<0
    F1=0;
    F2=0;
    G1=0;
    G2=0;
else
    % Sum of the derivatives w.r.t. mass fractions is zero ? IF NOT?!!!!!
	%SUMO1=DP1O1+DP2O1;
	%SUMO2=DP1O2+DP2O2;
    % Loading DMiOi.m
    [DM1O1 DM1O2 DM2O1 DM2O2]=DMiOi(ijOMG1,ijOMG2,jIter,iIter);
	% Loading BDCA.m
    CF12G12=BDCA(ijOMG1,ijOMG2,ijOMG3,jIter,iIter);
    % Loading ABCD.m
    [A B C D]=ABCD(ijOMG1,ijOMG2,jIter,iIter);
    % Calculuating the functions F1, G1, H1, F2, and G2.
    F1=CF12G12*(C*DM1O1+B*DM2O1);
    F2=CF12G12*(D*DM1O1+A*DM2O1);
    G1=CF12G12*(C*DM1O2+B*DM2O2);
    G2=CF12G12*(D*DM1O2+A*DM2O2);
end
end
% End of nested m-file.