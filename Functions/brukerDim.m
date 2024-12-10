function d=brukerDim(dname)
%  spinsightDim : Find the dimensions of a bruker data file
%
%  Synopsis:
%     d=brukerPar(dname)
%   
%  Input:
%     dname : the Spinsight directory
%  Output:
%     d : dimensions

% Look for acqu2 file

fname=[dname,'/acqu2'];
fin=fopen(fname,'r');
if fin < 0
  d=1;
else
  d=2;
end





