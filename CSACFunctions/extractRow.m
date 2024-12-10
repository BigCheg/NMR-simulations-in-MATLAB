function row=extractRow(SER,n)
%  extractRow : extracts a row from a 2D FID
%  
%  Synopsis: row=extractRow(SER,1)
%   
%  Input:
%     SER : 2D data file
%     n : number of row to extract
%  Output:
%     row

% Extract

row=SER(n,:);
row=transpose(row);

end


