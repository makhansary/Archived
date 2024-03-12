function OUT = CalculationRoute(CompressorPressureRatio, TowerHeight, N)
saveGA = CheckState();
if saveGA == 1 
    CompressorPressureRatio = CompressorPressureRatio/100;
end
R = 8.314; % J/mole.K
streamCOOLTemp = 0;  % cooling rate  *  default to start    *******************
CoolingReached = 0;
while CoolingReached ~= 1
    streamCOOL = streamCOOLTemp;
stream6.Temperature = 1100 + 273.15; 
stream0.Temperature = 30+273.15;  % inlet air stream Temperature Kelvin
stream0.Pressure = 1.013;  % inlet air stream pressure bar
stream0.mDotInlet = 410;  % inlet air stream mass flow 410 Kg/s
QplusRECunit = 250025;  % [W/m2] use a fixed value instead of section 5.5
f_dp_inlet=1e-5;  % pressure drop due to filtration  ASSUMED
stream1.Pressure=stream0.Pressure*(1-f_dp_inlet); 
stream1.Temperature=stream0.Temperature; 
stream1.mDot=stream0.mDotInlet; 
[igCp298 IntegralOverT] = CpEnthalpy(stream1.Temperature,'air'); 
HRes = HResidual(stream1.Temperature,stream1.Pressure,'air'); 
stream1.EnthaplyH=HRes+ (igCp298*298+IntegralOverT)*R; % J/moleK
tempout = Air();
stream1.MW = tempout(1);
molT = stream1.mDot * 1000 / stream1.MW; % Kg > mole
stream1.EnthaplyH=stream1.EnthaplyH*molT; % J
EfficiencyMechanical = 0.65;
PolyTropicEfficiency=0.92;   % Compressor Poly-tropic Efficiency
stream2.mDot=stream1.mDot; 
stream2.Pressure=stream1.Pressure.*CompressorPressureRatio; 
[igCp298 igCp] = CpEnthalpy(stream1.Temperature,'air');  
cp=igCp * R; 
stream2.Temperatureisen=...
    stream1.Temperature.*((stream2.Pressure./stream1.Pressure).^(R./cp)); 
[igCp298 IntegralOverT] = CpEnthalpy(stream2.Temperatureisen,'air'); 
HRes = HResidual(stream2.Temperatureisen,stream2.Pressure,'air'); 
stream2.EnthaplyHisen=HRes+(igCp298*298+IntegralOverT)*R; % J/moleK
tempout = Air();
stream2.MW = tempout(1);
molT = stream2.mDot * 1000 / stream2.MW; % Kg > mole
stream2.EnthaplyHisen=stream2.EnthaplyHisen*molT; % J
CompressorEfficiency=(CompressorPressureRatio.^(R./cp)-1)...
    ./(CompressorPressureRatio.^(R./cp./PolyTropicEfficiency)-1); 
stream2.EnthaplyH=stream1.EnthaplyH+...
    ((stream2.EnthaplyHisen-stream1.EnthaplyH)./CompressorEfficiency);  
stream2.Temperature = FindCompressorTfromH(stream2.EnthaplyH,...
    stream2.Temperatureisen,stream2.Pressure,'air',stream2.mDot);
EplusCompressor=stream2.mDot.*(stream2.EnthaplyH...
    -stream1.EnthaplyH)./EfficiencyMechanical; 
streamPurge=0.03*stream0.mDotInlet; 
%streamCOOL = 0.05 *stream0.mDotInlet;
streamMain=stream0.mDotInlet-(streamPurge+streamCOOL); 
RadiiIN = 1.25 * 2; %
t = stream2.Temperature - 273.15;
AirDensity = 0.2221*exp(-0.01327*t) + 1.025*exp(-0.001545*t); % kg.m−3
TowerCrosssectionalArea = pi.*(RadiiIN.^2)/4;
uTower = streamMain./(AirDensity.*TowerCrosssectionalArea); 
DeltaPressureRET = 0.294 * AirDensity .* (uTower.^2)./2; 
DeltaPressureRET = DeltaPressureRET * 1e-5;
uc = 120; 
DeltaPressureEXT1 = AirDensity .* ((uc.^2)./2) .* (0.294 + 0.0987 .* ((1-...
    uTower./uc).^2)); 
DeltaPressureEXT1 = DeltaPressureEXT1 * 1e-5;
AirViscosityK = -2.077e-007* (t.^3) + 0.001041* (t.^2) + 0.8786 * t +...
    136.6;  % m2/s 
AirViscosityK = AirViscosityK * 1e-6;
AirViscosityK = AirViscosityK / AirDensity;
DiameterInternalUpFlow = 2.5;
DeltaPressurePipe1 = 1.472 * ((4*streamMain./(pi*AirViscosityK*DiameterInternalUpFlow)).^(-1/5))...
    .*(TowerHeight./(DiameterInternalUpFlow.^5)).*(streamMain.^2./AirDensity); 
