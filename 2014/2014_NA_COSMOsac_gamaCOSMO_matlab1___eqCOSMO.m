function eqCOSMO() 
% Two Phase Equilibrium Calculations using COSMO model (COSMO-SAC) 
% Manual at this stage 
SYSTEMP=273.15; % temprature of interest 
MIX='Dissolved'; % Mixture 1 - Phase A
ListCOMP={'67-63-0-2d', 'Z1'}; % list of components in mixture 1
% Binary mixtures at this stage 
MATrixA=Binary(SYSTEMP, ListCOMP);
%MATrix(x,:)=[x1(x) GAMMA(1) LNGAMMA(1) x2(x) GAMMA(2) LNGAMMA(2)];
xlswrite('MixGamma.xlsx', MATrixA, MIX);
% 
MIX='Solute'; 
ListCOMP={'Z1', 'Z1'}; 
MATrixB=Binary(SYSTEMP, ListCOMP);
xlswrite('MixGamma.xlsx', MATrixB, MIX);
% Equilibria ::: @SLE
%


%
%
%
