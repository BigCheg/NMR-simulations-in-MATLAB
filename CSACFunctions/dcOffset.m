function fid=dcOffset(fid,points,dim)
%  dcOffset : applies a dc correction to the FID
%
%  Synopsis:
%     fid=dcOffset(fid,points)
%   
%  Input:
%    fid: FID
%    points: number of points to average for dc correction
%    dim: dimension
%  Output:
%    fid: FID

if nargin<3
    dim = 2;
end

if points~=0
    if isvector(fid)
       re=real(fid);
       im=imag(fid);
       re=re-mean(re(end-points+1:end));
       im=im-mean(im(end-points+1:end));
       fid=complex(re,im);
    else
        switch dim
            case 2
                for i=1:size(fid,1);
                    re=real(fid(i,:));
                    im=imag(fid(i,:));
                    re=re-mean(re(end-points+1:end));
                    im=im-mean(im(end-points+1:end));
                    fid(i,:)=complex(re,im);
                end
            case 1
                for i=1:size(fid,2);
                    re=real(fid(:,i));
                    im=imag(fid(:,i));
                    re=re-mean(re(end-points+1:end));
                    im=im-mean(im(end-points+1:end));
                    fid(:,i)=complex(re,im);
                end
        end
    end
end





