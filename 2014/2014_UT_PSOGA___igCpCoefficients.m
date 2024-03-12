function OUTmfile = igCpCoefficients(COMP)
% Coefficnets and Heat capacities of Gases in the ideal gas state for Eq. 
% >>> Cp/R = A + B*T + C*(T^2) + D/(T^2) 
switch COMP
    case 'H2O'
        % for H2O
        A = 3.470;
        B = 1.450e-3;
        C = 0;
        D = 0.121e+5;
        igCp298 = 4.038;
        OUTmfile = [A B C D igCp298];
    case 'CO2'
        % for CO2
        A = 5.457;
        B = 1.045e-3;
        C = 0;
        D = -1.157e+5;
        igCp298 = 4.467;
        OUTmfile = [A B C D igCp298];
    case 'O2'
        % for O2
        A = 3.639;
        B = 0.506e-3;
        C = 0;
        D = -0.227e+5;
        igCp298 = 3.535;
        OUTmfile = [A B C D igCp298];
    case 'N2'
        % for N2
        A = 3.280;
        B = 1.214e-3;
        C = 0;
        D = -0.928e+5;
        igCp298 = 3.502;
        OUTmfile = [A B C D igCp298];
    case 'air'
        % for Air
        A = 3.355;
        B = 0.575e-3;
        C = 0;
        D = -0.016e+5;
        igCp298 = 3.509;
        OUTmfile = [A B C D igCp298];
    case 'CH4'
        % for CH4
        A = 1.702;
        B = 9.081e-3;
        C = -2.164e-6;
        D = 0;
        igCp298 = 4.217;
        OUTmfile = [A B C D igCp298];
    case 'C2H6'
        % for C2H6
        A = 1.131;
        B = 19.225e-3;
        C = -5.562e-6;
        D = 0;
        igCp298 = 6.369;
        OUTmfile = [A B C D igCp298];
    case 'C3H8'
        % for C3H8
        A = 1.213;
        B = 27.785e-3;
        C = -8.824e-6;
        D = 0;
        igCp298 = 9.011;
        OUTmfile = [A B C D igCp298];
end
end
%