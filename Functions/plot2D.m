function plot2D(z,type)
%  plot2D : Plot 2D data correctly formatted
%
%  Synopsis:
%   
%  Input:
%     z : 2D spectrum to plot
%     type : type of data 'INT': interferogram 'SMX': 2D spectrum
%
%  Output:
%     Plot

pl=[1.0,0.75,0.5,0.3,0.2,0.1,0.5,0.25]; % default contour levels
pl=pl*max(max(real(z)));


sw1=evalin('base','sw');
lf1=evalin('base','lf');
hf1=evalin('base','hf');
fu1=evalin('base','fu');
is=evalin('base','dat.is');

% Make grid for axes N.B. size(y) is number of rows in z
% Note f1 axis based on Bruker parameter

switch type
    case 'INT'
        x=getFrequency(z(1,:),lf2,hf2);
        y=getTime(z(:,1),sw1);
        [X,Y] = meshgrid(x,y);
        p=contour(X,Y,real(z),pl);
        ax=gca;
        ax.XDir='reverse';
        ax.XLabel.String=['\delta_{2} [^{1}H] / ',fu2];
        ax.YLabel.String='time / s';
    case 'SMX'
        x=getFrequency(z(1,:),lf2,hf2);
        y=getFrequency(z(:,1),lf1,hf1);
        [X,Y] = meshgrid(x,y);
        p=contour(X,Y,real(z),pl);
        ax=gca;
        ax.XDir='reverse';
        ax.XLabel.String=['\delta_{2} [',is,'] / ',fu2];
        ax.YLabel.String=['\nu_{1} / ',fu1];
end