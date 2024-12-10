function fid=removeDF(fid,sw,gd)
%  removeDF : deal with digital filter; note only in f2
%
%  Synopsis:
%     fid=removeDF(fid,sw,gf)
%   
%  Input:
%     fid: FID
%     sw : spectral width
%     gd : group delay
%
%  Output:
%     fid: FID

% Make frequency array

if isvector(fid)
    l=length(fid);
else
    l=size(fid,2);
end

dr=sw/(l-1);
freq=-sw/2:dr:sw/2;
freq=freq';

dw=1/sw;
theta=2*pi*freq*gd*dw;

s=FT(fid,2);

if isvector(fid)
    s=s.*exp(1i*theta);
else
   theta=theta';
   for i=1:size(s,1);
       s(i,:)=s(i,:).*exp(1i*theta);
   end
end
fid=iFT(s,2);