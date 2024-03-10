% New EstroSolvSorp
load MATRIX.mat;
% MAT ::: 1         2     3    4
% MAT ::: Pol./Sol. Estro KISI 1/V
%
iter=0;
idPolySolv=MAT(:,1)';
idEstro=MAT(:,2)';
repV=MAT(:,end)';
kiCobj=MAT(:,end-1)';
%VolFrac=linespace(0,1,1e5);
Dspace=[1e-9:1e-9:9e-9 1e-8:1e-8:9e-8 1e-7:1e-7:9e-7 1e-6:1e-6:9e-6  1e-5:1e-5:9e-5  1e-4:1e-4:9e-4 1e-3:1e-3:9e-3 1e-2:1e-2:9e-2 0.1:0.1:0.9 1.1:0.1:3];
VolFrac=linspace(0,1,1e3);
%Dspace=[linspace(0.0000001,0.99,1e7) linspace(1.001,2,1e2)];
for k=1:length(repV)
    disp(['completed: ' num2str(100*k/length(repV)) ' %']);
    for i=1:length(VolFrac)
        for j=1:length(Dspace)
            kiCnew=(-repV(k)*(Dspace(j)-1)/Dspace(j)-log(Dspace(j)))/...
                ((2-(Dspace(j)+1)*VolFrac(i))*(1-Dspace(j))*(VolFrac(i)^2));
            if (abs(kiCnew-kiCobj(k))/kiCobj(k))<1e-3
                iter=iter+1;
                % Tabulated 
                % k Pol/Sol. Estro KISIexp KISIcal 1/V D Phi
                TableResult(iter,:)=[k idPolySolv(k) idEstro(k) kiCobj(k) ...
                    kiCnew repV(k) Dspace(j) VolFrac(i)];
            end
        end
    end
end
plot(TableResult(:,end),TableResult(:,end-1).*TableResult(:,end))
                
