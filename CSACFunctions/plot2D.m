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

%pl=[1,0.95,0.9,0.85,0.8,0.75,0.7,0.65,0.6,0.55,0.5,0.49,0.48,0.47,0.46,0.45,0.44,0.43,0.42,0.41,0.4,0.39,0.38,0.37,0.36,0.35,0.34,0.33,0.32,0.31,0.3,0.29,0.28,0.27,0.26,0.25,0.24,0.23,0.22,0.21,0.2,0.19,0.18,0.17,0.16,0.15,0.14,0.13,0.12,0.11,0.1];
pl=[1.0,0.95,0.9,0.85,0.8,0.75,0.7,0.65,0.6,0.55,0.5,0.45,0.4,0.35,0.3,0.20]; % default contour levels
pl=pl*max(max(real(z)));

lf2=evalin('base','f2.lf');
hf2=evalin('base','f2.hf');
fu2=evalin('base','f2.fu');
sw1=evalin('base','f1.sw');
lf1=evalin('base','f1.lf');
hf1=evalin('base','f1.hf');
fu1=evalin('base','f1.fu');
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