function fid=windowFID(fid,sw,wt,wp,dim)
%  windowFID : applies window function
%
%  Synopsis:
%     f=windowFID(f,sw,wt,wp)
%   
%  Input:
%     f: FID to be broadened
%     sw: spectral width
%     wt: window function type
%     wp: parameter for window function
%     dim: dimension for weighting
%  Output:
%     f: FID

if nargin<5
    dim=2;
end

% Make time array

dw=1/sw;
time=0:dw:(size(fid,dim)-1)*dw;     
time=time';                         % time is a column vector

if isvector(fid)
    l=length(fid);
else
    l=size(fid,dim);
end
    
switch wt
        case 'Exponential'
            window=exp(-time*pi*wp); % window is a column vector
        case 'Gaussian'
            window=generate(sigwin.gausswin(l*2,wp));
            window=window(l+1:l*2,:);   
        case 'Hanning'
            window=generate(sigwin.hann(l*2,'Periodic'));
            window=window(l+1:l*2,:);
        case 'None'
            window=ones(size(fid,2),1);
    end

% Apply the window function
if isvector(fid)
    
    fid=fid.*window;
else
    switch dim
        case 2
            window=window';
            for i=1:size(fid,1);
                fid(i,:)=fid(i,:).*window;
            end
        case 1
            for i=1:size(fid,2);
                fid(:,i)=fid(:,i).*window;
            end
    end
end




