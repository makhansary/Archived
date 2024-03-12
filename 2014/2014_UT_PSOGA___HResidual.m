function HRes = HResidual(T,P, Mixture)
% calculates H residual
switch Mixture 
    case 'air'
		output1 = Air();
		output2 = H2O();
        output1 = output1(1:length(output2));
		output= output1*(1-0.38)+0.38*output2; 
		Omega = output(2);
		Tc = output(3);
		Pc = output(4);
    case 'fuel'
        [Omega Tc Pc] = Fuel();
    case 'combustionOUT' 
        % > call to conversion for xi
        %load xTemp.mat;
        load xTemp.mat CombustionOutXc CombustionOutXH2O CombustionOutXO2 CombustionOutXN2;
        % 
        output1 = CO2();
        output2 = H2O();
        output3 = O2();
        output4 = N2();
        output=CombustionOutXc*output1+CombustionOutXH2O*output2+...
            CombustionOutXO2*output3+CombustionOutXN2*output4;
        Omega = output(2);
		Tc = output(3);
		Pc = output(4);
    case 'turbinIN' 
        % > call to conversion for xi
        %load xTemp.mat;
        load xTurbineTemp.mat TurbineINxCO2 TurbineINxH2O TurbineINxN2Ar TurbineINxO2;
        % 
        output1 = CO2();
        output2 = H2O();
        output3 = O2();
        output4 = N2();
        output=TurbineINxCO2*output1+TurbineINxH2O*output2+...
            TurbineINxO2*output3+TurbineINxN2Ar*output4;
        Omega = output(2);
		Tc = output(3);
		Pc = output(4);
end
Tr=T./Tc;
Pr=P./Pc;
B0 = 0.083 - 0.422./(Tr.^1.6);
B1 = 0.139 - 0.172./(Tr.^4.2);
dB0 = 0.675./(Tr.^2.6);
dB1 = 0.722./(Tr.^5.2);
HRes = (Pr.*Tc).*(B0-Tr.*dB0+Omega.*(B1-Tr.*dB1));
end
%