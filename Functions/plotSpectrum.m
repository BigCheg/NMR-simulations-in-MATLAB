function plotSpectrum(h,x,y,scale,colour)

% Deal with variable arguments

if nargin < 5 colour='black'; end
if nargin < 4 scale=1; end

% Plot

p=plot(h,x,real(y));
xlimits=[min(x),max(x)];
ylimits=[min(real(y)),max(real(y))/scale];

% Format

set(p,'color',colour,'LineWidth',1);
set(h,'xlim',xlimits,'ylim',ylimits,'xdir','reverse');