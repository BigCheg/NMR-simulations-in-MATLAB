function plot1D(y,type,dim)
%  plot1D : Plot 1D data correctly formatted
%
%  Synopsis:
%   
%  Input:
%     y : 1D data to plot
%     type : type of data 'FID': FID 'SPE': spectrum
%
%  Output:
%     Plot

if nargin<3
    dim=2;
end

switch dim
    case 2
        lf=evalin('base','f2.lf');
        hf=evalin('base','f2.hf');
        fu=evalin('base','f2.fu');
        sw=evalin('base','f2.sw');
        is=evalin('base','dat.is');
    case 1
        lf=evalin('base','f1.lf');
        hf=evalin('base','f1.hf');
        fu=evalin('base','f1.fu');
        sw=evalin('base','f1.sw');
        is=evalin('base','dat.is');
end

switch type
    case 'FID'
        x=getTime(y,sw);
    case 'SPE'
        x=getFrequency(y,lf,hf);
end

p=plot(x,real(y));
p.Color='black';
p.LineWidth=1;
xlimits=[min(x),max(x)];
ylimits=[min(real(y)),max(real(y))];
ax=gca;
ax.XLim=xlimits;
ax.YLim=ylimits;

switch type
    case 'FID'
        ax.XLabel.String='time / s';
    case 'SPE'
        ax.XDir='reverse';
        switch dim
            case 2
                ax.XLabel.String=['\delta [',is,'] / ',fu];
            case 1
                ax.XLabel.String=['\nu_{1} / ',fu];
        end
end
