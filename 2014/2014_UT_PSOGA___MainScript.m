% MainScript 
tic
%
% New controllers
IndexGA_i = [];
IndexGA_j = [];
IndexPSO_i = [];
IndexPSO_j = [];
save IndexGA.mat IndexGA_i IndexGA_j;
save IndexPSO.mat IndexPSO_i IndexPSO_j;
save GAData.mat IndexGA_i IndexGA_j;
save PSOData.mat IndexPSO_i IndexPSO_j;
% #########################################################################
% Phase # 01 - Particle Swarm Optimization (PSO) algorithm - [as Minimzer]
% Particle Swarm Optimization - PSO, Haupt & Haupt, 2003 
% @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%global NFE;
%NFE=0;
ObjFun=@(x) ObjectiveFunctionsPSO(x);  % Objective Function Nested M-file
nVar=3;       		     % Number of Decision Variables
VarSize=[1 nVar];            % Size of Decision Variables Matrix
% design variables bounds
%   CompressorPressureRatio > [1 100] 
%   TurbinePressureRatio > [0 1]
%   TowerHeight > [40 200]
%   N > [100 1e5]
% 	SolarShareFactor > [0 1 ]
%VarMin=[1 12e-3 40 500 1e-3];          % Lower Bound of Variables
%VarMax=[13.2 0.1 200 2e3 0.8];          % Upper Bound of Variables
VarMin=[10.8 40 500];          % Lower Bound of Variables
VarMax=[13.2 200 2e3];          % Upper Bound of Variables
% PSO Parameters
MaxIt=10;                  % Maximum Number of Iterations
nPop=10;                   % Population Size (Swarm Size)
% Constriction Coefficients
phi1=2.05;
phi2=2.05;
phi=phi1+phi2;
chi=2/(phi-2+sqrt(phi^2-4*phi));
w=chi;          		     % Inertia Weight
wdamp=1;                     % Inertia Weight Damping Ratio
c1=chi*phi1;                 % Personal Learning Coefficient
c2=chi*phi2;                 % Global Learning Coefficient
% Velocity Limits
VelMax=0.1*(VarMax-VarMin);
VelMin=-VelMax;
% Initialization
empty_particle.Position=[];
empty_particle.Fun=[];
empty_particle.Sol=[];
empty_particle.Velocity=[];
empty_particle.Best.Position=[];
empty_particle.Best.Fun=[];
particle=repmat(empty_particle,nPop,1);
GlobalBest.Fun01=inf;
GlobalBest.Fun02=inf;
GlobalBest.Fun03=inf;
GlobalBest.Fun04=inf;
for i=1:nPop
    IndexPSO_i = i;
    IndexPSO_j = 1;
    save IndexPSO.mat IndexPSO_i IndexPSO_j;
    % Initialize Position
    particle(i).Position=unifrnd(VarMin,VarMax,VarSize);
    % Initialize Velocity
    particle(i).Velocity=zeros(VarSize);
    % Evaluation
    PSOevalOUT = ObjFun(particle(i).Position);
    % PSOoutputEval = [Cost.TotalCapital; LCOEsolar; CO2factor;
    % FuelEfficiency]
    particle(i).Fun01 = PSOevalOUT(1,:);
    particle(i).Fun02 = PSOevalOUT(2,:);
    particle(i).Fun03 = PSOevalOUT(3,:);
    particle(i).Fun04 = 1./PSOevalOUT(4,:);
    % Update Personal Best
    particle(i).Best.Position=particle(i).Position;
    particle(i).Best.Fun01=particle(i).Fun01;
    particle(i).Best.Fun02=particle(i).Fun02;
    particle(i).Best.Fun03=particle(i).Fun03;
    particle(i).Best.Fun04=particle(i).Fun04;
    % Update Global Best
    if ((particle(i).Best.Fun01<GlobalBest.Fun01) && ...
            (particle(i).Best.Fun02<GlobalBest.Fun01) && ...
            (particle(i).Best.Fun03<GlobalBest.Fun03) && ...
            (particle(i).Best.Fun04<GlobalBest.Fun04))
        GlobalBest=particle(i).Best;
    end
