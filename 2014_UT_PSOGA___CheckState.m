function saveGA = CheckState()
load IndexPSO.mat IndexPSO_i;
load IndexGA.mat IndexGA_i;
if isempty(IndexGA_i)
    flagGA = 0;
else
    flagGA = 1;
end
if isempty(IndexPSO_i)
    flagPSO = 0;
else
    flagPSO = 1;
end
if flagGA == 1 && flagPSO == 1
    saveGA = 1;
else
    saveGA = 0;
end