%% Simulated

ppm = 12;

index = dsearchn(X,ppm);

Slice = Z(:,index);

%% Experimentaal
ppm = 12;
index = dsearchn(ExpX,ppm);
Slice2 = ExpZ(:,index);

%% Default Sim Scaling
maxSlice = max(Slice);
maxSlice2 = max(Slice2);
factor = maxSlice/maxSlice2;
Slice2 = Slice2*factor;


%% Bonus Sim Scaling
Slice = Slice * 1;


plot(Y,Slice)

hold on
plot(ExpY,Slice2)

hold off
