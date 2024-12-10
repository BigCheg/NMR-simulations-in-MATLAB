
% Close previous plots

close all;

% Get directory

if ~exist('dat','var')
    dat.inDir=uigetdir('D:\PhD\Naloxone Data');
end

% Read FID and parameters

dat.ser=readBruker(dat.inDir);              % read data
[f2.lf,f2.hf,f2.fu]=brukerScale(dat.inDir);
f2.sw=brukerPar(dat.inDir,'SW_h');
f1.sw=bruker2Par(dat.inDir,'SW_h');
f1.lf=-f1.sw/2;                             % omega1 scale in Hz
f1.hf=f1.sw/2;                              % note relies on Bruker SW_h
f1.fu=' Hz';
f2.gd=brukerPar(dat.inDir,'GRPDLY');
f1.np=bruker2Par(dat.inDir,'TD');
dat.is=brukerNucl(dat.inDir);
dat.ser=brukerReshape(dat.ser,f1.np);       % make ser file

% Process data in f2

f2.zf=size(dat.ser,2);

dat.smx=FT(dat.ser,2,f2.zf);                % zero filling
dat.ser=iFT(dat.smx,2);

dat.ser=removeDF(dat.ser,f2.sw,f2.gd);     % remove group delay

f2.dc=40;
if ~isfield(f2,'wt')                        % if not previously processed
    fid=extractRow(dat.ser,2);              % note 1st row has no signal
    sfid=fid(1:size(dat.ser,2)-floor(f2.gd));
    f2.ti=getTime(sfid,f2.sw);
    [f2.wt,f2.wp]=Weighting(f2.ti,sfid);
    clear fid sfid;
end
sfid=dat.ser(:,1:size(dat.ser,2)-floor(f2.gd));
sfid=dcOffset(sfid,f2.dc);                  % dc offset and weighting on short FID
sfid=windowFID(sfid,f2.sw,f2.wt,f2.wp);
dat.ser=cat(2,sfid,dat.ser(:,size(dat.ser,2)-floor(f2.gd)+1:size(dat.ser,2)));
clear sfid;

% Transform in f2

dat.smx=FT(dat.ser,2,f2.zf);
f2.dr=(f2.hf-f2.lf)/(size(dat.smx,2)-1);    % digital resolution

% Phase in f2 based on first row

if ~isfield(f2,'th0')                       % if not previously processed
    spe=extractRow(dat.smx,2);              % note 1st row has no signal
    f2.fq=getFrequency(spe,f2.lf,f2.hf);
    [f2.th0,f2.th1,f2.pv]=Phasing(f2.fq,spe);
    clear spe;
end
dat.smx=phaseSpectrum0(dat.smx,f2.th0);
dat.smx=phaseSpectrum1(dat.smx,f2.fq,f2.th1,f2.pv);

% Process data in f1

f1.dc=40;
dat.smx=dcOffset(dat.smx,f1.dc,1);

spe=extractRow(dat.smx,2);              % note 1st row has no signal
[m,n]=max(real(spe));
clear m spe;

fid=extractCol(dat.smx,n);
f1.ti=getTime(fid,f1.sw);
[f1.wt,f1.wp]=Weighting(f1.ti,fid);
clear fid;

dat.smx=windowFID(dat.smx,f1.sw,f1.wt,f1.wp,1);

% real transform in f1

f1.zf=size(dat.ser,1)*2;
dat.smx=complex(real(dat.smx),0.);  % zero the imaginary part
dat.smx=FT(dat.smx,1,f1.zf);

% Phase in f1 based on selected column

if ~isfield(f1,'th0')                       % if not previously processed
    spe=extractCol(dat.smx,n);
    f1.fq=getFrequency(spe,f1.lf,f1.hf);
    [f1.th0,f1.th1,f1.pv]=Phasing(f1.fq,spe);
    clear spe;
end

dat.smx=phaseSpectrum0(dat.smx,f1.th0,1);
dat.smx=phaseSpectrum1(dat.smx,f1.fq,f1.th1,f1.pv,1);
dat.smx=dat.smx(size(dat.smx,1)/2+1:end,:); % +ve frequency half
f1.lf=0;
f1.sw=f1.sw/2.;

figure;
plot2D(dat.smx,'SMX');
saveas(gcf,[dat.inDir,'/spectrum.pdf'],'pdf');

figure;
dat.pro=extractCol(dat.smx,n);
f1.fq=getFrequency(dat.pro,f1.lf,f1.hf);
dat.pro=real(dat.pro);
f1.bp=32;
dat.pro=dat.pro-mean(dat.pro(end-f1.bp+1:end)); % dc baseline
[m,i]=max(dat.pro);
f1.fq=f1.fq./f1.fq(i);
clear m n i;
p=plot(f1.fq,dat.pro);
p.Color='black';
p.LineWidth=1;
xlimits=[min(f1.fq),max(f1.fq)];
ylimits=[min(dat.pro),max(dat.pro)];
ax=gca;
ax.XLim=xlimits;
ax.YLim=ylimits;
ax.XLabel.String=['\nu_{1} / \nu_{nom}'];
saveas(gcf,[dat.inDir,'/profile.pdf'],'pdf');
clear p ax xlimits ylimits;
profile(:,1)=f1.fq;
profile(:,2)=dat.pro;
dlmwrite([dat.inDir,'/profile.rf'],profile,'delimiter','\t','precision',4);
clear profile;

save([dat.inDir,'/processing.mat'],'dat','f1','f2');