DeltaPressurePipe1 = DeltaPressurePipe1 * 1e-5;
stream3.Pressure = stream2.Pressure-DeltaPressurePipe1 - DeltaPressureEXT1; 
[igCp298 igCp IntegralOverT] = CpEnthalpy(stream2.Temperature,'air');   
cp=igCp * R;
stream3.Temperature=stream2.Temperature;
HRes = HResidual(stream3.Temperature,stream3.Pressure,'air'); 
stream3.EnthaplyH=HRes+ (igCp298*298+IntegralOverT)*R; % J/mole
tempout = Air();
stream3.MW = tempout(1);
stream3.mDot = streamMain;
stream4.mDot = streamMain;
molT = stream3.mDot * 1000 / stream3.MW; % Kg > mole
stream3.EnthaplyH=stream3.EnthaplyH*molT; % J
Aunit = 40;  % Unit Area for Mirrors
Ar = N .* Aunit; 
QplusREC = Ar .* QplusRECunit;
tempout = Air(); 
molT = streamMain * 1000 / tempout(1); % Kg > mole
DeltaHstream34 = QplusREC;
stream4.EnthaplyH = stream3.EnthaplyH + DeltaHstream34;
stream4EnthaplyH1 = stream4.EnthaplyH / molT ; % = Cp(T4) * T4 [J/mole]
TRY = 0;
for guess = stream3.Temperature:stream3.Temperature+580
TRY = TRY+1;
stream4.Temperature = guess;
TEMP(TRY) = stream4.Temperature;
[igCp] = CpEnthalpy(stream4.Temperature,'air');   
cp=igCp * R;
stream4EnthaplyH2 = cp * stream4.Temperature;
Err(TRY) = abs(abs(stream4EnthaplyH1-stream4EnthaplyH2)/stream4EnthaplyH1);
end
[MIN, indexx] = min(abs(Err)); % minimum error
stream4.Temperature = TEMP (indexx);
% T from H
t = stream4.Temperature - 273.15;
AirDensity = 0.2221*exp(-0.01327*t) + 1.025*exp(-0.001545*t); % kg.m−3
AirViscosityK = -2.077e-007* (t.^3) + 0.001041* (t.^2) + 0.8786 * t + ...
    136.6;  % m2/s 
AirViscosityK = AirViscosityK * 1e-6;
AirViscosityK = AirViscosityK / AirDensity;
DiameterExternalHydrolic = 2.5;
DeltaPressurePipe2 = 1.472 * ((4*streamMain./...
    (pi*AirViscosityK*DiameterExternalHydrolic)).^(-1/5))...
    .*(TowerHeight./(DiameterExternalHydrolic.^5)).*(streamMain.^2./AirDensity); 
DeltaPressurePipe2 = DeltaPressurePipe2 * 1e-5;
DeltaPressureEXT2 = AirDensity .* ((uc.^2)./2) .* (0.294 + 0.0987 .* ((1-...
    uTower./uc).^2)); 
DeltaPressureEXT2 = DeltaPressureEXT2 * 1e-5;
alphaR = 1 - 0.04; 
epsilonR = 0.04; 
pREF = 6.5;  % bar
optEfficiencyREF = 0.87;  
SIGMA = 5.669e-8;  % sigma number in radiation Watt/m2K4
%[igCp298 igCp IntegralOverT] = CpEnthalpy(stream4.Temperature,'air'); 
stream4.Pressure = stream3.Pressure - DeltaPressureEXT2;
%HRes = HResidual(stream4.Temperature,stream4.Pressure,'air'); 
%stream4.EnthaplyH=HRes+ (igCp298*298+IntegralOverT)*R; % J/moleK
%tempout = Air();
stream4.MW = tempout(1);
stream4.mDot = streamMain;
%molT = stream4.mDot * 1000 / stream4.MW; % Kg > mole
%stream4.EnthaplyH=stream4.EnthaplyH*molT; % J
QplusUSE = (stream4.EnthaplyH - stream3.EnthaplyH); 
LogEfficiencyOPT = (stream3.Pressure./pREF) .* log10(optEfficiencyREF); 
EfficiencyOPT = 10.^(LogEfficiencyOPT); % window
Arr = 112; 
Tambient = 25 + 273.15;  
QminusUSE = EfficiencyOPT .* alphaR .* QplusREC -...
    Arr .* epsilonR .* SIGMA ...
    .* (((stream4.Temperature+stream3.Temperature)/2).^4 - (Tambient.^4)); 
