function yout = ObjectiveFunctionsGA(x)
% to be maximized by GA
% #########################################################################
% x containes chromosomes from GA 
CompressorPressureRatio= x(1); % Compressor Pressure Ratio 
TowerHeight = x(2); % Tower Height in meter Range ::: 40 - 200 m 
N = x(3); % number of mirrors
% #########################################################################
OUT = CalculationRoute(CompressorPressureRatio, TowerHeight, N);
% OUT = [Cost.TotalCapital; LCOEsolar; CO2factor; FuelEfficiency];
Cost.TotalCapital = OUT(1,:);
LCOEsolar = OUT(2,:);
CO2factor = OUT(3,:);
FuelEfficiency = OUT(4,:);
GAoutputEval = [Cost.TotalCapital; LCOEsolar; CO2factor; FuelEfficiency];
yout = GAoutputEval;
% to be maximized by GA
% @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
end
%