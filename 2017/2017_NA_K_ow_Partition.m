clear
clc
load Partition.mat
dss=[linspace(1e-7,1e-6,10) linspace(1e-6,1e-5,10) linspace(1e-5,1e-4,10) linspace(1e-4,1e-3,10) ...
    linspace(1e-3,1e-2,10) linspace(1e-2,1e-1,10) linspace(1e-1,1,10) linspace(2,10,10)];
for i=1:length(RhoMw)
    Iter=0;
    Result=[];
    for dds=1:length(dss)
        dS=dss(dds);
        Iter=Iter+1;
        a1=-RhoMw(i)*(X12W(i)-X12P(i)*dS)/(X12W(i)-X12P(i)*(dS^2));
        a2=(RhoMw(i)^2)*(X12W(i)-X12P(i)+log(1/dS))/(X12W(i)-X12P(i)*(dS^2));
        a3=(RhoMw(i)^2)*(1-dS)/((X12W(i)-X12P(i)*(dS^2))*dS);
        Q=(3*a2-a1^2)/9;
        R=(9*a1*a2-27*a3-2*(a1^3))/54;
        S=(R+sqrt(Q^3+R^2))^(1/3);
        T=(R-sqrt(Q^3+R^2))^(1/3);
        x1=S+T-a1/3;
        x2=-(S+T)/2-a1/3+sqrt(-1)*sqrt(3)*(S-T)/2;
        x3=-(S+T)/2-a1/3-sqrt(-1)*sqrt(3)*(S-T)/2;
        x1=real(x1);
        x2=real(x2);
        x3=real(x3);
        Result(Iter,:)=[dS x1 dS*x1 x2 dS*x2 x3 dS*x3];
    end
    xlswrite('Samplers1.xlsx',Result,num2str(i))
end
