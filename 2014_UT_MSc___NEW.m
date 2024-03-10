% Main Code
clear;
clc;
format long eng;
%PARAMETER
NPTS=131;
NCASE=1047;
% Initial conditions for the problem
OMG1IN=0.000000001; 
OMG2IN=0.850; 
OMG3IN=1-OMG2IN-OMG1IN;
% Maximum Value for U/H
UTOP1=0.1600;
UTOP2=0.1229;
% Initial Temperature in Kelvin
TEMPIN=298.15;
% All Constants
% component densities (g/cm^3) 
RH01=1.0;
RH02=0.7857;
RH03=1.31;
RH013=RH01-RH03;
RH023=RH02-RH03;
% the specific volumes (cm^3/g) 
SV1=1/RH01;
SV2=1/RH02;
SV3=1/RH03;
% Molecular weights (g/mole) 
WM1=18.0;
WM2=58.08;
WM3=40000.0;
V1=SV1*WM1;
V2=SV2*WM2;
V3=SV3*WM3;
% universal gas constant(cm3.atm/K.mol)
R=82.05746;
% pure molar volume ratios
V12=V1/V2;
V21=V2/V1;
V13=V1/V3;
V23=V2/V3;
% ratios of pure molar volumes to molecular weights
ETA=V1/WM1;
LAMBDA=V2/WM2;
GAMMA=V3/WM3;
ALPHA=ETA-GAMMA;
BETA=LAMBDA-GAMMA;
% parameters in Fujita's expression (self diffusion coefficients)
FUJD0=7.70133e-17;
FUJA=3.35087e-2;
FUJB=3.37608e-3;
% Creating Mesh ...
L0=75e-4;
Number=100;
dz=L0/Number;
X=0:dz:L0;
% Time
timeT=2e-9;
dt=1e-12;
% Dimensions
lx=length(X);
lt=ceil(timeT/dt);
% Preallocation for Saving Matrix
% Ultimate Savers
ijOMG1=zeros(lx,lt);
ijOMG2=zeros(lx,lt);
ijOMG3=zeros(lx,lt);
% F1, F2, G1, G2
StorageF1=zeros(lx,lt);
StorageF2=zeros(lx,lt);
StorageG1=zeros(lx,lt);
StorageG2=zeros(lx,lt);
% Velocity
vel=zeros(lx,lt);
% Density Saver
rho=zeros(lx,lt);
% L and t saver
% MovingBndry=zeros(lx,lt);
PrcdTime=zeros(1,lt);
% dwidz
dOMG1dz=zeros(lx,lt);
dOMG2dz=zeros(lx,lt);
% d2widz2
d2OMG1dz=zeros(lx,lt);
d2OMG2dz=zeros(lx,lt);
% j1, j2
J1=zeros(lx,lt);
J2=zeros(lx,lt);
% dJ1, dJ2
dJ1=zeros(lx,lt);
dJ2=zeros(lx,lt);
% Estimates
% Pre-Data Served as Local Temporal Data
OMG1=OMG1IN;
OMG2=OMG2IN;
OMG3=OMG3IN;
% Initial Condition @ t=0
ijOMG1(:,1)=OMG1;
ijOMG2(:,1)=OMG2;
ijOMG3(:,1)=OMG3;
% New Simplification 
ijOMG1(end,:)=1;
ijOMG2(end,:)=0;
ijOMG3(end,:)=1-ijOMG1(end,:)-ijOMG2(end,:);
% Loop
for iIter=1:1:10
    % Process Time
    PrcdTime(1,iIter)=iIter*dt;
    % Boundary Condition @ z=0
    ijOMG1(1,iIter)=ijOMG1(2,iIter);
    ijOMG2(1,iIter)=ijOMG2(2,iIter);
    ijOMG3(1,iIter)=ijOMG3(2,iIter);
    for jIter=2:1:lx-1
        % Determining dOMGidz
        dOMG1=ijOMG1(jIter+1,iIter)-ijOMG1(jIter-1,iIter);
        dOMG2=ijOMG2(jIter+1,iIter)-ijOMG2(jIter-1,iIter);
        dOMG3=ijOMG3(jIter+1,iIter)-ijOMG3(jIter-1,iIter);
        dOMG1dz(jIter,iIter)=dOMG1/dz/2;
        dOMG2dz(jIter,iIter)=dOMG2/dz/2;
        % Determining d2OMGidz2
        d2OMG1dz(jIter,iIter)=(ijOMG1(jIter+1,iIter)-2*ijOMG1(jIter,iIter)...
            +ijOMG1(jIter-1,iIter))/(dz^2);
        d2OMG2dz(jIter,iIter)=(ijOMG2(jIter+1,iIter)-2*ijOMG2(jIter,iIter)...
            +ijOMG2(jIter-1,iIter))/(dz^2);
        TERM1=-RH013/(RH01*RH03);
        TERM2=-RH023/(RH02*RH03);
        rRHO=ijOMG1(jIter,iIter)*TERM1+ijOMG2(jIter,iIter)*TERM2+(1/RH03);
        RHO=1/rRHO;
        rho(jIter,iIter)=RHO;
        % Calculating ....
        ABODON=GAMMA+ALPHA*ijOMG1(jIter,iIter)+BETA*ijOMG2(jIter,iIter); % Dominator of PHI
        DP1O1=ETA*(BETA*ijOMG2(jIter,iIter)+GAMMA)/(ABODON^2);
        DP2O1=-LAMBDA*ijOMG2(jIter,iIter)*ALPHA/(ABODON^2);
        DP1O2=-ETA*ijOMG1(jIter,iIter)*BETA/(ABODON^2);
        DP2O2=LAMBDA*(ALPHA*ijOMG1(jIter,iIter)+GAMMA)/(ABODON^2);
        %SUMO1=DP1O1+DP2O1;
        %SUMO2=DP1O2+DP2O2;
        %if SUMO1~=0 || SUMO2~=0
        %    DP1O1=0.5;
        %    DP2O1=-0.5;
        %    DP1O2=-0.5;
        %    DP2O2=0.5;
        %end
        % Calculuating the volume fractions from mass fractions (PHI)
        DUMMY=ALPHA*ijOMG1(jIter,iIter)+BETA*ijOMG2(jIter,iIter)+GAMMA;
        PHI1=ETA*ijOMG1(jIter,iIter)/DUMMY;
        PHI2=LAMBDA*ijOMG2(jIter,iIter)/DUMMY;
        PHI3=GAMMA*(1-ijOMG1(jIter,iIter)-ijOMG2(jIter,iIter))/DUMMY;
        PHI2B=PHI2/(PHI2+PHI3);
        % Coefficients of PDEs
        % Checking Phis
        if PHI1<0 || PHI2<0 || PHI3<0
            F1=0;
            F2=0;
            G1=0;
            G2=0;
            StorageF1(jIter,iIter)=F1;
            StorageF2(jIter,iIter)=F2;
            StorageG1(jIter,iIter)=G1;
            StorageG2(jIter,iIter)=G2;
            % Velocity
            % Calculation ....
            TERM1=F1*dOMG1dz(jIter,iIter)+G1*dOMG2dz(jIter,iIter);
            TERM2=F2*dOMG1dz(jIter,iIter)+G2*dOMG2dz(jIter,iIter);
            % Velocity
            VEL=(RH013/(RH01*RH03))*TERM1+(RH023/(RH02*RH03))*TERM2;
            if VEL==0
                VEL=-1e-2;
            end
            vel(jIter,iIter)=VEL; 
            % New -- ASSUMPTION -- Here right set == 0
            ijOMG1(jIter,iIter+1)=ijOMG1(jIter,iIter)...
                -(dOMG1dz(jIter,iIter)*vel(jIter,iIter))*dt;
            ijOMG2(jIter,iIter+1)=ijOMG2(jIter,iIter)...
                -(dOMG2dz(jIter,iIter)*vel(jIter,iIter))*dt;
            ijOMG3(jIter,iIter+1)=1-...
                (ijOMG1(jIter,iIter+1)+ijOMG2(jIter,iIter+1));
        else
            % Calculuating binary 12 volume fractions from ternary volume fractions
            U1=PHI1/(PHI1+PHI2);
            U2=PHI2/(PHI1+PHI2);
            if U1>UTOP1 || U2>UTOP2
                U1=UTOP1;
                U2=UTOP2;
            end
            % for Ternary (polymer/solent/nonsolvent) system
            G12=0.661+(0.417/(1-(U2*0.755)));
            G23=0.535+0.11*PHI3;
            G13=1.4;
            % d
            DG12=0.417*0.755/((1-U2*0.755)^2);
            DG23=0.11;
            DG13=0;
            % d2
            DDG12=(2*0.755/(1-U2*0.755))*DG12;
            DDG23=0;
            DDG13=0;
            % Calculating ....
            Q1=(1/PHI1)-1+V13+PHI2*(V12*G23-G12)-(PHI2+2*PHI3)*G13+...
                (PHI1-2*U2)*(U2^2)*DG12+3*V12*PHI2*PHI3*DG23+...
                U1*(U2^3)*DDG12+V12*PHI2*(PHI3^2)*DDG23;
            Q2=-V12+V13+(PHI2+PHI3)*(G12-G13)+V12*(PHI2-PHI3)*G23+...
                U1*U2*(U2-U1-PHI1)*DG12+V12*PHI3*(3*PHI2-PHI3)*DG23-...
                ((U1*U2)^2)*DDG12+V12*PHI2*(PHI3^2)*DDG23;
            S1=-V21+V23+(PHI1+PHI3)*(V21*G12-G23)+V21*(PHI1-PHI3)*G13+...
                V21*U1*U2*(PHI2+U2-U1)*DG12+PHI3*(3*PHI2-1)*DG23-...
                V21*((U1*U2)^2)*DDG12+PHI2*(PHI3^2)*DDG23;
            S2=(1/PHI2)-1+V23+V21*PHI1*(G13-G12)-(PHI1+2*PHI3)*G13+...
                V21*(U1^2)*(2*U1-PHI2)*DG12+PHI3*(4*PHI2+PHI1-2)*DG23+...
                V21*(U1^3)*U2*DDG12+PHI2*(PHI3^2)*DDG23;
            % Calculating ....
            DM1O1=Q1*DP1O1+Q2*DP2O1;
            DM1O2=Q1*DP1O2+Q2*DP2O2;
            DM2O1=S1*DP1O1+S2*DP2O1;
            DM2O2=S1*DP1O2+S2*DP2O2;
            % Calculuating the self diffusion coefficients from Fujita's experssion. 
            D2STAR=FUJD0*exp(PHI2/(FUJA*PHI2B+FUJB*(1-PHI1)));
            % Calculuating the friction coefficients XIij ... 
            XI12=R*TEMPIN/5.03e-5;
            XI23=(RH03*WM3)/D2STAR;
            % Shojai's C value is 2.05D-08
            XI13=2.05e-8*V12*XI23;
            % Calculating ...
            TERM1=ijOMG1(jIter,iIter)*ijOMG2(jIter,iIter)*WM1*WM2*(WM3^3);
            TERM2=WM1*WM3*XI12*XI23*ijOMG2(jIter,iIter);
            TERM3=WM2*WM3*XI13*XI12*ijOMG1(jIter,iIter);
            TERM4=WM1*WM2*XI13*XI23*ijOMG3(jIter,iIter);
            CF12G12=TERM1/(TERM2+TERM3+TERM4);
            % Calculating ...
            A=ijOMG2(jIter,iIter)*XI12/(WM2*ijOMG1(jIter,iIter))...
                +XI13*(1-ijOMG2(jIter,iIter))/(WM3*ijOMG1(jIter,iIter));
            B=XI12/WM2-XI13/WM3;
            C=ijOMG1(jIter,iIter)*XI12/(WM1*ijOMG2(jIter,iIter))...
                +XI23*(1-ijOMG1(jIter,iIter))/(WM3*ijOMG2(jIter,iIter));
            D=XI12/WM1-XI23/WM3;
            % Calculuating the functions F1, G1, H1, F2, and G2.
            F1=CF12G12*(C*DM1O1+B*DM2O1);
            F2=CF12G12*(D*DM1O1+A*DM2O1);
            G1=CF12G12*(C*DM1O2+B*DM2O2);
            G2=CF12G12*(D*DM1O2+A*DM2O2);
            StorageF1(jIter,iIter)=F1;
            StorageF2(jIter,iIter)=F2;
            StorageG1(jIter,iIter)=G1;
            StorageG2(jIter,iIter)=G2;
            % dj 1 & 2
            % Pre-allocation
            Temp1=zeros(2,1);
            Temp2=zeros(2,1);
            Temp3=zeros(2,1);
            Temp4=zeros(2,1);
            for ii=1:2
                ss=jIter+ii-2;
                % Calculating ....
                Q1=(1/PHI1)-1+V13+PHI2*(V12*G23-G12)-(PHI2+2*PHI3)*G13+...
                    (PHI1-2*U2)*(U2^2)*DG12+3*V12*PHI2*PHI3*DG23+...
                    U1*(U2^3)*DDG12+V12*PHI2*(PHI3^2)*DDG23;
                Q2=-V12+V13+(PHI2+PHI3)*(G12-G13)+V12*(PHI2-PHI3)*G23+...
                    U1*U2*(U2-U1-PHI1)*DG12+V12*PHI3*(3*PHI2-PHI3)*DG23-...
                    ((U1*U2)^2)*DDG12+V12*PHI2*(PHI3^2)*DDG23;
                S1=-V21+V23+(PHI1+PHI3)*(V21*G12-G23)+V21*(PHI1-PHI3)*G13+...
                    V21*U1*U2*(PHI2+U2-U1)*DG12+PHI3*(3*PHI2-1)*DG23-...
                    V21*((U1*U2)^2)*DDG12+PHI2*(PHI3^2)*DDG23;
                S2=(1/PHI2)-1+V23+V21*PHI1*(G13-G12)-(PHI1+2*PHI3)*G13+...
                    V21*(U1^2)*(2*U1-PHI2)*DG12+PHI3*(4*PHI2+PHI1-2)*DG23+...
                    V21*(U1^3)*U2*DDG12+PHI2*(PHI3^2)*DDG23;
                % Calculating ....
                ABODON=GAMMA+ALPHA*ijOMG1(jIter,iIter)+BETA*ijOMG2(jIter,iIter); % Dominator of PHI
                DP1O1=ETA*(BETA*ijOMG2(jIter,iIter)+GAMMA)/(ABODON^2);
                DP2O1=-LAMBDA*ijOMG2(jIter,iIter)*ALPHA/(ABODON^2);
                DP1O2=-ETA*ijOMG1(jIter,iIter)*BETA/(ABODON^2);
                DP2O2=LAMBDA*(ALPHA*ijOMG1(jIter,iIter)+GAMMA)/(ABODON^2);
                SUMO1=DP1O1+DP2O1;
                SUMO2=DP1O2+DP2O2;
                if SUMO1~=0 || SUMO2~=0
                    DP1O1=0.5;
                    DP2O1=-0.5;
                    DP1O2=-0.5;
                    DP2O2=0.5;
                end
                % Calculating ....
                DM1O1=Q1*DP1O1+Q2*DP2O1;
                DM1O2=Q1*DP1O2+Q2*DP2O2;
                DM2O1=S1*DP1O1+S2*DP2O1;
                DM2O2=S1*DP1O2+S2*DP2O2;
                Temp1(ii)=DM1O1;
                Temp2(ii)=DM1O2;
                Temp3(ii)=DM2O1;
                Temp4(ii)=DM2O2;
            end
            % Calculating ....
            dDM1O1dz=(Temp1(2)-Temp1(1))/dz;
            dDM1O2dz=(Temp2(2)-Temp2(1))/dz;
            dDM2O1dz=(Temp3(2)-Temp3(1))/dz;
            dDM2O2dz=(Temp4(2)-Temp4(1))/dz;
            % Calculating ...
            DUMMY=(ijOMG1(jIter,iIter)*ijOMG2(jIter,iIter)*WM1*WM2*(WM3^3))^2;
            TERM1=ijOMG2(jIter,iIter)*WM1*WM2*(WM3^2);
            TERM2=WM1*WM3*XI12*XI23*ijOMG2(jIter,iIter);
            TERM3=WM2*WM3*XI13*XI12*ijOMG1(jIter,iIter);
            TERM4=WM1*WM2*XI13*XI23*ijOMG3(jIter,iIter);
            TERM5=ijOMG1(jIter,iIter)*ijOMG2(jIter,iIter)*WM1*WM2*(WM3^2);
            TERM6=WM2*WM3*XI13*XI12;
            TERM7=WM1*WM2*XI13*XI23;
            TERM8=ijOMG1(jIter,iIter)*WM1*WM2*(WM3^2);
            TERM9=WM1*WM3*XI12*XI23*ijOMG2(jIter,iIter);
            TERM10=WM2*WM3*XI13*XI12*ijOMG1(jIter,iIter);
            TERM11=WM1*WM2*XI12*XI23*ijOMG3(jIter,iIter);
            TERM12=ijOMG1(jIter,iIter)*ijOMG2(jIter,iIter)*WM1*WM2*(WM3^2);
            TERM13=WM1*WM3*XI12*XI23;
            TERM14=WM1*WM2*XI13*XI23;
            SENT1=(-TERM1*(TERM2+TERM3+TERM4)+TERM5*(TERM6-TERM7))/DUMMY;
            SENT2=(-TERM8*(TERM9+TERM10+TERM11)+TERM12*(TERM13-TERM14))/DUMMY;
            diffBDCA=SENT1*dOMG1dz(jIter,iIter)+SENT2*dOMG2dz(jIter,iIter);
            dA=(-(XI12*ijOMG2(jIter,iIter)/WM2+XI13*(1-ijOMG1(jIter,iIter))...
                /WM3)/(ijOMG1(jIter,iIter)))*dOMG1dz(jIter,iIter)+...
                dOMG2dz(jIter,iIter)*(XI12/WM2-XI13/WM3)/ijOMG1(jIter,iIter);
            dB=0;
            dC=(XI12/ijOMG2(jIter,iIter)/WM1-XI23/ijOMG2(jIter,iIter)/WM3)...
                *dOMG1dz(jIter,iIter)-((ijOMG1(jIter,iIter)*XI12/WM1+...
                (1-ijOMG1(jIter,iIter))*XI23/WM3)/(ijOMG2(jIter,iIter)^2))...
                *dOMG2dz(jIter,iIter);
            dD=0;
            dF1dz=diffBDCA*(C*DM1O1+B*DM2O1)+...
                CF12G12*(C*dDM1O1dz+DM1O1*dC+B*dDM2O1dz+dB*DM2O1);
            dG1dz=diffBDCA*(C*DM1O2+B*DM2O2)+...
                CF12G12*(C*dDM1O2dz+DM1O2*dC+B*dDM2O2dz+dB*DM2O2);
            dF2dz=diffBDCA*(D*DM1O1+A*DM2O1)+...
                CF12G12*(D*dDM1O1dz+DM1O1*dD+A*dDM2O1dz+dA*DM2O1);
            dG2dz=diffBDCA*(D*DM1O2+A*DM2O2)+...
                CF12G12*(D*dDM1O2dz+DM1O2*dD+A*dDM2O2dz+dA*DM2O2);
            % Calculating dj1, dj2
            djFlux1=dF1dz*dOMG1dz(jIter,iIter)+dG1dz*dOMG2dz(jIter,iIter)...
                +F1*d2OMG1dz(jIter,iIter)+G1*d2OMG2dz(jIter,iIter);
            djFlux2=dF2dz*dOMG1dz(jIter,iIter)+dG2dz*dOMG2dz(jIter,iIter)...
                +F2*d2OMG1dz(jIter,iIter)+G2*d2OMG2dz(jIter,iIter);
            if djFlux1<=0 || djFlux2<=0
                djFlux1=2.5e-4;
                djFlux2=2.5e-4;
            end
            dJ1(jIter,iIter)=djFlux1;
            dJ2(jIter,iIter)=djFlux2;
            % Velocity
            % Calculation ....
            TERM1=F1*dOMG1dz(jIter,iIter)+G1*dOMG2dz(jIter,iIter);
            TERM2=F2*dOMG1dz(jIter,iIter)+G2*dOMG2dz(jIter,iIter);
            % Velocity
            VEL=(RH013/(RH01*RH03))*TERM1+(RH023/(RH02*RH03))*TERM2;
            if VEL==0
                VEL=-1e-2;
            end
            vel(jIter,iIter)=VEL; 
            % New 
            ijOMG1(jIter,iIter+1)=ijOMG1(jIter,iIter)...
                -(dOMG1dz(jIter,iIter)*vel(jIter,iIter)+d2OMG1dz(jIter,iIter)...
                *dJ1(jIter,iIter)/rho(jIter,iIter))*dt;
            ijOMG2(jIter,iIter+1)=ijOMG2(jIter,iIter)...
                -(dOMG2dz(jIter,iIter)*vel(jIter,iIter)+d2OMG2dz(jIter,iIter)...
                *dJ2(jIter,iIter)/rho(jIter,iIter))*dt;
            ijOMG3(jIter,iIter+1)=1-...
                (ijOMG1(jIter,iIter+1)+ijOMG2(jIter,iIter+1));
            % Finite Integration over Time
            %ijOMG1(jIter,iIter+1)=ijOMG1(jIter,iIter)...
            %    -((dJ1(jIter,iIter)/rho(jIter,iIter))+vel(jIter,iIter)...
            %    *dOMG1dz(jIter,iIter))*dt;
            %ijOMG2(jIter,iIter+1)=ijOMG2(jIter,iIter)...
            %    -((dJ2(jIter,iIter)/rho(jIter,iIter))+vel(jIter,iIter)...
            %    *dOMG2dz(jIter,iIter))*dt;
            %ijOMG3(jIter,iIter+1)=1-...
            %    (ijOMG1(jIter,iIter+1)+ijOMG2(jIter,iIter+1));
        end
    end
    ijOMG1(1,iIter+1)=ijOMG1(2,iIter+1);
    ijOMG2(1,iIter+1)=ijOMG2(2,iIter+1);
    ijOMG3(1,iIter+1)=ijOMG3(2,iIter+1);
     % Finite Integration over Time
     % ijOMG1(3:end,iIter+1)=ijOMG1(3:end,iIter)...
     %    -((dJ1(3:end,iIter)./rho(3:end,iIter))+vel(3:end,iIter)...
     %    .*dOMG1dz(3:end,iIter)).*dt;
     %ijOMG2(3:end,iIter+1)=ijOMG2(3:end,iIter)...
     %    -((dJ2(3:end,iIter)./rho(3:end,iIter))+vel(3:end,iIter)...
     %    .*dOMG2dz(3:end,iIter)).*dt;
     %ijOMG3(3:end,iIter+1)=1-...
     %    (ijOMG1(3:end,iIter+1)+ijOMG2(3:end,iIter+1));
end
% End