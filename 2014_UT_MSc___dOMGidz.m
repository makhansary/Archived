function [dOMG1dz dOMG2dz dOMG3dz]=dOMGidz(dOMG1dz,dOMG2dz,dOMG3dz,...
    ijOMG1,ijOMG2,ijOMG3,jIter,iIter,dz)
% Determining dOMGidz
dOMG1=ijOMG1(jIter,iIter)-ijOMG1(jIter-1,iIter);
dOMG2=ijOMG2(jIter,iIter)-ijOMG2(jIter-1,iIter);
dOMG3=ijOMG3(jIter,iIter)-ijOMG3(jIter-1,iIter);
%
dOMG1dz(jIter,iIter)=dOMG1/dz;
dOMG2dz(jIter,iIter)=dOMG2/dz;
dOMG3dz(jIter,iIter)=dOMG3/dz;
end
% End of nested m-file.