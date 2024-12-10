function a=normalize(a)
%  normalize : scale maximum real a to 1 
%  
%  Synopsis:
%     a=normalize(a)
%   
%  Input:
%     a
%  Output:
%     a

% normalize

n=max(max(real(a)));
a=a.*complex(1./n,0);

end




