function VEL=VELOCITY(dOMG1dz,dOMG2dz,dOMG3dz,...
    ijOMG1,ijOMG2,ijOMG3,jIter,iIter,dz)
% This Script Evaluates the Value of Velocity @ Each Mesh Point
% Subroutines :::
%               CONSTANTS.m
%               dOMGidz.m
%               COEFFICIENTS.m
%
% help on
% Loading CONSTANTS.m
[RH01 RH02 RH03 RH013 RH023]=CONSTANTS();
% Loading dOMGidz.m
[dOMG1dz dOMG2dz dOMG3dz]=dOMGidz(dOMG1dz,dOMG2dz,dOMG3dz,...
    ijOMG1,ijOMG2,ijOMG3,jIter,iIter,dz);
% Loading COEFFICIENTS.m
[F1 F2 G1 G2]=COEFFICIENTS(ijOMG1,ijOMG2,ijOMG3,jIter,iIter);
% Calculation ....
TERM1=F1*dOMG1dz(jIter,iIter)+G1*dOMG2dz(jIter,iIter);
TERM2=F2*dOMG1dz(jIter,iIter)+G2*dOMG2dz(jIter,iIter);
% Velocity
VEL=(RH013/(RH01*RH03))*TERM1+(RH023/(RH02*RH03))*TERM2;
if VEL==0
    VEL=-1e-2;
end
end
% End of nested m-file.