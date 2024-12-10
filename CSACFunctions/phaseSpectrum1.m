function s=phaseSpectrum1(s,f,theta1,pivot,dim)
%  phaseSpectrum1 : first order phase correction
%
%  Synopsis:
%     s=phaseSpectrum1(s,f,theta1,pivot,dim)
%   
%  Input:
%     s: 1D or 2D spectrum
%     theta1: first order phase correction
%     pivot: frequency pivot for first order phase correction
%
%  Output:
%     s

if nargin < 5
    dim=2;
end

% Convert to radians

theta1=pi*theta1/180.;

sw=f(end)-f(1);
theta1=theta1/sw;
offset=(f-pivot)*theta1;

if isvector(s)
    s=s.*exp(-1i*offset);
else
    switch dim
        case 2
            offset=offset';
            for i=1:size(s,1);
                s(i,:)=s(i,:).*exp(-1i*offset);
            end
        case 1
            for i=1:size(s,2);
                s(:,i)=s(:,i).*exp(-1i*offset);
            end
        otherwise
    end
end