function [igCp298 igCp IntegralOverT] = CpEnthalpy(T,Mixture)
% Heat Capacities and Enthalpies
% mixed state (entering to turbine) in outer script
switch Mixture
    case 'air'
		output1 = igCpCoefficients('air');
		output2 = igCpCoefficients('H2O');
        output2 = output2(1:length(output1));
		output= output1*(1-0.38)+0.38*output2; 
		A = output(1); 
		B = output(2); 
		C = output(3); 
		D = output(4);  
		igCp298 = output(5); 
    case 'fuel'
        output1 = igCpCoefficients('CH4');
        output2 = igCpCoefficients('C2H6');
        output3 = igCpCoefficients('C3H8');
        output4 = igCpCoefficients('N2');
        [xCH4 xC2H6 xC3H8 xN2 Mw Omega Tc Pc Vc Zc] = Fuel();
        output=xCH4*output1+xC2H6*output2+xC3H8*output3+xN2*output4;
        A = output(1); 
        B = output(2); 
        C = output(3); 
        D = output(4);  
        igCp298 = output(5);
    case 'turbinIN'
        output1 = igCpCoefficients('CO2');
        output2 = igCpCoefficients('H2O');
        output3 = igCpCoefficients('O2');
        output4 = igCpCoefficients('N2');
        load xTurbineTemp.mat TurbineINxCO2 TurbineINxH2O TurbineINxN2Ar TurbineINxO2
        outputt=TurbineINxCO2*output1+TurbineINxH2O*output2+...
            TurbineINxO2*output3+TurbineINxN2Ar*output4;
        A = outputt(1); 
        B = outputt(2); 
        C = outputt(3); 
        D = outputt(4);  
        igCp298 = outputt(5);
    case 'combustionOUT'
        output1 = igCpCoefficients('CO2');
        output2 = igCpCoefficients('H2O');
        output3 = igCpCoefficients('O2');
        output4 = igCpCoefficients('N2');
        load xTemp.mat CombustionOutXCO2 CombustionOutXH2O CombustionOutXO2 CombustionOutXN2Ar ;
        outputt=CombustionOutXCO2*output1+CombustionOutXH2O*output2+...
            CombustionOutXO2*output3+CombustionOutXN2Ar*output4;
        A = outputt(1); 
        B = outputt(2); 
        C = outputt(3); 
        D = outputt(4);  
        igCp298 = outputt(5);
	end
igCp = A + B.*T + C.*(T.^2) + D./(T.^2);
T0=298;
tau = T./T0;
IntegralOverT = (A + (B/2).*T0*(tau+1)+(C/3).*(T0.^2).*(tau.^2+tau+1)+...
    D./(tau.*(T0.^2))).*(T-T0);
end
%