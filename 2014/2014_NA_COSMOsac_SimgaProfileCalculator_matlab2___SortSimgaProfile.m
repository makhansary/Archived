function [SigmaDensity SigmaProfile]=SortSimgaProfile(SigmaNEW,Area)
% Sorts the Sigma Profile
SigmaDensity = -0.025:1e-3:0.025;
SigmaProfile = zeros(length(SigmaDensity),1)';
%
for idPart=1:length(SigmaDensity)-1
    [dummy idParSigmaNEW]=find(SigmaNEW>SigmaDensity(idPart) & SigmaNEW<SigmaDensity(idPart+1));
    TempData=abs(SigmaNEW(idParSigmaNEW)-SigmaNEW(idParSigmaNEW+1)).*...
        Area(idParSigmaNEW);
    SigmaProfile(idPart)=sum(TempData);
end
end