end
%BestFun=zeros(MaxIt,1);
%nfe=zeros(MaxIt,1);
% PSO Main Loop
for it=1:MaxIt
    disp(['PSO - Processed = ' num2str((it/MaxIt)*100) '%'])
    for i=1:nPop
            IndexPSO_i = i;
            IndexPSO_j = it + 1;
            save IndexPSO.mat IndexPSO_i IndexPSO_j;
        % Update Velocity
        particle(i).Velocity = w*particle(i).Velocity ...
            +c1*rand(VarSize).*(particle(i).Best.Position-particle(i).Position)...
            +c2*rand(VarSize).*(GlobalBest.Position-particle(i).Position);
        % Apply Velocity Limits
        particle(i).Velocity = max(particle(i).Velocity,VelMin);
        particle(i).Velocity = min(particle(i).Velocity,VelMax);
        % Update Position
        particle(i).Position = particle(i).Position + particle(i).Velocity;
        % Velocity Mirror Effect
        IsOutside=(particle(i).Position<VarMin | particle(i).Position>VarMax);
        particle(i).Velocity(IsOutside)=-particle(i).Velocity(IsOutside);
        % Apply Position Limits
        particle(i).Position = max(particle(i).Position,VarMin);
        particle(i).Position = min(particle(i).Position,VarMax);
        % Evaluation
        PSOevalOUT = ObjFun(particle(i).Position);
        % PSOoutputEval = [Cost.TotalCapital; LCOEsolar; CO2factor;
        % FuelEfficiency]
        particle(i).Fun01 = PSOevalOUT(1,:);
        particle(i).Fun02 = PSOevalOUT(2,:);
        particle(i).Fun03 = PSOevalOUT(3,:);
        particle(i).Fun04 = 1./PSOevalOUT(4,:);
        % Pre-Processing & Update Personal Best .....
        if particle(i).Fun01 == particle(i).Best.Fun01
            IF01 =1;
        else 
            IF01=0;
        end
        if particle(i).Fun02 == particle(i).Best.Fun02
            IF02 =1;
        else 
            IF02=0;
        end
        if particle(i).Fun03 == particle(i).Best.Fun03
            IF03 =1;
        else 
            IF03=0;
        end
        if particle(i).Fun04 == particle(i).Best.Fun04
            IF04 =1;
        else 
            IF04=0;
        end
        if (IF01==0 && IF02==0 && IF03==0 && IF04==0)
            if ((particle(i).Fun01<particle(i).Best.Fun01) && ...
                    (particle(i).Fun02<particle(i).Best.Fun02) && ...
                    (particle(i).Fun03<particle(i).Best.Fun03) && ...
                    (particle(i).Fun04<particle(i).Best.Fun04))
                particle(i).Best.Position=particle(i).Position;
                particle(i).Best.Fun01=particle(i).Fun01;
                particle(i).Best.Fun02=particle(i).Fun02;
                particle(i).Best.Fun03=particle(i).Fun03;
                particle(i).Best.Fun04=particle(i).Fun04;
            end
        elseif (IF01==0 && IF02==0 && IF03==0 && IF04~=0)
            if ((particle(i).Fun01<particle(i).Best.Fun01) && ...
                    (particle(i).Fun02<particle(i).Best.Fun02) && ...
                    (particle(i).Fun03<particle(i).Best.Fun03))
                particle(i).Best.Fun01=particle(i).Fun01;
                particle(i).Best.Fun02=particle(i).Fun02;
                particle(i).Best.Fun03=particle(i).Fun03;
            end
        elseif (IF01==0 && IF02==0 && IF03~=0 && IF04==0)
            if ((particle(i).Fun01<particle(i).Best.Fun01) && ...
                    (particle(i).Fun02<particle(i).Best.Fun02) && ...
                    (particle(i).Fun04<particle(i).Best.Fun04))
                particle(i).Best.Fun01=particle(i).Fun01;
                particle(i).Best.Fun02=particle(i).Fun02;
                particle(i).Best.Fun04=particle(i).Fun04;
            end
        elseif (IF01==0 && IF02~=0 && IF03==0 && IF04==0)
            if ((particle(i).Fun01<particle(i).Best.Fun01) && ...
                    (particle(i).Fun03<particle(i).Best.Fun03) && ...
                    (particle(i).Fun04<particle(i).Best.Fun04))
                particle(i).Best.Fun01=particle(i).Fun01;
                particle(i).Best.Fun03=particle(i).Fun03;
                particle(i).Best.Fun04=particle(i).Fun04;
            end
        elseif (IF01~=0 && IF02==0 && IF03==0 && IF04==0)
            if ((particle(i).Fun02<particle(i).Best.Fun02) && ...
                    (particle(i).Fun03<particle(i).Best.Fun03) && ...
                    (particle(i).Fun04<particle(i).Best.Fun04))
                particle(i).Best.Fun02=particle(i).Fun02;
                particle(i).Best.Fun03=particle(i).Fun03;
                particle(i).Best.Fun04=particle(i).Fun04;
            end
        elseif (IF01~=0 && IF02~=0 && IF03==0 && IF04==0)
            if ((particle(i).Fun03<particle(i).Best.Fun03) && ...
                    (particle(i).Fun04<particle(i).Best.Fun04))
                particle(i).Best.Fun03=particle(i).Fun03;
                particle(i).Best.Fun04=particle(i).Fun04;
            end
        elseif (IF01~=0 && IF02==0 && IF03~=0 && IF04==0)
            if ((particle(i).Fun02<particle(i).Best.Fun02) && ...
                    (particle(i).Fun04<particle(i).Best.Fun04))
                particle(i).Best.Fun02=particle(i).Fun02;
                particle(i).Best.Fun04=particle(i).Fun04;
            end
        elseif (IF01~=0 && IF02==0 && IF03==0 && IF04~=0)
            if ((particle(i).Fun02<particle(i).Best.Fun02) && ...
                    (particle(i).Fun03<particle(i).Best.Fun03))
                particle(i).Best.Fun02=particle(i).Fun02;
                particle(i).Best.Fun03=particle(i).Fun03;
            end
        elseif (IF01==0 && IF02~=0 && IF03~=0 && IF04==0)
            if ((particle(i).Fun01<particle(i).Best.Fun01) && ...
                    (particle(i).Fun04<particle(i).Best.Fun04))
                particle(i).Best.Fun01=particle(i).Fun01;
                particle(i).Best.Fun04=particle(i).Fun04;
            end  
        elseif (IF01==0 && IF02~=0 && IF03==0 && IF04~=0)
            if ((particle(i).Fun01<particle(i).Best.Fun01) && ...
                    (particle(i).Fun03<particle(i).Best.Fun03))
                particle(i).Best.Fun01=particle(i).Fun01;
                particle(i).Best.Fun03=particle(i).Fun03;
            end                 
        elseif (IF01==0 && IF02==0 && IF03~=0 && IF04~=0)
            if ((particle(i).Fun01<particle(i).Best.Fun01) && ...
                    (particle(i).Fun02<particle(i).Best.Fun02))
                particle(i).Best.Fun01=particle(i).Fun01;
                particle(i).Best.Fun02=particle(i).Fun02;
            end  
        elseif (IF01==0 && IF02~=0 && IF03~=0 && IF04~=0)
            if particle(i).Fun01<particle(i).Best.Fun01
                particle(i).Best.Fun01=particle(i).Fun01;
            end
        elseif (IF01~=0 && IF02==0 && IF03~=0 && IF04~=0)
            if particle(i).Fun02<particle(i).Best.Fun02
                particle(i).Best.Fun02=particle(i).Fun02;
            end
        elseif (IF01~=0 && IF02~=0 && IF03==0 && IF04~=0)
            if particle(i).Fun03<particle(i).Best.Fun03
                particle(i).Best.Fun03=particle(i).Fun03;
            end
        elseif (IF01~=0 && IF02~=0 && IF03~=0 && IF04==0)
            if particle(i).Fun04<particle(i).Best.Fun04
                particle(i).Best.Fun01=particle(i).Fun01;
            end
         end
        % Update Global Best
            if ((particle(i).Best.Fun01<GlobalBest.Fun01) && ...
                    particle(i).Best.Fun02<GlobalBest.Fun02 && ...
                    particle(i).Best.Fun03<GlobalBest.Fun03 && ...
                    particle(i).Best.Fun04<GlobalBest.Fun04)
                GlobalBest=particle(i).Best;
            end
    end
    %BestFun(it)=GlobalBest.Fun;
    %nfe(it)=NFE;
    w=w*wdamp;
