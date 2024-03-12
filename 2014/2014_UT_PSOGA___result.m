function [value,x]=result(pop,stringlength,dimension,x_bound)
%
[value.S01,k01]=max(pop(:,stringlength*dimension+1));
[value.S02,k02]=max(pop(:,stringlength*dimension+2));
[value.S03,k03]=max(pop(:,stringlength*dimension+3));
[value.S04,k04]=max(pop(:,stringlength*dimension+4));
%
if k01==k02 && k01==k03 && k01==k04
    k=k01;
end
%
if k01==k02 && k01==k03 && k01~=k04
    k=k01;
end
if k01==k02 && k01~=k03 && k01==k04
    k=k01;
end
if k01~=k02 && k01==k03 && k01==k04
    k=k01;
end
%
if k01==k02 && k01~=k03 && k01~=k04
    if k03==k04
        k=k01;
    else
    k=k01;
    end
end
if k01~=k02 && k01==k03 && k01~=k04
    if k02==k04
        k=k01;
    else
    k=k01;
    end
end
if k01~=k02 && k01~=k03 && k01==k04
    if k02==k03
        k=k01;
    else
        k=k01;
    end
end
if k01~=k02 && k01~=k03 && k01~=k04
    if k02==k03 && k02==k04
        k=k02;
    elseif k02==k03 && k02~=k04
        k=k02;
    elseif k02~=k03 && k02==k04
        k=k02;
    end
else
    k=k01;
end
%
temp=2.^(stringlength-1:-1:0)/(2^stringlength-1);
for i=1:dimension
    bound(i)=x_bound(i,2)-x_bound(i,1);
end
for j=1:dimension
    m(:,j)=pop(k,stringlength*(j-1)+1:stringlength*j);
end
x=temp*m;
x=x.*bound+x_bound(:,1)';