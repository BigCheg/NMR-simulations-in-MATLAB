% Close previous plots

close all;

% Load previous processing

dat.inDir=uigetdir('/Users/pczjt/Documents/Research/Data/Bruker');
load ([dat.inDir,'/processing.mat']);

% Process 1st row

fid=extractRow(dat.ser,1);
fid=windowFID(fid,f2.sw,f2.wt,f2.wp);       % weighting
spe=FT(fid,2,f2.zf);                        % transform
spe=phaseSpectrum0(spe,f2.th0);             % phase
spe=phaseSpectrum1(spe,f2.fq,f2.th1,f2.pv);

% Find cross-sections to fit

figure;
plot1D(spe,'SPE');                          % plot 1st row 
h=msgbox('Click to select peaks then press return to finish',...
    'Pick Peaks ...','replace');
uiwait(h);
clear h;
[dat.ppm,y]=ginput;              
clear fid spe ;
for i=1:size(dat.ppm,1)
    n=round((dat.ppm(i)-f2.lf)/f2.dr);
    dat.xsection(:,i)=extractCol(dat.smx,n);
end
clear i n y;

% Set limits for fitting

[m,i]=max(max(dat.xsection));
figure;
plot1D(dat.xsection(:,i),'SPE',1);
h=msgbox('Click to select f1 limits for fitting',...
    'Select Limits ...','replace');
uiwait(h);
[f1.li,y]=ginput(2);
f1.li=sort(f1.li);
f1.dr=(f1.hf-f1.lf)/(length(dat.xsection)-1);
f1.fl=round((f1.li(1)-f1.lf)/f1.dr);
f1.fh=round((f1.li(2)-f1.lf)/f1.dr);
clear h i m x y;

