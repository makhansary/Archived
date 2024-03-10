function pop=decoding(pop,stringlength,dimension,x_bound)
load IndexGA.mat IndexGA_j;
popsize=size(pop,1);
temp=2.^(stringlength-1:-1:0)/(2^stringlength-1);
for i=1:dimension
    bound(i)=x_bound(i,2)-x_bound(i,1);
end
for i=1:popsize
    for j=1:dimension
        m(:,j)=pop(i,stringlength*(j-1)+1:stringlength*j);
    end
    IndexGA_i = i;
    save IndexGA.mat IndexGA_i IndexGA_j;
    x=temp*m;
    x=x.*bound+x_bound(:,1)';
    % Evaluating
    GAevalOUT = ObjectiveFunctionsGA(x);
    % GAoutputEval = [Cost.TotalCapital; LCOEsolar; CO2factor;
    % FuelEfficiency]
    pop(i,dimension*stringlength+1)= 1./GAevalOUT(1,:);
    pop(i,dimension*stringlength+2)= 1./GAevalOUT(2,:);
    pop(i,dimension*stringlength+3)= 1./GAevalOUT(3,:);
    pop(i,dimension*stringlength+4)= GAevalOUT(4,:);
end
