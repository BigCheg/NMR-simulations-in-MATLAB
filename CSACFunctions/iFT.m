function fid=iFT(s,dim)

%  FT : Inverse Fourier transform FID
%  Synopsis:
%     fid=iFT(s,dim)
%   
%  Input:
%     s : spectrum
%     dim: dimension to Fourier transform
%  Output:
%     f : FID

% FT

if nargin < 2
    dim=1;
end

if (isvector(s))
    s=ifftshift(s);
    fid=ifft(s);
else
    s=ifftshift(s,dim);
    fid=ifft(s,[],dim);
end




