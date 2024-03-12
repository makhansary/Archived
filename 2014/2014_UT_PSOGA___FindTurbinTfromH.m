function Out = FindTurbinTfromH(H,guess,P,CHAR,mDot,MW)
% Calculated T from H, P data
R=8.314; %cm3bar/moleK
id = 1;
for i = guess : guess+50
	TEMP (id) = i;
	[igCp298 IntegralOverT] = CpEnthalpy(i,CHAR);
	HRes = HResidual(i,P,CHAR);
    H=HRes+ (igCp298*298+IntegralOverT)*R; % J/moleK
    molT = mDot * 1000 / MW; % Kg > mole
    H=H*molT; % J
	Hi(id)=H;
	id = id + 1;
end
d = (H - Hi) / H; % AARD 
[MIN, indexx] = min(abs(d)); % minimum error
%indexx = find (abs(d) == MIN);
Out = TEMP (indexx);
end