end
disp('CPU time for PSO')
toc
outputPSO=GlobalBest.Position;
%
xx1 = outputPSO(1);
xx2 = outputPSO(2);
xx3 = outputPSO(3);
%
xx1 = xx1 *100;
%
x_bound=[0.95*xx1 1.05*xx1; 0.9*xx2 1.1*xx2;0.9*xx3 1.1*xx3];
tic
% #########################################################################
% Phase # 02 - Genetic Algorithm - [as Maximizer]
% #########################################################################
popsize=10; % popuation size
dimension=3; % based on design variables ****
stringlength=8; % default  DO NOT MODIFY
pm=0.01; % Set Accuracy (in %)
pop=encoding(popsize,stringlength,dimension);
IndexGA_j = 1;
save IndexGA.mat IndexGA_i IndexGA_j;
pop=decoding(pop,stringlength,dimension,x_bound);
%
[choice_number01,choice_k01]=max(pop(:,stringlength*dimension+1));
[choice_number02,choice_k02]=max(pop(:,stringlength*dimension+2));
[choice_number03,choice_k03]=max(pop(:,stringlength*dimension+3));
[choice_number04,choice_k04]=max(pop(:,stringlength*dimension+4));
%
choice01=pop(choice_k01,:);
choice02=pop(choice_k02,:);
choice03=pop(choice_k03,:);
choice04=pop(choice_k04,:);
MaxIt = 10;
for i=1:MaxIt 
    IndexGA_j = i + 1;
    save IndexGA.mat IndexGA_i IndexGA_j;
    disp(['GA - Processed = ' num2str((i/MaxIt)*100) '%'])
    new_pop=cross_over(pop,popsize,stringlength,dimension);
    pop=mutation(new_pop,stringlength,dimension,pm);
    pop=decoding(pop,stringlength,dimension,x_bound);
    %
    [number01,k01]=max(pop(:,stringlength*dimension+1));
    [number02,k02]=max(pop(:,stringlength*dimension+2));
    [number03,k03]=max(pop(:,stringlength*dimension+3));
    [number04,k04]=max(pop(:,stringlength*dimension+4));
    %
    if choice_number01<number01
        choice_number01=number01;
        choice_k01=k01;
        choice01=pop(choice_k01,:);
    end
    if choice_number02<number02
        choice_number02=number02;
        choice_k02=k02;
        choice02=pop(choice_k02,:);
    end
    if choice_number03<number03
        choice_number03=number03;
        choice_k03=k03;
        choice03=pop(choice_k03,:);
    end
    if choice_number04<number04
        choice_number04=number04;
        choice_k04=k04;
        choice04=pop(choice_k04,:);
    end
    %
    pop=selection(pop,popsize,stringlength,dimension);
    [number01,m01]=min(pop(:,stringlength*dimension+1));
    [number02,m02]=min(pop(:,stringlength*dimension+2));
    [number03,m03]=min(pop(:,stringlength*dimension+3));
    [number04,m04]=min(pop(:,stringlength*dimension+4));
    % 
    pop(m01,:)=choice01;
    pop(m02,:)=choice02;
    pop(m03,:)=choice03;
    pop(m04,:)=choice04;
end
[value,x]=result(pop,stringlength,dimension,x_bound);
% End of GA
% see workspace
disp('CPU time for GA')
toc
