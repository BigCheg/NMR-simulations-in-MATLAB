function par=simpsonPar(fname,parname)
%  simpsonPar : Find a parameter in the simpson .fid file
%
%  Synopsis:
%     par=simpsonPar(fname,parname)
%   
%  Input:
%     fname : the simpson .fid
%     parname : parameter to find
%  Output:
%     par : parameter value

% Error trapping

parname=upper(parname);
    
% Open parameter file

fin=fopen(fname,'r');

% Read parameter file one line at a time, searching for parname

while ~feof(fin)
  currentLine=fgetl(fin);
  if strfind(currentLine,parname)
      break;
  end
end
[~,remain]=strtok(currentLine,'=');  % split string at equality sign
remain=strtok(remain,'=');
par=str2num(remain);

end





