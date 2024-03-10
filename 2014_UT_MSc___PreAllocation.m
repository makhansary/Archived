function [ijOMG1 ijOMG2 ijOMG3 ...
    StorageF1 StorageF2 StorageG1 StorageG2 ...
    vel rho MovingBndry PrcdTime ...
    dOMG1dz dOMG2dz ...
    d2OMG1dz d2OMG2dz d2OMG3dz ...
    J1 J2 dJ1 dJ2]=PreAllocation(lx,lt)
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
MovingBndry=zeros(lx,lt);
PrcdTime=zeros(lx,lt);

% dwidz
dOMG1dz=zeros(lx,lt);
dOMG2dz=zeros(lx,lt);

% d2widz2
d2OMG1dz=zeros(lx,lt);
d2OMG2dz=zeros(lx,lt);
d2OMG3dz=zeros(lx,lt);

% j1, j2
J1=zeros(lx,lt);
J2=zeros(lx,lt);

% dJ1, dJ2
dJ1=zeros(lx,lt);
dJ2=zeros(lx,lt);
end
% End of nested m-file.