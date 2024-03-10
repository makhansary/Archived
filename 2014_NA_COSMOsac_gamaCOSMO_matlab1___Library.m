function [NUMSEGMENT VolCavity AreaCavity ...
    Charge Area ChargePerArea Potential ...
    POSXAU POSYAU POSZAU]=Library(Char)
% Reads data from inputQM.xlsx for Compound in sheet "Char"
NUMSEGMENT=xlsread('inputQM.xlsx',Char,'L2');
VolCavity=xlsread('inputQM.xlsx',Char,'L3');
AreaCavity=xlsread('inputQM.xlsx',Char,'L4');
EndPOSXAU=['C' num2str(NUMSEGMENT+4)];
EndPOSYAU=['D' num2str(NUMSEGMENT+4)];
EndPOSZAU=['E' num2str(NUMSEGMENT+4)];
EndCharge=['F' num2str(NUMSEGMENT+4)];
EndArea=['G' num2str(NUMSEGMENT+4)];
EndChargePerArea=['H' num2str(NUMSEGMENT+4)];
EndPotential=['I' num2str(NUMSEGMENT+4)];
% 
POSXAU=xlsread('inputQM.xlsx',Char,['C4' ':' EndPOSXAU]);
POSYAU=xlsread('inputQM.xlsx',Char,['D4' ':' EndPOSYAU]);
POSZAU=xlsread('inputQM.xlsx',Char,['E4' ':' EndPOSZAU]);
% 
Charge=xlsread('inputQM.xlsx',Char,['F4' ':' EndCharge]);
Area=xlsread('inputQM.xlsx',Char,['G4' ':' EndArea]);
ChargePerArea=xlsread('inputQM.xlsx',Char,['H4' ':' EndChargePerArea]);
Potential=xlsread('inputQM.xlsx',Char,['I4' ':' EndPotential]);
end