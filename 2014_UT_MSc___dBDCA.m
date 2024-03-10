function diffBDCA=dBDCA(dOMG1dz,dOMG2dz,dOMG3dz,ijOMG1,ijOMG2,ijOMG3,jIter,iIter,dz)
% This Script Evaluates Derivatives of Reciprocal BDCA
% Subroutine :::
%              CONSTANTS.m
%              FRICTIONCOEF.m
%              dOMGidz.m
% help on
% Loading CONSTANTS.m
[RH01 RH02 RH03 RH013 RH023 SV1 SV2 SV3 WM1 WM2 WM3]=CONSTANTS();
% Loading dOMGidz.m
[dOMG1dz dOMG2dz dOMG3dz]=dOMGidz(dOMG1dz,dOMG2dz,dOMG3dz,...
    ijOMG1,ijOMG2,ijOMG3,jIter,iIter,dz);
% Loading FRICTIONCOEF.m
[XI12 XI13 XI23]=FRICTIONCOEF(ijOMG1,ijOMG2,jIter,iIter);
% Calculating .... 
DUMMY=(ijOMG1(jIter,iIter)*ijOMG2(jIter,iIter)*WM1*WM2*(WM3^3))^2;
TERM1=ijOMG2(jIter,iIter)*WM1*WM2*(WM3^2);
TERM2=WM1*WM3*XI12*XI23*ijOMG2(jIter,iIter);
TERM3=WM2*WM3*XI13*XI12*ijOMG1(jIter,iIter);
TERM4=WM1*WM2*XI13*XI23*ijOMG3(jIter,iIter);
TERM5=ijOMG1(jIter,iIter)*ijOMG2(jIter,iIter)*WM1*WM2*(WM3^2);
TERM6=WM2*WM3*XI13*XI12;
TERM7=WM1*WM2*XI13*XI23;
TERM8=ijOMG1(jIter,iIter)*WM1*WM2*(WM3^2);
TERM9=WM1*WM3*XI12*XI23*ijOMG2(jIter,iIter);
TERM10=WM2*WM3*XI13*XI12*ijOMG1(jIter,iIter);
TERM11=WM1*WM2*XI12*XI23*ijOMG3(jIter,iIter);
TERM12=ijOMG1(jIter,iIter)*ijOMG2(jIter,iIter)*WM1*WM2*(WM3^2);
TERM13=WM1*WM3*XI12*XI23;
TERM14=WM1*WM2*XI13*XI23;
SENT1=(-TERM1*(TERM2+TERM3+TERM4)+TERM5*(TERM6-TERM7))/DUMMY;
SENT2=(-TERM8*(TERM9+TERM10+TERM11)+TERM12*(TERM13-TERM14))/DUMMY;
diffBDCA=SENT1*dOMG1dz(jIter,iIter)+SENT2*dOMG2dz(jIter,iIter);
end
% End of nested m-file.