function FID=leftShift(FID,points)

%  leftShift : leftshift the FID by points, adding zeros at end
%
%  Synopsis:
%     FID=dcOffset(FID,points)
%   
%  Input:
%     FID,points
%  Output:
%     FID : leftshifted

if points~=0

  FID=circshift(FID,-points);
  FID(end-points+1:end)=complex(0.,0.);
  
end




