function selected=selection(pop,popsize,stringlength,dimension)
popsize_new=size(pop,1);
r=rand(1,popsize);
%
fitness1=pop(:,dimension*stringlength+1);
fitness2=pop(:,dimension*stringlength+2);
fitness3=pop(:,dimension*stringlength+3);
fitness4=pop(:,dimension*stringlength+4);
fitness1=fitness1/sum(fitness1);
fitness2=fitness2/sum(fitness2);
fitness3=fitness3/sum(fitness3);
fitness4=fitness4/sum(fitness4);
fitness1=cumsum(fitness1);
fitness2=cumsum(fitness2);
fitness3=cumsum(fitness3);
fitness4=cumsum(fitness4);
%
for i=1:popsize
    for j=1:popsize_new
        if fitness1(j)>=r(i)
            IF01=1;
        else
            IF01=0;
        end
        if fitness2(j)>=r(i)
            IF02=1;
        else
            IF02=0;
        end
        if fitness3(j)>=r(i)
            IF03=1;
        else
            IF03=0;
        end
        if fitness4(j)>=r(i)
            IF04=1;
        else
            IF04=0;
        end
        if (IF01==1 && IF02==1 && IF03==1 && IF04==1)
            selected(i,:)=pop(j,:);
            %
        elseif (IF01==1 && IF02==1 && IF03==1 && IF04~=1)
            selected(i,:)=pop(j,:);
        elseif (IF01==1 && IF02==1 && IF03~=1 && IF04==1)
            selected(i,:)=pop(j,:);
        elseif (IF01==1 && IF02~=1 && IF03==1 && IF04==1)
            selected(i,:)=pop(j,:);
        elseif (IF01~=1 && IF02==1 && IF03==1 && IF04==1)
            selected(i,:)=pop(j,:);
            %
        elseif (IF01==1 && IF02==1 && IF03~=1 && IF04~=1)
            selected(i,:)=pop(j,:);
        elseif (IF01==1 && IF02~=1 && IF03==1 && IF04~=1)
            selected(i,:)=pop(j,:);
        elseif (IF01~=1 && IF02==1 && IF03==1 && IF04~=1)
            selected(i,:)=pop(j,:);
        elseif (IF01==1 && IF02~=1 && IF03~=1 && IF04==1)
            selected(i,:)=pop(j,:);
        elseif (IF01~=1 && IF02==1 && IF03~=1 && IF04==1)
            selected(i,:)=pop(j,:);  
        elseif (IF01~=1 && IF02~=1 && IF03==1 && IF04==1)
            selected(i,:)=pop(j,:); 
            %
        elseif (IF01==1 && IF02~=1 && IF03~=1 && IF04~=1)
            selected(i,:)=pop(j,:);
        elseif (IF01~=1 && IF02==1 && IF03~=1 && IF04~=1)
            selected(i,:)=pop(j,:);
        elseif (IF01~=1 && IF02~=1 && IF03==1 && IF04~=1)
            selected(i,:)=pop(j,:);
        elseif (IF01~=1 && IF02~=1 && IF03~=1 && IF04==1)
            selected(i,:)=pop(j,:);
            %
        end
    end
end