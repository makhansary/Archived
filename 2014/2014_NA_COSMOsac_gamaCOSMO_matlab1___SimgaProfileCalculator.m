function [SigmaDensity SigmaProfile VolCavity]=SimgaProfileCalculator(Char)
% [SigmaDensity SigmaProfile]=SimgaProfileCalculator()
REFF = 0.81764200000000;
%Char=input('Enter sheet name contains data and press enter = ','s');
[NUMSEGMENT VolCavity AreaCavity ...
    Charge Area ChargePerArea Potential ...
    POSXAU POSYAU POSZAU]=Library(Char);
[POSXA POSYA POSZA RAD]=ConvertAU2A(POSXAU,POSYAU,POSZAU,Area);
Sigma=ChargePerArea;
SigmaNEW=zeros(NUMSEGMENT,1);
NormSum=zeros(NUMSEGMENT,1);
for i=1:NUMSEGMENT
    SigmaNEW(i)=0;
    NormSum(i)=0;
    for j=1:NUMSEGMENT
        diffPOSXA=POSXA(j)-POSXA(i);
        diffPOSYA=POSYA(j)-POSYA(i);
        diffPOSZA=POSZA(j)-POSZA(i);
        Term1=sqrt(diffPOSXA^2+diffPOSYA^2+diffPOSZA^2);
        Term2=Sigma(j)*((RAD(j)^2*REFF^2)/(RAD(j)^2+REFF^2)).*...
            exp(-Term1^2/((RAD(j)^2+REFF^2)));
        Term3=(RAD(j)^2*REFF^2*(RAD(j)^2+REFF^2))*...
            exp(-Term1^2/(RAD(j)^2+REFF^2));
        SigmaNEW(i)=SigmaNEW(i)+Term2;
        NormSum(i)= NormSum(i)+Term3;
    end
    SigmaNEW(i)=SigmaNEW(i)/NormSum(i);
end
[SigmaDensity SigmaProfile]=SortSimgaProfile(SigmaNEW,Area);
end