stream5.Temperature = stream4.Temperature; 
FuelTemperatureIN = 16 +273.15; 
[igCp298 igCp IntegralOverT] = CpEnthalpy(stream5.Temperature,'air'); 
stream5.Pressure = stream4.Pressure-DeltaPressurePipe2-DeltaPressureRET;
HRes = HResidual(stream5.Temperature,stream5.Pressure,'air'); 
tempout = Air();
stream5.MW = tempout(1);
CPair= igCp298 * R;
CPair= CPair .* 1000 ./ stream5.MW;
stream5.EnthaplyH=HRes+ (igCp298*298+IntegralOverT)*R; % J/moleK
%tempout = Air();
%stream5.MW = tempout(1);
stream5.mDot = streamMain;
molT = stream5.mDot * 1000 / stream5.MW; % Kg > mole
stream5.EnthaplyH=stream5.EnthaplyH*molT; % J
[igCp298 igCp IntegralOverT] = CpEnthalpy(stream6.Temperature,'air'); 
stream6.Pressure = stream5.Pressure * (1-0.04);
HRes = HResidual(stream6.Temperature,stream6.Pressure,'air'); 
% trial and error
stream6.mDot=streamMain; % initial, stream6.mDot = FuelFLOW + streamMain, 
reached=0;
TempFuel = 0;
tempout = Air();
airCont = streamMain * tempout (1);
[Mw] = Fuel();
fuelCont = TempFuel * 17.89;
stream6.MW =(fuelCont + airCont)/(streamMain+TempFuel); % initial setting
while (reached~=1)
stream6.EnthaplyH=HRes+ (igCp298*298+IntegralOverT)*R; % J/moleK
molT = stream6.mDot * 1000 / stream6.MW; % Kg > mole
stream6.EnthaplyH=stream6.EnthaplyH*molT; % J 
[igCp298 igCp IntegralOverT] = CpEnthalpy(FuelTemperatureIN,'fuel'); 
CPf = igCp298 .* R;
CPf = CPf * 1000 ./ 17.89; 
FuelPressureIN = 18;  % bar
HRes = HResidual(FuelTemperatureIN,FuelPressureIN,'fuel');  
FuelEnthaplyIN=HRes+ (igCp298*298+IntegralOverT)*R; % J/moleK
[Mw] = Fuel();
tempout = Mw;
molT = TempFuel * 1000 / tempout; % Kg > mole
FuelEnthaplyIN=FuelEnthaplyIN*molT; % J
[igCp298 igCp IntegralOverT] = CpEnthalpy(stream6.Temperature,'fuel'); 
FuelPressureOUT = stream6.Pressure;   
HRes = HResidual(stream6.Temperature,FuelPressureOUT,'fuel'); 
FuelEnthaplyOUT=HRes+ (igCp298*298+IntegralOverT)*R; % J/moleK
molT = stream6.mDot * 1000 / stream6.MW; % Kg > mole
FuelEnthaplyOUT=FuelEnthaplyOUT*molT; % J
DeltaHfuel = FuelEnthaplyOUT - FuelEnthaplyIN;  
LHVunit = 45.86e+6;  % J/kg
FuelFLOW = streamMain .* (CPair*(stream6.Temperature - ... 
    stream5.Temperature)) ./ (LHVunit - (CPf * ... 
    (stream6.Temperature - FuelTemperatureIN)) );     
stream6.mDot = FuelFLOW + streamMain; 
streamCOOLm = streamCOOL / stream6.mDot;
reached = FuelFLOW < TempFuel + 1e-6;
TempFuel = FuelFLOW;
m_dot_fuel = FuelFLOW; 
[xCH4 xC2H6 xC3H8 xN2] = Fuel(); 
x = sum([1 2 3 0] .* [xCH4 xC2H6 xC3H8 xN2]);  % C
y = sum([4 6 8 0] .* [xCH4 xC2H6 xC3H8 xN2]);  % H
tempout = Air(); 
yN2  = tempout (6); 
yO2  = tempout (7); 
c_O2_in = yO2; 
c_N2Ar_in = yN2; 
c_Carbon=12.*x./(12.*x+y); 
c_O2_out=c_O2_in-(m_dot_fuel./streamMain).*((32/12).*c_Carbon+...
    (32/4).*(1-c_Carbon))./(1+(m_dot_fuel./streamMain)); 
c_CO2_out=(44/12).*c_Carbon.*(m_dot_fuel./streamMain)./(1+...
    (m_dot_fuel./streamMain)); 
c_H2O_out=(36/4).*(1-c_Carbon).*(m_dot_fuel./streamMain)./(1+...
    (m_dot_fuel./streamMain)); 
c_N2Ar_out=c_N2Ar_in./(1+(m_dot_fuel./streamMain)); 
CombustionOutXCO2 = c_CO2_out ;
CombustionOutXH2O = c_H2O_out ;
CombustionOutXO2 = c_O2_out ;
CombustionOutXN2Ar = c_N2Ar_out ;
tempout = N2();
N2cont = tempout(1) * CombustionOutXN2Ar ;
tempout = H2O();
H2Ocont = tempout(1) * CombustionOutXH2O ;
tempout = CO2();
CO2cont = tempout(1) * CombustionOutXCO2 ;
tempout = O2();
O2cont  = tempout(1) * CombustionOutXO2;
stream6.MW = N2cont + H2Ocont + CO2cont + O2cont; % correction
end % while
save xTemp.mat CombustionOutXCO2 CombustionOutXH2O CombustionOutXO2 CombustionOutXN2Ar; 
%
[igCp298 igCp] = CpEnthalpy(stream6.Temperature,'combustionOUT'); 
cpEXHAUSE=igCp * R;
[igCp298 igCp] = CpEnthalpy(stream2.Temperature,'air'); 
cpCOMP=igCp * R;
% Mixed Turbine In
Tblade = 880 + 273.15; 
if (stream6.Temperature>=Tblade) 
	streamCOOLm = (cpCOMP./cpEXHAUSE) .* ((stream6.Temperature-...
        Tblade)./(Tblade-stream2.Temperature)); 
    streamCOOL = streamCOOLm .* stream6.mDot;
	else
	streamCOOL = 0; 
