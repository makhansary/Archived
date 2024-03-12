function RHO=DENSTY(ijOMG1,ijOMG2,jIter,iIter)
% This Script calculates the density of the solutions using the equation of
% state
% Subroutine :::
%               CONSTANTS.m
[RH01 RH02 RH03 RH013 RH023]=CONSTANTS();
% Calculating ...
TERM1=-RH013/(RH01*RH03);
TERM2=-RH023/(RH02*RH03);
rRHO=ijOMG1(jIter,iIter)*TERM1+ijOMG2(jIter,iIter)*TERM2+(1/RH03);
RHO=1/rRHO;
end
% End of nested m-file.