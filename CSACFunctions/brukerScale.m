function [low,high,units]=brukerScale(dname)
%  brukerScale : Put the ppm scale on Bruker data
%
%  Synopsis:
%     s=brukerScale(dname)
%   
%  Input:
%     dname : the Bruker directory
%  Output:
%     s : value

fname=[dname,'/pdata/1/procs'];
fin=fopen(fname,'r');
if fin < 0

% If procs file does not exist

  errordlg(['No procs file - adding temporary Hz scale'],'File Error');
  sw=brukerPar(dname,'SW');
  low=-sw/2; % temporary scale
  high=sw/2;
  units=' Hz';
  return;
    
else

% Read procs file

  units=' ppm';

  while true
    currentLine=fgetl(fin);
    if strfind(currentLine,'OFFSET')
      [~,remain]=strtok(currentLine,'=');  % split string at equality sign
      token=strtok(remain,'=');
      high=str2num(token);
      break;
    end
  end

% Get spectral width in ppm

  sw=brukerPar(dname,'SW');
  low=high-sw;
end

end