end
CoolingReached = streamCOOL < streamCOOLTemp +1e-8;
streamCOOLTemp = streamCOOL; 
%
streamMain=stream0.mDotInlet-(streamPurge+streamCOOL); 
stream6.mDot = FuelFLOW + streamMain;
stream7.Temperature = (stream6.Temperature+0.154*((stream6.Temperature-...
    Tblade)/(Tblade-stream2.Temperature))*stream2.Temperature)/(1+...
0.154*((stream6.Temperature-Tblade)/(Tblade-stream2.Temperature)));
stream7.mDot = stream6.mDot+streamCOOL; 
stream7.Pressure = stream6.Pressure;
TurbineINxCO2 = CombustionOutXCO2 / (1 + streamCOOLm);
TurbineINxH2O = CombustionOutXH2O / (1 + streamCOOLm);
TurbineINxN2Ar = (CombustionOutXN2Ar ...
    + streamCOOLm .* yN2) ./ (1 + streamCOOLm);
TurbineINxO2 = (CombustionOutXO2 + ...
    streamCOOLm .* yO2) ./ (1 + streamCOOLm);
save xTurbineTemp.mat TurbineINxCO2 TurbineINxH2O TurbineINxN2Ar TurbineINxO2;
[igCp298 IntegralOverT]=CpEnthalpy(stream7.Temperature,'turbinIN') ;
HRes = HResidual(stream7.Temperature,stream7.Pressure,'turbinIN') ;
stream7.EnthaplyH=HRes+ (igCp298*298+IntegralOverT)*R; % J/moleK
tempout = N2();
N2cont = tempout(1) * TurbineINxN2Ar ;
tempout = H2O();
H2Ocont = tempout(1) * TurbineINxH2O ;
tempout = CO2();
CO2cont = tempout(1) * TurbineINxCO2  ;
tempout = O2();
O2cont  = tempout(1) * TurbineINxO2;
stream7.MW = N2cont + H2Ocont + CO2cont + O2cont; % correction
molT = stream7.mDot * 1000 / stream7.MW; % Kg > mole
stream7.EnthaplyH=stream7.EnthaplyH*molT; % J
stream8.Pressure = 1;
TurbinePressureRatio = stream8.Pressure./stream7.Pressure;
[igCp298 igCp] = CpEnthalpy(stream7.Temperature,'turbinIN');  
cp=igCp * R;
stream8.Temperatureisen=stream7.Temperature...
    .*(stream8.Pressure./stream7.Pressure).^(R./cp); 
[igCp298 IntegralOverT]=CpEnthalpy(stream8.Temperatureisen,'turbinIN'); 
HRes = HResidual(stream8.Temperatureisen,stream8.Pressure,'turbinIN'); 
stream8.EnthaplyHisen=HRes+ (igCp298*298+IntegralOverT)*R; % J/moleK
stream8.MW = stream7.MW;
stream8.mDot = stream7.mDot;
molT = stream8.mDot * 1000 / stream8.MW; % Kg > mole
stream8.EnthaplyHisen=stream8.EnthaplyHisen*molT; % J
PolyTropicEfficiency=0.86;   % Turbine Poly-tropic Efficiency
TurbineEfficiency=(TurbinePressureRatio.^(PolyTropicEfficiency.*R./cp)-...
    1)./(TurbinePressureRatio.^(R./cp)-1); 
stream8.EnthaplyH=stream7.EnthaplyH-((stream7.EnthaplyH-...
stream8.EnthaplyHisen).*TurbineEfficiency) ;  
stream8.Temperature = FindTurbinTfromH(stream8.EnthaplyH,...
    stream8.Temperatureisen,stream8.Pressure,'turbinIN',...
    stream8.mDot,stream8.MW);
fLOAD=0.1;  	% ASSUMED
EfficiencyElectericalZERO=0.3;  % ASSUMED		
EfficiencyElecterical=1-(1-EfficiencyElectericalZERO)*fLOAD; 
EminusTurbine=EfficiencyMechanical.* streamMain.*(stream7.EnthaplyH/stream7.mDot-...
    stream8.EnthaplyH/stream8.mDot);  
EminusElectrical=EfficiencyElecterical...
    .*EfficiencyMechanical.*(EminusTurbine - EplusCompressor);  
