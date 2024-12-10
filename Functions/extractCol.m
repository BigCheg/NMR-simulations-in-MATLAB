function col=extractCol(SPE2,n)
%  extractCol : extracts a column from a 2D FID
%  
%  Synopsis: col=extractCol(SER,n)
%   
%  Input:
%     SER : 2D data file
%     n : number of col to extract
%  Output:
%     col

% Extract

col=SPE2(:,n);

end


