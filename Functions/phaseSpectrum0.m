function s=phaseSpectrum0(s,theta0,dim)
%  phaseSpectrum0 : zeroth order phase correction
%
%  Synopsis:
%    s=phaseSpectrum(s,theta0)
%   
%  Input:
%     s: 1D or 2D spectrum
%     theta0: zero order phase correction
%    
%  Output:
%     s

% convert to radians

if nargin < 3
    dim=2;
end

theta0=pi*theta0/180.;

% correct phase

if isvector(s)
    s=s*exp(-1i*theta0);
else
    switch dim
        case 2
            for i=1:size(s,1);
                s(i,:)=s(i,:)*exp(-1i*theta0);
            end
        case 1
            for i=1:size(s,2);
                s(:,i)=s(:,i)*exp(-1i*theta0);
            end
        otherwise            
    end
end
