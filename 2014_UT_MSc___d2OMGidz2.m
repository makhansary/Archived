function [d2OMG1dz d2OMG2dz dOMG3dz]=d2OMGidz2(d2OMG1dz,d2OMG2dz,dOMG3dz,...
    ijOMG1,ijOMG2,jIter,iIter,dz,dzz)
% This Scripts Determines d2OMGidz2
d2OMG1dz(jIter,iIter)=(ijOMG1(jIter,iIter)-2*ijOMG1(jIter-1,iIter)...
    +ijOMG1(jIter-2,iIter))/(dzz+dz);
d2OMG2dz(jIter,iIter)=(ijOMG2(jIter,iIter)-2*ijOMG2(jIter-1,iIter)...
    +ijOMG2(jIter-2,iIter))/(dzz+dz);
d2OMG3dz(jIter,iIter)=-d2OMG1dz(jIter,iIter)-d2OMG2dz(jIter,iIter);
end
% End of nested m-file.