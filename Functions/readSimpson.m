function  FID=readSimpson(fname)
%  readSimpson  reads data from a Simpson  file including the header
%
%  Synopsis:
%     FID=readSimpson(fname)
%   
%  Input:
%     fname : name of the file containing the data (required)
%  Output:
%     FID
%

%  open file for input, include error handling

fin=fopen(fname,'r');

% Check whether Simpson data

currentLine=fgetl(fin);
if ~(strcmp(currentLine,'SIMP'))
  errordlg(['File ',fname,' is not a Simpson file'],'Error: File Format')
end

% discard the rest of the header text

while true
  currentLine=fgetl(fin);
  if (strfind(currentLine,'DATA'))
      break;
  end
end

% read the data

data = fscanf(fin,'%f');
FID=complex(data(1:2:end),data(2:2:end));

end


