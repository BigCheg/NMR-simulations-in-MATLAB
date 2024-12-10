% Close previous plots

close all;

% Get directory

if ~exist('dat','var')
    dat.inDir=uigetdir('/Users/pczjt/Documents/Research/Data/Bruker');
end

% Read FID and parameters

dat.FID=readBruker(dat.inDir);              % read data
[f2.lf,f2.hf,f2.fu]=brukerScale(dat.inDir);
f2.sw=brukerPar(dat.inDir,'SW_h');
f2.gd=brukerPar(dat.inDir,'GRPDLY');
dat.is=brukerNucl(dat.inDir);

% Process data in f2

f2.zf=length(dat.FID);

dat.spe=FT(dat.FID,2,f2.zf);                % zero filling
dat.FID=iFT(dat.spe,2);

dat.FID=removeDF(dat.FID,f2.sw,f2.gd);     % remove group delay

f2.dc=32;
if ~isfield(f2,'wt')                        % if not previously processed
    fid=dat.FID;
    sfid=fid(1:length(fid)-floor(f2.gd));
    f2.ti=getTime(sfid,f2.sw);
    [f2.wt,f2.wp]=Weighting(f2.ti,sfid);
    clear fid sfid;
end
sfid=dat.FID(1:length(dat.FID)-floor(f2.gd));
sfid=dcOffset(sfid,f2.dc);                  % dc offset and weighting on short FID
sfid=windowFID(sfid,f2.sw,f2.wt,f2.wp);
dat.FID=cat(1,sfid,dat.FID(length(dat.FID)-floor(f2.gd)+1:length(dat.FID)));
clear sfid;

% Transform in f2

dat.spe=FT(dat.FID,2,f2.zf);
f2.dr=(f2.hf-f2.lf)/(length(dat.spe)-1);    % digital resolution

% Phase in f2 based on first row

if ~isfield(f2,'th0')                       % if not previously processed
    spe=dat.spe;
    f2.fq=getFrequency(spe,f2.lf,f2.hf);
    [f2.th0,f2.th1,f2.pv]=Phasing(f2.fq,spe);
    clear spe;
end
dat.spe=phaseSpectrum0(dat.spe,f2.th0);
dat.spe=phaseSpectrum1(dat.spe,f2.fq,f2.th1,f2.pv);
f2.fq=getFrequency(dat.spe,f2.lf,f2.hf);
plot1D(dat.spe,'SPE');
saveas(gcf,[dat.inDir,'/spectrum.pdf'],'pdf');
set(handles.axes1,'ButtonDownFcn',@findPosition);
