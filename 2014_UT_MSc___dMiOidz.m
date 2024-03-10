function [dDM1O1dz dDM1O2dz dDM2O1dz ...
    dDM2O2dz]=dMiOidz(ijOMG1,ijOMG2,jIter,iIter,dz)
% This Script evaluates the derivatives of dmidwi / dz
% Subroutine :::
%               DMiOi.m
% help on
% Pre-allocation
Temp1=zeros(2,1);
Temp2=zeros(2,1);
Temp3=zeros(2,1);
Temp4=zeros(2,1);
for ii=1:2
    jIter=jIter+ii-2;
    % Loading DMiOi.m 
    [DM1O1 DM1O2 DM2O1 DM2O2]=DMiOi(ijOMG1,ijOMG2,jIter,iIter);
    Temp1(ii)=DM1O1;
    Temp2(ii)=DM1O2;
    Temp3(ii)=DM2O1;
    Temp4(ii)=DM2O2;
end
% Calculating ....
dDM1O1dz=(Temp1(2)-Temp1(1))/dz;
dDM1O2dz=(Temp2(2)-Temp2(1))/dz;
dDM2O1dz=(Temp3(2)-Temp3(1))/dz;
dDM2O2dz=(Temp4(2)-Temp4(1))/dz;
end
% End of nested mfile.