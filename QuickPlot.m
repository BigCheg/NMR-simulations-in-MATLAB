%% Plotting Parameters
Additional_Sim_Scaling = 1;
SimType = '3D'; %2D or 3D
PlotMode = 'Compare'; %Solo or Compare
switch SimType
    case '2D'
        SPE = SPE*Additional_Sim_Scaling;
        switch PlotMode
            case 'Compare'
                plot(ExpX,ExpY, 'color', 'r')
                hold on
                plot(FREQ,SPE, 'color', 'k')
            case 'Solo'
                plot(FREQ,SPE, 'color', 'k')
        end
    case '3D'
        switch PlotMode
            case 'Compare'
                %% Plots Sim data
                pl=[1.0,0.9,0.75,0.6,0.5,0.45,0.4,0.35,0.3,0.25,0.2]; % default contour levels
                pl=pl*max(max(Z));
                contour(X,Y,Z,pl,'b');
                hold on
                %% Plots Experimental data    
                pl=[1.0,0.9,0.75,0.6,0.5,0.45,0.4,0.35,0.3,0.25,0.2];
                pl=pl*max(max(real(ExpZ)));
                contour(ExpX,ExpY,ExpZ,pl,'r')
                set(gca, 'XDir','reverse') %reverse x axis
                xlim([-2 30])
                hold off
            case 'Solo'
                pl=[1.0,0.9,0.75,0.6,0.5,0.45,0.4,0.35,0.3,0.25,0.2];
                pl=pl*max(max(Z));
                contour(X,Y,Z,pl,'k');
                set(gca, 'XDir','reverse') %reverse x axis
        end
end