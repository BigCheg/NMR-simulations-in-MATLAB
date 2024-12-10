function plotWindow(h,t,f,w)

% Plot

if nargin < 4
    w=zeros(size(t));
end

f=normalize(f);
xlimits=[min(t),max(t)];
ylimits=[min(real(f)),max(max(real(f),w))];

p=plot(t,real(f));
set(p,'color','black','LineWidth',1);
set(h,'xlim',xlimits,'ylim',ylimits);

set(h,'NextPlot','add');
p=plot(t,w);
set(p,'color','red');
set(h,'NextPlot','replace');