function  freq=getFrequency(y,l,h)
%  getFrequency : make frequency scale
%
%  Synopsis:
%     getFrequency(y,l,h)
%   
%  Input:
%     y : complex vector of SPE values
%     l : low end of scale
%     h : high end of scale
%  Output:
%     freq : array of frequency values

% Make frequency array

dr=(h-l)/(length(y)-1);
freq=l:dr:h;
freq=freq';

end

