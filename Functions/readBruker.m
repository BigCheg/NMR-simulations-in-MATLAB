function  FID=readBruker(dname)
%  readBruker  reads data from a Bruker file including the header
%
%  Synopsis:
%     FID=readBruker(dname)
%   
%  Input:
%     sname : name of the directory containing the data
%  Output:
%     FID
%

%  open file for input, include error handling

fname=[dname,'/fid'];
fin=fopen(fname,'r','l');
if fin < 0
   fname=[dname,'/ser'];
   fin=fopen(fname,'r','l');
   if fin < 0
      errordlg(['No fid or ser file in this directory'],'Error: File Not Found');
   return;
   end
end

% read the data

data=fread(fin,'int32');
FID=complex(data(1:2:end),data(2:2:end));



