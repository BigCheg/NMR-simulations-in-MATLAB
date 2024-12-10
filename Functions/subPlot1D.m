function subPlot1D(x,y,n,i,ppm)

subplot(n,1,i);
p=plot(x,real(y));
p.Color='black';
p.LineWidth=1;
xlimits=[min(x),max(x)];
ylimits=[min(real(y)),max(real(y))];
ax=gca;
ax.XLim=xlimits;
ax.YLim=ylimits;
ax.XDir='reverse';
ax.Title.String=['Cross-section at ',num2str(ppm,'%.2f'),' ppm'];