function SER=brukerReshape(FID,n1)

%  brukerReshape : reshape a Bruker 2D data file
%
%  Synopsis:
%     SER=brukerReshape(FID,n1)
%   
%  Input:
%     FID : raw data
%     n1 : indirect dimension
%  Output:
%     SER


% Direct dimension

    n2=size(FID,1)/n1;

% reshape

    SER=reshape(FID,n2,n1);
    SER=transpose(SER);









