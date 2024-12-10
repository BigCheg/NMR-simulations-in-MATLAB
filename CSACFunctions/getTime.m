function  time=getTime(y,sw)
%  getTime : make time scale
%
%  Synopsis:
%     getTime(y,sw)
%   
%  Input:
%     y : complex vector of FID values
%     sw : spectral width
%  Output:
%     time : array of frequency values

% Make time array

dw=1/sw;
time=0:dw:(size(y)-1)*dw;
time=time';

end

