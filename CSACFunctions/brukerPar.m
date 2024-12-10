function par=brukerPar(dname,parname)
%  brukerPar : Find a parameter in the Bruker acqus file
%
%  Synopsis:
%     par=brukerPar(dname,parname)
%   
%  Input:
%     dname : the Bruker experiment directory
%     parname : parameter to find - currently only for single numerical parameters
%     not arrays or strings
%  Output:
%     par : parameter value

% Open parameter file

fname=[dname,'/acqus'];
fin=fopen(fname,'r');

% Error trapping

parname=upper(parname);
if (strcmp(parname,'SWH')||(strcmp(parname,'SW_H')))
  parname='SW_h';
end
parname=['##$',parname];

% Read parameter file one line at a time, searching for parname

while true
  currentLine=fgetl(fin);
  [currentLine,remain]=strtok(currentLine,'=');
  if strcmp(currentLine,parname)
      break;
  end
end
token=strtok(remain,'=');

% Bruker parameters do not have units

par=str2num(token);

end






