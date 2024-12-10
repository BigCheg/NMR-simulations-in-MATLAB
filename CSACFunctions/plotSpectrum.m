function plotSpectrum(h,f,s)

colour='black';

% Plot

p=plot(h,f,real(s));
xlimits=[min(f),max(f)];
ylimits=[min(real(s)),max(real(s))];

% Format

set(p,'color',colour,'LineWidth',1);
set(h,'xlim',xlimits,'ylim',ylimits,'xdir','reverse');