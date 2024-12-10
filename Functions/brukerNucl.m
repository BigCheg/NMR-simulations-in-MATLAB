function isotope=brukerNucl(dname)
%  brukerPar : Find the observed nucleus from the Bruker acqus file
%
%  Synopsis:
%     par=brukerNucl(dname,parname)
%   
%  Input:
%     dname : the Bruker experiment directory
%  Output:
%     mass : mass number
%     elem : element name

% Open parameter file

fname=[dname,'/acqus'];
fin=fopen(fname,'r');

% Look for NUC1

parname='##$NUC1';

% Read parameter file one line at a time, searching for parname

while true
  currentLine=fgetl(fin);
  [firstPart,secondPart]=strtok(currentLine,'=');
  if strcmp(firstPart,parname)
      break;
  end
end

isotope=strtok(secondPart,'= <');
isotope=strtok(isotope,'>');