EminusNET=EminusElectrical*365*24*60*60; % J
end
% @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Cost.CT=0;
Cost.Helio = 200*Aunit*N + 1e6; 
Cost.Field = Cost.Helio;
if TowerHeight < 120 
    Cost.Tower = (1.09e6)*exp(0.0088*TowerHeight); 
else
    Cost.Tower = (0.782e6)*exp(0.0113*TowerHeight); 
end
Cost.Reiever = 79*stream4.Temperature-42000;
rOUT = 2.5;
rIN = 1.25;
Cost.Piping = TowerHeight.* (3600.*rOUT./1.31+420*rIN/0.87)+90000*rIN/0.87;
Cost.Equipment = Cost.Field + Cost.Tower + Cost.Piping + Cost.Reiever;
Cost.Equipment = Cost.Equipment * (1640.9/815);
Cost.Investment = Cost.Equipment; 
mirVolumeWater = Aunit*N*50; 
Cost.Water = 1 * (mirVolumeWater); 
Cost.Fuel = 0.02 * FuelFLOW;
Cost.Operations = Cost.Water + Cost.Fuel; 
Cost.MaintenanceSolar = 0.08 * Cost.Equipment;  
inflatationIDX = 0.07; 
nCON = 2; 
nOP = 25; 
alphaCOST = ((1+inflatationIDX).^nCON - 1)./(nCON.*inflatationIDX).* ...
(inflatationIDX.*((inflatationIDX+1).^nOP))/((inflatationIDX+1).^nOP-1); 
Cost.OperatingSolar = Cost.Water; 
Cost.InvestmentSolar = Cost.Investment;
SolarShareFactor = abs(QminusUSE) ./ (abs(QminusUSE)+ (FuelFLOW*LHVunit));
EminusNET = EminusNET * 2.77777778e-10; % J ==> MWh
LCOEsolar = (alphaCOST.* Cost.InvestmentSolar + ...
Cost.OperatingSolar + Cost.MaintenanceSolar)./(abs(EminusNET).*SolarShareFactor); 
Cost.TotalCapital = Cost.Investment; 
carbonCONTENT = CombustionOutXCO2;  
CO2factor = (44/12) * FuelFLOW .* carbonCONTENT * 365*24*60*60 ./ abs(EminusNET); 
FuelEfficiency = (abs(EminusNET)./2.77777778e-10) ./ (FuelFLOW.*LHVunit*365*24*60*60);% EminusNET[=]J
% @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
% calculations done!,now define the objectives of GT-system(Indicators?)
% @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
OUT = [Cost.TotalCapital; LCOEsolar; CO2factor; FuelEfficiency];
saveGA = CheckState();
if saveGA == 1 
    % saving GA data
    load IndexGA.mat IndexGA_i IndexGA_j;
    load GAData.mat;
    GA_MainObjectives_LCOEsolar(IndexGA_i, IndexGA_j) = LCOEsolar; 
    GA_MainObjectives_CO2factor(IndexGA_i, IndexGA_j) = CO2factor; 
    GA_MainObjectives_FuelEfficiency(IndexGA_i, IndexGA_j) = FuelEfficiency; 
    GA_MainObjectives_Cost_TotalCapital(IndexGA_i, IndexGA_j) = Cost.TotalCapital; 
    GA_MainObjectives_carbonCONTENT(IndexGA_i, IndexGA_j) = carbonCONTENT; 
    GA_MainObjectives_SolarShareFactor(IndexGA_i, IndexGA_j) = SolarShareFactor; 
    GA_MainObjectives_mirVolumeWater(IndexGA_i, IndexGA_j) = mirVolumeWater; 
    GA_MainObjectives_EminusNET(IndexGA_i, IndexGA_j) = EminusNET; 
    GA_MainObjectives_Cost_OperatingSolar(IndexGA_i, IndexGA_j) = Cost.OperatingSolar; 
    GA_MainObjectives_CompressorPressureRatio(IndexGA_i, IndexGA_j) = CompressorPressureRatio;
    GA_MainObjectives_TowerHeight(IndexGA_i, IndexGA_j) = TowerHeight;
    GA_MainObjectives_EplusCompressor(IndexGA_i, IndexGA_j) = EplusCompressor;
    GA_MainObjectives_QplusUSE(IndexGA_i, IndexGA_j) = QplusUSE;
    GA_MainObjectives_QminusUSE(IndexGA_i, IndexGA_j) = QminusUSE;
    GA_MainObjectives_FuelFLOW(IndexGA_i, IndexGA_j) = FuelFLOW;
    GA_MainObjectives_TurbinePressureRatio(IndexGA_i, IndexGA_j) =TurbinePressureRatio;
    GA_MainObjectives_EminusTurbine(IndexGA_i, IndexGA_j) = EminusTurbine;
    GA_MainObjectives_N(IndexGA_i, IndexGA_j) = N;
    GA_stream1_Pressure(IndexGA_i, IndexGA_j) = stream1.Pressure;
    GA_stream1_Temperature(IndexGA_i, IndexGA_j) = stream1.Temperature;
    GA_stream1_mDot(IndexGA_i, IndexGA_j) = stream1.mDot;
    GA_stream1_EnthaplyH(IndexGA_i, IndexGA_j) = stream1.EnthaplyH;
    GA_stream2_Pressure(IndexGA_i, IndexGA_j) = stream2.Pressure;
    GA_stream2_Temperature(IndexGA_i, IndexGA_j) = stream2.Temperature;
    GA_stream2_mDot(IndexGA_i, IndexGA_j) = stream2.mDot;
    GA_stream2_EnthaplyH(IndexGA_i, IndexGA_j) = stream2.EnthaplyH;
    GA_stream3_Pressure(IndexGA_i, IndexGA_j) = stream3.Pressure;
    GA_stream3_Temperature(IndexGA_i, IndexGA_j) = stream3.Temperature;
    GA_stream3_mDot(IndexGA_i, IndexGA_j) = stream3.mDot;
    GA_stream3_EnthaplyH(IndexGA_i, IndexGA_j) = stream3.EnthaplyH;
    GA_stream4_Pressure(IndexGA_i, IndexGA_j) = stream4.Pressure;
    GA_stream4_Temperature(IndexGA_i, IndexGA_j) = stream4.Temperature;
    GA_stream4_mDot(IndexGA_i, IndexGA_j) = stream4.mDot;
    GA_stream4_EnthaplyH(IndexGA_i, IndexGA_j) = stream4.EnthaplyH; 
    GA_stream5_Pressure(IndexGA_i, IndexGA_j) = stream5.Pressure;
    GA_stream5_Temperature(IndexGA_i, IndexGA_j) = stream5.Temperature;
    GA_stream5_mDot(IndexGA_i, IndexGA_j) = stream5.mDot;
    GA_stream5_EnthaplyH(IndexGA_i, IndexGA_j) = stream5.EnthaplyH;
    GA_stream6_Pressure(IndexGA_i, IndexGA_j) = stream6.Pressure;
    GA_stream6_Temperature(IndexGA_i, IndexGA_j) = stream6.Temperature;
    GA_stream6_mDot(IndexGA_i, IndexGA_j) = stream6.mDot;
    GA_stream6_EnthaplyH(IndexGA_i, IndexGA_j) = stream6.EnthaplyH;
    GA_stream7_Pressure(IndexGA_i, IndexGA_j) = stream7.Pressure;
    GA_stream7_Temperature(IndexGA_i, IndexGA_j) = stream7.Temperature;
    GA_stream7_mDot(IndexGA_i, IndexGA_j) = stream7.mDot;
    GA_stream7_EnthaplyH(IndexGA_i, IndexGA_j) = stream7.EnthaplyH;
    GA_stream8_Pressure(IndexGA_i, IndexGA_j) = stream8.Pressure;
    GA_stream8_Temperature(IndexGA_i, IndexGA_j) = stream8.Temperature;
    GA_stream8_mDot(IndexGA_i, IndexGA_j) = stream8.mDot;
    GA_stream8_EnthaplyH(IndexGA_i, IndexGA_j) = stream8.EnthaplyH;
    GA_Cost_Field(IndexGA_i, IndexGA_j) = Cost.Field;
    GA_Cost_Tower(IndexGA_i, IndexGA_j) = Cost.Tower;
    GA_Cost_Reiever(IndexGA_i, IndexGA_j) = Cost.Reiever;
    GA_Cost_Piping(IndexGA_i, IndexGA_j) = Cost.Piping;
    GA_Cost_Operations(IndexGA_i, IndexGA_j) = Cost.Operations;
    GA_Cost_MaintenanceSolar(IndexGA_i, IndexGA_j) = Cost.MaintenanceSolar;
    GA_Cooling(IndexGA_i, IndexGA_j) = streamCOOL; 
    save GAData.mat GA_Cost_MaintenanceSolar GA_Cost_Operations ...
        GA_Cost_Piping GA_Cost_Reiever GA_Cost_Tower GA_Cost_Field ...
        GA_stream8_EnthaplyH GA_stream8_mDot GA_stream8_Temperature ...
        GA_stream8_Pressure GA_stream7_EnthaplyH GA_stream7_mDot ...
        GA_stream7_Temperature GA_stream7_Pressure GA_stream6_EnthaplyH ...
        GA_stream6_mDot GA_stream6_Temperature GA_stream6_Pressure ...
        GA_stream5_EnthaplyH GA_stream5_mDot GA_stream5_Temperature ...
        GA_stream5_Pressure GA_stream4_EnthaplyH GA_stream4_mDot ...
        GA_stream4_Temperature GA_stream4_Pressure GA_stream3_EnthaplyH ...
        GA_stream3_mDot GA_stream3_Temperature GA_stream3_Pressure ...
        GA_stream2_EnthaplyH GA_stream2_mDot GA_stream2_Temperature ...
        GA_stream2_Pressure GA_stream1_EnthaplyH GA_stream1_mDot ...
        GA_stream1_Temperature GA_stream1_Pressure GA_MainObjectives_N ...
        GA_MainObjectives_EminusTurbine GA_MainObjectives_TurbinePressureRatio ...
        GA_MainObjectives_FuelFLOW GA_MainObjectives_QminusUSE ...
        GA_MainObjectives_QplusUSE GA_MainObjectives_EplusCompressor ...
        GA_MainObjectives_TowerHeight GA_MainObjectives_CompressorPressureRatio ...
        GA_MainObjectives_Cost_OperatingSolar GA_MainObjectives_EminusNET ...
        GA_MainObjectives_mirVolumeWater GA_MainObjectives_SolarShareFactor ...
        GA_MainObjectives_carbonCONTENT GA_MainObjectives_Cost_TotalCapital ...
        GA_MainObjectives_FuelEfficiency GA_MainObjectives_CO2factor ...
        GA_MainObjectives_LCOEsolar GA_Cooling;
