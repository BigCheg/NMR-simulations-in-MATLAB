% R

% Find file

[inFile,inDir]=uigetfile('*.fid','Select Simpson file');
data=readSimpson([inDir,inFile]);

% Make scale

sw=simpsonPar([inDir,inFile],'SW');
lf=-sw/2; % temporary scale
hf=sw/2;
fu=' Hz';

% Parameters

dc = 32;
ls = 0;


FID=extractCol(data,1);
ti=getTime(FID,sw);
[wt,wp]=Weighting(ti,FID);
clear x y n;    


zf = 256;
bo = 1;
bp = 32;

% Process

% disp('Note: no dc offset correction')

FID=normalize(FID);
FID=dcOffset(FID,dc);
FID=leftShift(FID,ls);
FID=windowFID(FID,sw,wt,wp);
SPE=FT(FID,zf);
% SPE=phaseSpectrum0(SPE,-90.);
SPE=baselineCorrect(SPE,sw,bo,bp);
FREQ=getFrequency(SPE,lf,hf);
% [th0,th1,pv]=Phasing(FREQ,SPE);
plotSpectrum(gca,FREQ,SPE);
shg
