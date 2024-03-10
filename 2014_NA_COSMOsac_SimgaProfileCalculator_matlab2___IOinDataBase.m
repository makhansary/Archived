function [NUMSEGMENT VolCavity AreaCavity ...
    Charge Area ChargePerArea Potential ...
    POSXAU POSYAU POSZAU]=IOinDataBase(Char)
% Reads data from IOinDataBase.xlsx for Compound in sheet "Char"
NUMSEGMENT=xlsread('IOinDataBase.xlsx',Char,'L2');
VolCavity=xlsread('IOinDataBase.xlsx',Char,'L3');
AreaCavity=xlsread('IOinDataBase.xlsx',Char,'L4');
EndPOSXAU=['C' num2str(NUMSEGMENT+4)];
EndPOSYAU=['D' num2str(NUMSEGMENT+4)];
EndPOSZAU=['E' num2str(NUMSEGMENT+4)];
EndCharge=['F' num2str(NUMSEGMENT+4)];
EndArea=['G' num2str(NUMSEGMENT+4)];
EndChargePerArea=['H' num2str(NUMSEGMENT+4)];
EndPotential=['I' num2str(NUMSEGMENT+4)];
%
POSXAU=xlsread('IOinDataBase.xlsx',Char,['C4' ':' EndPOSXAU]);
POSYAU=xlsread('IOinDataBase.xlsx',Char,['D4' ':' EndPOSYAU]);
POSZAU=xlsread('IOinDataBase.xlsx',Char,['E4' ':' EndPOSZAU]);
% 
Charge=xlsread('IOinDataBase.xlsx',Char,['F4' ':' EndCharge]);
Area=xlsread('IOinDataBase.xlsx',Char,['G4' ':' EndArea]);
ChargePerArea=xlsread('IOinDataBase.xlsx',Char,['H4' ':' EndChargePerArea]);
Potential=xlsread('IOinDataBase.xlsx',Char,['I4' ':' EndPotential]);
end