else 
    % saving PSO data - by default
    load IndexPSO.mat IndexPSO_i IndexPSO_j;
    load PSOData.mat;
    PSO_MainObjectives_LCOEsolar(IndexPSO_i, IndexPSO_j) = LCOEsolar; 
    PSO_MainObjectives_CO2factor(IndexPSO_i, IndexPSO_j) = CO2factor; 
    PSO_MainObjectives_FuelEfficiency(IndexPSO_i, IndexPSO_j) = FuelEfficiency; 
    PSO_MainObjectives_Cost_TotalCapital(IndexPSO_i, IndexPSO_j) = Cost.TotalCapital; 
    PSO_MainObjectives_carbonCONTENT(IndexPSO_i, IndexPSO_j) = carbonCONTENT; 
    PSO_MainObjectives_SolarShareFactor(IndexPSO_i, IndexPSO_j) = SolarShareFactor; 
    PSO_MainObjectives_mirVolumeWater(IndexPSO_i, IndexPSO_j) = mirVolumeWater; 
    PSO_MainObjectives_EminusNET(IndexPSO_i, IndexPSO_j) = EminusNET; 
    PSO_MainObjectives_Cost_OperatingSolar(IndexPSO_i, IndexPSO_j) = Cost.OperatingSolar; 
    PSO_MainObjectives_CompressorPressureRatio(IndexPSO_i, IndexPSO_j) = CompressorPressureRatio;
    PSO_MainObjectives_TowerHeight(IndexPSO_i, IndexPSO_j) = TowerHeight;
    PSO_MainObjectives_EplusCompressor(IndexPSO_i, IndexPSO_j) = EplusCompressor;
    PSO_MainObjectives_QplusUSE(IndexPSO_i, IndexPSO_j) = QplusUSE;
    PSO_MainObjectives_QminusUSE(IndexPSO_i, IndexPSO_j) = QminusUSE;
    PSO_MainObjectives_FuelFLOW(IndexPSO_i, IndexPSO_j) = FuelFLOW;
    PSO_MainObjectives_TurbinePressureRatio(IndexPSO_i, IndexPSO_j) =TurbinePressureRatio;
    PSO_MainObjectives_EminusTurbine(IndexPSO_i, IndexPSO_j) = EminusTurbine;
    PSO_MainObjectives_N(IndexPSO_i, IndexPSO_j) = N;
    PSO_stream1_Pressure(IndexPSO_i, IndexPSO_j) = stream1.Pressure;
    PSO_stream1_Temperature(IndexPSO_i, IndexPSO_j) = stream1.Temperature;
    PSO_stream1_mDot(IndexPSO_i, IndexPSO_j) = stream1.mDot;
    PSO_stream1_EnthaplyH(IndexPSO_i, IndexPSO_j) = stream1.EnthaplyH;
    PSO_stream2_Pressure(IndexPSO_i, IndexPSO_j) = stream2.Pressure;
    PSO_stream2_Temperature(IndexPSO_i, IndexPSO_j) = stream2.Temperature;
    PSO_stream2_mDot(IndexPSO_i, IndexPSO_j) = stream2.mDot;
    PSO_stream2_EnthaplyH(IndexPSO_i, IndexPSO_j) = stream2.EnthaplyH;
    PSO_stream3_Pressure(IndexPSO_i, IndexPSO_j) = stream3.Pressure;
    PSO_stream3_Temperature(IndexPSO_i, IndexPSO_j) = stream3.Temperature;
    PSO_stream3_mDot(IndexPSO_i, IndexPSO_j) = stream3.mDot;
    PSO_stream3_EnthaplyH(IndexPSO_i, IndexPSO_j) = stream3.EnthaplyH;
    PSO_stream4_Pressure(IndexPSO_i, IndexPSO_j) = stream4.Pressure;
    PSO_stream4_Temperature(IndexPSO_i, IndexPSO_j) = stream4.Temperature;
    PSO_stream4_mDot(IndexPSO_i, IndexPSO_j) = stream4.mDot;
    PSO_stream4_EnthaplyH(IndexPSO_i, IndexPSO_j) = stream4.EnthaplyH; 
    PSO_stream5_Pressure(IndexPSO_i, IndexPSO_j) = stream5.Pressure;
    PSO_stream5_Temperature(IndexPSO_i, IndexPSO_j) = stream5.Temperature;
    PSO_stream5_mDot(IndexPSO_i, IndexPSO_j) = stream5.mDot;
    PSO_stream5_EnthaplyH(IndexPSO_i, IndexPSO_j) = stream5.EnthaplyH;
    PSO_stream6_Pressure(IndexPSO_i, IndexPSO_j) = stream6.Pressure;
    PSO_stream6_Temperature(IndexPSO_i, IndexPSO_j) = stream6.Temperature;
    PSO_stream6_mDot(IndexPSO_i, IndexPSO_j) = stream6.mDot;
    PSO_stream6_EnthaplyH(IndexPSO_i, IndexPSO_j) = stream6.EnthaplyH;
    PSO_stream7_Pressure(IndexPSO_i, IndexPSO_j) = stream7.Pressure;
    PSO_stream7_Temperature(IndexPSO_i, IndexPSO_j) = stream7.Temperature;
    PSO_stream7_mDot(IndexPSO_i, IndexPSO_j) = stream7.mDot;
    PSO_stream7_EnthaplyH(IndexPSO_i, IndexPSO_j) = stream7.EnthaplyH;
    PSO_stream8_Pressure(IndexPSO_i, IndexPSO_j) = stream8.Pressure;
    PSO_stream8_Temperature(IndexPSO_i, IndexPSO_j) = stream8.Temperature;
    PSO_stream8_mDot(IndexPSO_i, IndexPSO_j) = stream8.mDot;
    PSO_stream8_EnthaplyH(IndexPSO_i, IndexPSO_j) = stream8.EnthaplyH;
    PSO_Cost_Field(IndexPSO_i, IndexPSO_j) = Cost.Field;
    PSO_Cost_Tower(IndexPSO_i, IndexPSO_j) = Cost.Tower;
    PSO_Cost_Reiever(IndexPSO_i, IndexPSO_j) = Cost.Reiever;
    PSO_Cost_Piping(IndexPSO_i, IndexPSO_j) = Cost.Piping;
    PSO_Cost_Operations(IndexPSO_i, IndexPSO_j) = Cost.Operations;
    PSO_Cost_MaintenanceSolar(IndexPSO_i, IndexPSO_j) = Cost.MaintenanceSolar;
    PSO_Cooling(IndexPSO_i, IndexPSO_j) = streamCOOL;
    save PSOData.mat PSO_Cost_MaintenanceSolar PSO_Cost_Operations ...
        PSO_Cost_Piping PSO_Cost_Reiever PSO_Cost_Tower PSO_Cost_Field ...
        PSO_stream8_EnthaplyH PSO_stream8_mDot PSO_stream8_Temperature ...
        PSO_stream8_Pressure PSO_stream7_EnthaplyH PSO_stream7_mDot ...
        PSO_stream7_Temperature PSO_stream7_Pressure PSO_stream6_EnthaplyH ...
        PSO_stream6_mDot PSO_stream6_Temperature PSO_stream6_Pressure ...
        PSO_stream5_EnthaplyH PSO_stream5_mDot PSO_stream5_Temperature ...
        PSO_stream5_Pressure PSO_stream4_EnthaplyH PSO_stream4_mDot ...
        PSO_stream4_Temperature PSO_stream4_Pressure PSO_stream3_EnthaplyH ...
        PSO_stream3_mDot PSO_stream3_Temperature PSO_stream3_Pressure ...
        PSO_stream2_EnthaplyH PSO_stream2_mDot PSO_stream2_Temperature ...
        PSO_stream2_Pressure PSO_stream1_EnthaplyH PSO_stream1_mDot ...
        PSO_stream1_Temperature PSO_stream1_Pressure PSO_MainObjectives_N ...
        PSO_MainObjectives_EminusTurbine PSO_MainObjectives_TurbinePressureRatio ...
        PSO_MainObjectives_FuelFLOW PSO_MainObjectives_QminusUSE ...
        PSO_MainObjectives_QplusUSE PSO_MainObjectives_EplusCompressor ...
        PSO_MainObjectives_TowerHeight PSO_MainObjectives_CompressorPressureRatio ...
        PSO_MainObjectives_Cost_OperatingSolar PSO_MainObjectives_EminusNET ...
        PSO_MainObjectives_mirVolumeWater PSO_MainObjectives_SolarShareFactor ...
        PSO_MainObjectives_carbonCONTENT PSO_MainObjectives_Cost_TotalCapital ...
        PSO_MainObjectives_FuelEfficiency PSO_MainObjectives_CO2factor ...
        PSO_MainObjectives_LCOEsolar PSO_Cooling;
end
end