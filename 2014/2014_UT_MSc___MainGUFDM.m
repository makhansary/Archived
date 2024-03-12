% Main Code
clear;
clc;
format long eng;

%PARAMETER
NPTS=131;
ncase=1047;

% Initial conditions for the problem
[OMG1IN OMG2IN OMG3IN UTOP1 UTOP2 TEMPIN]=INITIALS();

% Initialize the constants specific to the system of interest
[RH01 RH02 RH03 RH013 RH023 SV1 SV2 SV3 WM1 WM2 WM3 ...
    V1 V2 V3 R V12 V21 V13 V23 ETA LAMBDA GAMMA ALPHA BETA ...
    FUJD0 FUJA FUJB]=CONSTANTS();

% Mesh of Positions (Inner: POSITIONS.m)
X(1)=0.0;
X(NPTS)=1.0;
X=MESHS(ncase);
DX=X(end:-1:2)-X(end-1:-1:1);
DX=[DX DX(end)];
DX=fliplr(DX);
DX=DX';

% Time
timeT=2e-9;
dt=1e-11;

% Dimensions
lx=length(X);
lDx=length(DX);
lt=ceil(timeT/dt);

% Pre-allocation
[ijOMG1 ijOMG2 ijOMG3 ...
    StorageF1 StorageF2 StorageG1 StorageG2 ...
    vel rho MovingBndry PrcdTime ...
    dOMG1dz dOMG2dz dOMG3dz ...
    d2OMG1dz d2OMG2dz ...
    J1 J2 dJ1 dJ2]=PreAllocation(lx+1,lt+1);

% Estimates
% Pre-Data Served as Local Temporal Data
OMG1=OMG1IN;
OMG2=OMG2IN;
OMG3=OMG3IN;

% Initial Condition @ t=0
ijOMG1(:,1)=OMG1;
ijOMG2(:,1)=OMG2;
ijOMG3(:,1)=OMG3;

% Loop
for iIter=1:1:lt
    % Process Time
    PrcdTime(:,iIter)=iIter*dt;

    % Boundary Condition @ z=0
    ijOMG1(2,iIter)=ijOMG1(1,iIter);
    ijOMG2(2,iIter)=ijOMG2(1,iIter);
    ijOMG3(2,iIter)=ijOMG3(1,iIter);
    
    for jIter=3:1:lx+1
        % dz
        dz=DX(jIter-1);

        % Density
        RHO=DENSTY(ijOMG1,ijOMG2,jIter,iIter);
        rho(jIter,iIter)=RHO;
        
        % Coefficients of PDEs
        [F1 F2 G1 G2]=COEFFICIENTS(ijOMG1,ijOMG2,ijOMG3,jIter,iIter);
        
        % Storing F1, F2, G1, G2
        StorageF1(jIter,iIter)=F1;
        StorageF2(jIter,iIter)=F2;
        StorageG1(jIter,iIter)=G1;
        StorageG2(jIter,iIter)=G2;
        
        % Determining dOMGidz
        [dOMG1dz dOMG2dz dOMG3dz]=dOMGidz(dOMG1dz,dOMG2dz,dOMG3dz,...
			ijOMG1,ijOMG2,ijOMG3,jIter,iIter,dz);
               
        % Determining d2OMGidz2
        dzz=DX(jIter-2);
        [d2OMG1dz d2OMG2dz]=d2OMGidz2(d2OMG1dz,d2OMG2dz,...
            ijOMG1,ijOMG2,ijOMG3,jIter,iIter,dz,dzz);
                        
        % Velocity
        VEL=VELOCITY(dOMG1dz,dOMG2dz,dOMG3dz,...
            ijOMG1,ijOMG2,ijOMG3,jIter,iIter,dz);
        vel(jIter,iIter)=VEL;

        % j 1 & 2
        %JJ=jFlux12(ijOMG1,ijOMG2,ijOMG3,dOMG1dz,dOMG2dz,jIter,iIter);
        %J1(jIter,iIter)=JJ(1);
        %J2(jIter,iIter)=JJ(2);
        
        % dj 1 & 2
        [djFlux1 djFlux2]=djFlux12(d2OMG1dz,d2OMG2dz,dOMG1dz,...
            dOMG2dz,dOMG3dz,ijOMG1,ijOMG2,ijOMG3,jIter,iIter,dz,dzz);
        dJ1(jIter,iIter)=djFlux1;
        dJ2(jIter,iIter)=djFlux2;
        
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
     % Finite Integration over Time
     ijOMG1(3:end,iIter+1)=ijOMG1(3:end,iIter)...
         -((dJ1(3:end,iIter)./rho(3:end,iIter))+vel(3:end,iIter)...
         .*dOMG1dz(3:end,iIter)).*dt;
     ijOMG2(3:end,iIter+1)=ijOMG2(3:end,iIter)...
         -((dJ2(3:end,iIter)./rho(3:end,iIter))+vel(3:end,iIter)...
         .*dOMG2dz(3:end,iIter)).*dt;
     ijOMG3(3:end,iIter+1)=1-...
         (ijOMG1(3:end,iIter+1)+ijOMG2(3:end,iIter+1));
end
% End