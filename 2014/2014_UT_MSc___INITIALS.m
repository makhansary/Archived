function [OMG1IN OMG2IN OMG3IN UTOP1 UTOP2 TEMPIN]=INITIALS()
% This Script provides the initial data for starting calculations
% help on
% Get inputs ....
OMG1IN=0.000000001; %input('Omega 1  =  (Ex. 0.000000001) ');
OMG2IN=0.850; %input('Omega 2  =  (Ex. 0.850) ');
OMG3IN=1-OMG2IN-OMG1IN;
% Maximum Value for Velocity
UTOP1=0.1600;
UTOP2=0.1229;
% Initial Temperature in Kelvin
TEMPIN=298.15;
end
% End of nested m-file.