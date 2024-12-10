function SPE=baselineCorrect(SPE,sw,order,points)
%  baselineCorrect : applies a polynomial baseline correction to the real
%  part of the spectrum.
%
%  Synopsis:
%     SPE=baselineCorrect(SPE,sw,order,points)
%   
%  Input:
%     SPE
%     sw
%     order  = order of polynomial
%     points = baseline points at edge of spectrum
%  Output:
%     SPE: with baseline corrected real part

% Get real part of SPE

r=real(SPE);

% Make the frequency array

dr=sw/(length(SPE)-1);
freq=-sw/2:dr:sw/2;
freq=freq';

% Extract baseline

b=vertcat(freq(1:points),freq(length(freq)-points+1:length(freq)));
y=vertcat(r(1:points),r(length(r)-points+1:length(r)));

% Fit to polynomial

p=polyfit(b,y,order);
f=polyval(p,freq);

% subtract

SPE=complex(r-f,imag(SPE));

end

