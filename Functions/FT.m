function s=FT(fid,dim,zf)
%  FT : Fourier transform FID
%  
%  Synopsis:
%     s=FT(fid,dim,zf)
%   
%  Input:
%     fid: FID
%     dim: dimension to Fourier transform
%     zf : final size (can be smaller than length(fid))
%  Output:
%     s: Spectrum

% FT

if (isvector(fid))
    if nargin < 3
        zf=length(fid);
    end
    s=fft(fid,zf);
    s=fftshift(s);
else
    if nargin < 3
        zf=size(fid,dim);
    end
    s=fft(fid,zf,dim);
    s=fftshift(s,dim);
end



