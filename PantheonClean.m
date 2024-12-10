clear
addpath('C:\Matlab\development_pantheon_2\Functions')
%% Settable Parameters
Magnet = 1000;                        % Magnet strength in MHz
CSA = 20;                          % 2D simulated Chemical Shift Anisotropy value
Aysm = 0.2;                         % 2D simulated Asymmetry
Spinning_Speed = 50000;              % 2D or 3D simulation spinning speed
Number_of_points = 96;               % Number of points in the f1 dimension of simulation
Crystal_file = 143;                   % Crystal file number. Typically use 20, 143, 232, 615 NOTE  takes longer
Gamma_Angle = 10;                     % Number of angles tested. ~5-10 for quick analysis,  ~32 for high quality NOTE  takes longer
DCcor = 2;                           % Number points of the FID that are averaged to bring the dipole-dipole coulping down.
Weighting_type = 'Gaussian';         % Type of weighting parameter
Weighting_value = 20;               % 'Power' of the above weighting type
Searchedppm = 9.8;                  % The ppm value that the '2D' data will compare itself to.
Additional_Sim_Scaling = 1;          % Used to bring down peak heights to combat artifact
Spectral_Width = 26041;              % Only needs to be set for R16_3_2
SimType = '3D';                      % 2D or 3D
MathType3DWeighting = 'Gauss';        % Gauss or Matt
Experiment_Type = 'SC212';            % Currently Available: R16_3_2 SC212 C313
PlotMode = 'Compare';                % Solo or Compare
ExpFile = '20220511_NalFA_NRF4_0.7mm.txt';                % Name of the bruker txt file(must be 2D) or processed .mat file for R16_3_2
ExcelProtonData = 'csatest.xlsx';  % Name of the excel file containing the CASTEP data (column 1: Iso, column 2: Aniso, column 3: Aysmmetry)
Artifact_Removal = 'Off';            % Removes the artifact at 0Hz in experimental data
Artifact_mid_point = 104;            % Moves the Artifact removal window
Artifact_Removal_width = 5;         %Sets the size of the removal window
Bonus_RFinhomogeneity = 'Off';       % Uses a larger profile for rf inhomogeneity. NOTE  takes longer
Mirror_f1 = 'Off';                    % Reverses the f1 axis
Exp_2D_Hz_width = 8000;             % Width of F1 in Hz (only affected when artifact removal is on)

%% Weighting Parameters
fu=' Hz';
ls = 0;
zf = 256;
bo = 0;
bp = 16;
nothing = 0;
Weighting_2D = ((9*10^8*(Spinning_Speed^-1.843))+0.2)/0.0757;
sigma = ((9*10^8*(Spinning_Speed^-1.843))-0.0082)/4.3026;
%% Picks Experiment
switch SimType
    case '2D'
        switch PlotMode
            case 'Compare'
                switch Experiment_Type
                    case 'R16_3_2'
                        infile = 'R16_3_2.in';
                        load(ExpFile)
                        closest = dsearchn(f2.fq,Searchedppm);
                        ExpY = dat.smx(:,closest);
                        ExpX = f1.fq;
                    case 'SC212'
                        infile = 'SC212.in';
                        Spectral_Width = Spinning_Speed/4;
                        [F1LEFT,F1RIGHT,F2LEFT,F2RIGHT,NROWS,NCOLS] = readbrukertxt(ExpFile);
                        raw = ExpFile;
                        raw = readmatrix(raw);
                        ExpZ = zeros(NROWS,NCOLS);
                        for i = 1:NROWS
                            blockstart =NCOLS*(i-1)+i;
                            blockend = NCOLS+blockstart-1;
                            ExpZ(i,:) = raw(blockstart:blockend,1);
                        end
                        f1high = F1LEFT*Magnet;
                        f1low = F1RIGHT*Magnet;
                        f2low = F2RIGHT;
                        f2high = F2LEFT;
                        ppmRangef1 = f1high+-f1low;
                        incrementsf1 = ppmRangef1/NROWS;
                        ppmRangef2 = f2high+-f2low;
                        incrementsf2 = ppmRangef2/NCOLS;
                        Expf1 = f1high:-incrementsf1:f1low;
                        Expf1 = Expf1(1:NROWS);
                        Expf2 = f2high:-incrementsf2:f2low;
                        Expf2 = Expf2(1:NCOLS);
                        Expf2 = Expf2';
                        closest = dsearchn(Expf2,Searchedppm);
                        ExpY = ExpZ(:,closest);
                        ExpX = Expf1;
                        ExpX = ExpX';
                    case 'C313'
                        infile = 'C313.in';
                        Spectral_Width = Spinning_Speed/3;
                        [F1LEFT,F1RIGHT,F2LEFT,F2RIGHT,NROWS,NCOLS] = readbrukertxt(ExpFile);
                        raw = ExpFile;
                        raw = readmatrix(raw);
                        ExpZ = zeros(NROWS,NCOLS);
                        for i = 1:NROWS
                            blockstart =NCOLS*(i-1)+i;
                            blockend = NCOLS+blockstart-1;
                            ExpZ(i,:) = raw(blockstart:blockend,1);
                        end
                        f1high = F1LEFT*Magnet;
                        f1low = F1RIGHT*Magnet;
                        f2low = F2RIGHT;
                        f2high = F2LEFT;
                        ppmRangef1 = f1high+-f1low;
                        incrementsf1 = ppmRangef1/NROWS;
                        ppmRangef2 = f2high+-f2low;
                        incrementsf2 = ppmRangef2/NCOLS;
                        Expf1 = f1high:-incrementsf1:f1low;
                        Expf1 = Expf1(1:NROWS);
                        Expf2 = f2high:-incrementsf2:f2low;
                        Expf2 = Expf2(1:NCOLS);
                        Expf2 = Expf2';
                        closest = dsearchn(Expf2,Searchedppm);
                        ExpY = ExpZ(:,closest);
                        ExpX = Expf1;
                        ExpX = ExpX';
                end


            case 'Solo'
                switch Experiment_Type
                    case 'R16_3_2'
                        infile = 'R16_3_2.in';
                    case 'SC212'
                        infile = 'SC212.in';
                    case 'C313'
                        infile = 'C313.in';
                end
        end
    case '3D'
        ExcelProtonData = readmatrix(ExcelProtonData);
        switch PlotMode
            case 'Compare'
                switch Experiment_Type
                    case 'R16_3_2'
                        infile = 'R16_3_2.in';
                        load(ExpFile)
                        ExpZ = dat.smx;
                        ExpZ = real(ExpZ);
                        ExpY = f1.fq;
                        ExpX = f2.fq;
                    case 'SC212'
                        infile = 'SC212.in';
                        Spectral_Width = Spinning_Speed/4;
                        [F1LEFT,F1RIGHT,F2LEFT,F2RIGHT,NROWS,NCOLS] = readbrukertxt(ExpFile);
                        raw = ExpFile;
                        raw = readmatrix(raw);
                        ExpZ = zeros(NROWS,NCOLS);
                        for i = 1:NROWS
                            blockstart =NCOLS*(i-1)+i;
                            blockend = NCOLS+blockstart-1;
                            ExpZ(i,:) = raw(blockstart:blockend,1);
                        end
                        f1high = F1LEFT*Magnet;
                        f1low = F1RIGHT*Magnet;
                        f2low = F2RIGHT;
                        f2high = F2LEFT;
                        ppmRangef1 = f1high+-f1low;
                        incrementsf1 = ppmRangef1/NROWS;
                        ppmRangef2 = f2high+-f2low;
                        incrementsf2 = ppmRangef2/NCOLS;
                        Expf1 = f1high:-incrementsf1:f1low;
                        Expf1 = Expf1(1:NROWS);
                        Expf2 = f2high:-incrementsf2:f2low;
                        Expf2 = Expf2(1:NCOLS);
                        ExpX = Expf2';
                        ExpY = Expf1;
                    case 'C313'
                        infile = 'C313.in';
                        Spectral_Width = Spinning_Speed/3;
                        [F1LEFT,F1RIGHT,F2LEFT,F2RIGHT,NROWS,NCOLS] = readbrukertxt(ExpFile);
                        raw = ExpFile;
                        raw = readmatrix(raw);
                        ExpZ = zeros(NROWS,NCOLS);
                        for i = 1:NROWS
                            blockstart =NCOLS*(i-1)+i;
                            blockend = NCOLS+blockstart-1;
                            ExpZ(i,:) = raw(blockstart:blockend,1);
                        end
                        f1high = F1LEFT*Magnet;
                        f1low = F1RIGHT*Magnet;
                        f2low = F2RIGHT;
                        f2high = F2LEFT;
                        ppmRangef1 = f1high+-f1low;
                        incrementsf1 = ppmRangef1/NROWS;
                        ppmRangef2 = f2high+-f2low;
                        incrementsf2 = ppmRangef2/NCOLS;
                        Expf1 = f1high:-incrementsf1:f1low;
                        Expf1 = Expf1(1:NROWS);
                        Expf2 = f2high:-incrementsf2:f2low;
                        Expf2 = Expf2(1:NCOLS);
                        ExpX = Expf2';
                        ExpY = Expf1;
                end

            case 'Solo'
                switch Experiment_Type
                    case 'R16_3_2'
                        infile = 'R16_3_2.in';
                    case 'SC212'
                        infile = 'SC212.in';
                    case 'C313'
                        infile = 'C313.in';
                end
        end
end
%% Creates .in files
mkdir RRfiles
switch SimType
    case '2D'
        text = fileread(infile);
        index = strfind(text, '0p ');
        text1 = text(1:index+2);
        tempstr = text(index+3:end);
        index = strfind(tempstr, ' ');
        index = index(1);
        text2 = tempstr(index+5:end);
        newtext1 = [text1, num2str(CSA),  'p ',  num2str(Aysm), text2] ;

        index1 = strfind(newtext1, 'spin_rate');
        text1 = newtext1(1:index1+14);
        tempstr = newtext1(index1+3:end);
        index1 = strfind(tempstr, 'np');
        index1 = index1(1);
        text2 = tempstr(index1-4:index1+5);
        text3 = tempstr(index1+19:index1+41);
        text4 = tempstr(index1+45:index1+63);
        text5 = tempstr(index1+67:index1+133);
        text6 = tempstr(index1+137:end);
        newtext1 = [text1, num2str(Spinning_Speed), text2, num2str(Number_of_points), text3, num2str(Crystal_file) , text4 ,num2str(Gamma_Angle), text5, num2str(Magnet), text6] ;

        index = strfind(newtext1, 'sw');
        text1 = newtext1(1:index+2);
        text2 = newtext1(index+12:end);
        newtext1 = [text1, num2str(Spectral_Width) text2] ;
        switch Bonus_RFinhomogeneity
            case 'On'
                text = newtext1;
                index = strfind(text, '1.3Profile.rf');
                text1 = text(1:index-1);
                text2 = text(index+13:end);
                newtext1 = [text1, 'BigProfile.rf' ,text2] ;
            case 'Off'
                nothing = 0;
        end
        filename = 'RRthing.in';
        file = fopen(filename,'w');
        fprintf(file,newtext1);
        fclose(file);
        movefile ( filename, 'RRfiles');

    case '3D'
        for i = 1:length(ExcelProtonData)
            CSA =ExcelProtonData(i,2);
            Aysm =ExcelProtonData(i,3);
            text = fileread(infile);
            index = strfind(text, '0p ');
            text1 = text(1:index+2);
            tempstr = text(index+3:end);
            index = strfind(tempstr, ' ');
            index = index(1);
            text2 = tempstr(index+5:end);
            newtext1 = [text1, num2str(CSA),  'p ',  num2str(Aysm), text2] ;
            index1 = strfind(newtext1, 'spin_rate');
            text1 = newtext1(1:index1+14);
            tempstr = newtext1(index1+3:end);
            index1 = strfind(tempstr, 'np');
            index1 = index1(1);
            text2 = tempstr(index1-4:index1+5);
            text3 = tempstr(index1+19:index1+41);
            text4 = tempstr(index1+45:index1+63);
            text5 = tempstr(index1+67:index1+133);
            text6 = tempstr(index1+137:end);
            newtext1 = [text1, num2str(Spinning_Speed), text2, num2str(Number_of_points), text3, num2str(Crystal_file) , text4 ,num2str(Gamma_Angle), text5, num2str(Magnet), text6] ;
            index = strfind(newtext1, 'sw');
            text1 = newtext1(1:index+2);
            text2 = newtext1(index+12:end);
            newtext1 = [text1, num2str(Spectral_Width) text2] ;
            switch Bonus_RFinhomogeneity
                case 'On'
                    text = newtext1;
                    index = strfind(text, '1.3Profile.rf');
                    text1 = text(1:index-1);
                    text2 = text(index+13:end);
                    newtext1 = [text1, 'BigProfile.rf' ,text2] ;
                case 'Off'
                    Existence = nothing;
            end
            filename = ['RRfiles/RR', num2str(i), '.in'];
            file = fopen(filename,'w');
            fprintf(file,newtext1);
            fclose(file);
        end
end
%% Create fid files
switch SimType
    case '2D'
        command = sprintf('simpson RRfiles/RRthing.in');
        status = system(command);
        zero = 0;
        for loop = 1:1000
            QNAN_text=fileread('RRthing.fid');
            val = strfind(QNAN_text, 'QNAN');
            if val>zero
                fprintf 'Fail'
                disp (loop)
                command = sprintf('simpson RRfiles/RRthing.in');
                status = system(command);
            end
        end
    case '3D'
        list=length(ExcelProtonData);

        for k = 1:list
            command = sprintf('simpson RRfiles/RR%g.in', k);
            status = system(command);
        end
        zero = 0;
        for loop = 1:1000
            for i = 1:list
                QNAN_text=fileread(['RR', num2str(i), '.fid']);
                val = strfind(QNAN_text, 'QNAN');
                if val>zero
                    fprintf 'Fail'
                    disp (loop)
                    fprintf 'Proton'
                    disp (k)
                    command = sprintf('simpson RRfiles/RR%g.in', i);
                    status = system(command);
                end
            end
        end
end
%% Makes Fid Directory and moves them into it
mkdir Fidfiles
switch SimType
    case '2D'
        filename = 'RRthing.fid';
        movefile ( filename, 'Fidfiles');
    case '3D'
        for t = 1:list
            filename = ['RR', num2str(t), '.fid'];
            movefile ( filename, 'Fidfiles');
        end
end
%% Data
switch SimType
    case '2D'
        switch PlotMode
            case 'Compare'
                file = 'C:\Matlab\development_pantheon_2\Fidfiles\RRthing.fid';
                x = fullfile(file);
                FID = readSimpson(x);
                sw=simpsonPar(x,'SW');
                lf=-sw/2; % temporary scale
                hf=sw/2;
            case 'Solo'
                file = 'C:\Matlab\development_pantheon_2\Fidfiles\RRthing.fid';
                x = fullfile(file);
                FID = readSimpson(x);
                sw=simpsonPar(x,'SW');
                lf=-sw/2; % temporary scale
                hf=sw/2;
        end
    case '3D'
        fids = 'C:\Matlab\development_pantheon_2\Fidfiles';
        info = dir(fullfile(fids,'*.fid'));
        list = {info.name};
        list = natsortfiles(list);

        data = {};

        for i = 1:length(list)


            x = fullfile(fids, list{i});
            FID = readSimpson(x);
            sw=simpsonPar(x,'SW');
            lf=-sw/2; % temporary scale
            hf=sw/2;

            FID=normalize(FID);
            FID=dcOffset(FID,DCcor);
            FID=leftShift(FID,ls);
            FID=windowFID(FID,sw,Weighting_type,Weighting_value);
            SPE=FT(FID,zf);
            SPE=baselineCorrect(SPE,sw,bo,bp);
            FREQ=getFrequency(SPE,lf,hf);
            SPE = real(SPE);
            data{i,1} = SPE; %#ok<SAGROW>
            data{i,2} = FREQ; %#ok<SAGROW>
        end
        %% Iso ppm values
        isofm = ExcelProtonData(:,1);
        isofm = round(isofm,1);
end
%% Processes data
switch SimType
    case '2D'
        switch Experiment_Type
            case 'R16_3_2'
                FID=normalize(FID);
                FID=dcOffset(FID,DCcor);
                FID=leftShift(FID,ls);
                FID=windowFID(FID,sw,Weighting_type,Weighting_value);
                SPE=FT(FID,zf);
                SPE=baselineCorrect(SPE,sw,bo,bp);
                FREQ=getFrequency(SPE,lf,hf);
                close all

            case 'SC212'
                FID=normalize(FID);
                FID=dcOffset(FID,DCcor);
                FID=leftShift(FID,ls);
                FID=windowFID(FID,sw,Weighting_type,Weighting_value);
                SPE=FT(FID,zf);
                SPE=baselineCorrect(SPE,sw,bo,bp);
                FREQ=getFrequency(SPE,lf,hf);
                close all

            case 'C313'
                FID=normalize(FID);
                FID=dcOffset(FID,DCcor);
                FID=leftShift(FID,ls);
                FID=windowFID(FID,sw,Weighting_type,Weighting_value);
                SPE=FT(FID,zf);
                SPE=baselineCorrect(SPE,sw,bo,bp);
                FREQ=getFrequency(SPE,lf,hf);
                close all
        end
    case '3D'
        switch MathType3DWeighting
            case 'Gauss'
                %% Weights data
                points = zeros(length(data{1,1}),270);
                X = -2:0.1:24.9;

                for i = 1:length(isofm)
                    t = isofm(i);
                    [~,u]=ismembertol(t,X);
                    p = data{i,1};
                    p = transpose(p);
                    points(:,u) = p;
                    clear t u p ~;
                end
                preweight = [];
                for i = 1:length(data{1,1})
                    datapoints = points(i,:);
                    datapoints = ifft(datapoints);
                    preweight(i,:) = datapoints; %#ok<SAGROW>
                    clear datapoints
                end
                postweight = [];
                for i = 1:length(data{1,1})
                    asd = preweight(i,:);
                    asd = transpose(asd );
                    asd  = asd (1:270);
                    asd  = windowFID(asd,sw,Weighting_type,Weighting_2D);
                    asd  = transpose(asd);
                    asd  = fft(asd );
                    postweight(i,:) = asd ; %#ok<SAGROW>
                    clear points
                end
                postweight = real(postweight);
                Z = postweight;
                Z = real(Z);
            case 'Matt'
                %% Weights data
                points = zeros(length(data{1,1}),270);
                X = -2:0.1:24.9;
                X = transpose(X);
                %% Add X slices
                for i = 1:length(isofm)
                    slice = data{i,1};
                    insertpoint = dsearchn(X,isofm(i));
                    points(:,insertpoint) = slice;
                end
                sumslice = 1:length(X);
                sumslice = sumslice*0;
                %% Weights Y slices
                for i = 1:length(slice)
                    sumslice = sumslice*0;
                    for k = 1:length(isofm)
                        for l = 1:length(X)
                            alpha = data{k,1}(i,1);
                            SliceY(l) = alpha*exp(-( (X(l) -isofm(k) ) ^2) /(2*(sigma^2))); %#ok<SAGROW>
                        end
                        sumslice = sumslice + SliceY;
                    end
                    points(i,:) = sumslice;
                end
                Z = points;
        end
end
%% Scales to Experimental data
SPE = SPE*100000;
%% Finds mid point x value
switch Experiment_Type
    case 'R16_3_2'
        SPE = real(SPE);
        lFREQ = length(FREQ);
        lFREQ = lFREQ/2;
        lFREQ = lFREQ+1;
        MidLocation = FREQ(lFREQ);
        MidCorrection = MidLocation;
        FREQ = FREQ-MidCorrection;
    case 'SC212'
        SPE = real(SPE);
    case 'C313'
        SPE = real(SPE);
end

%% Finding Mid point of Experiment data
switch SimType
    case '2D'
        switch PlotMode
            case 'Compare'
                switch Experiment_Type
                    case 'R16_3_2'
                        ExpY = real(ExpY);
                        TExpX = length(ExpX);
                        TExpX = TExpX/2;
                        TExpX = TExpX+1;
                        TExpX = round(TExpX);
                        MidLocation = ExpX(TExpX);
                        MidCorrection = MidLocation;
                        ExpX = ExpX-MidCorrection;
                    case 'SC212'
                        TExpX = length(ExpX);
                        TExpX = TExpX/2;
                        TExpX = TExpX+1;
                        TExpX = round(TExpX);
                        MidLocation = ExpX(TExpX);
                        MidCorrection = MidLocation;
                        ExpX = ExpX-MidCorrection;
                    case 'C313'
                        TExpX = length(ExpX);
                        TExpX = TExpX/2;
                        TExpX = TExpX+1;
                        TExpX = round(TExpX);
                        MidLocation = ExpX(TExpX);
                        MidCorrection = MidLocation;
                        ExpX = ExpX-MidCorrection;
                end
            case 'Solo'
                Existence = nothing;
        end
    case '3D'
        switch PlotMode
            case 'Compare'
                switch Experiment_Type
                    case 'R16_3_2'
                        TExpY = length(ExpY);
                        TExpY = TExpY/2;
                        TExpY = TExpY+1;
                        TExpY = round(TExpY);
                        MidLocation = ExpY(TExpY);
                        MidCorrection = MidLocation;
                        ExpY = ExpY-MidCorrection;
                    case 'SC212'
                        TExpY = length(ExpY);
                        TExpY = TExpY/2;
                        TExpY = TExpY+1;
                        TExpY = round(TExpY);
                        MidLocation = ExpY(TExpY);
                        MidCorrection = MidLocation;
                        ExpY = ExpY-MidCorrection;
                    case 'C313'
                        TExpX = length(ExpY);
                        TExpX = TExpX/2;
                        TExpX = TExpX+1;
                        TExpX = round(TExpX);
                        MidLocation = ExpY(TExpX);
                        MidCorrection = MidLocation;
                        ExpY = ExpY-MidCorrection;
                end
            case 'Solo'
                Existence = nothing;
        end
end
%% Fixes Experimental Background level

switch SimType
    case '2D'
        switch PlotMode
            case 'Compare'
                minval = min(ExpY);
                ExpY = ExpY-minval;
                minval = min(SPE);
                SPE = SPE-minval;
                switch Experiment_Type
                    case 'R16_3_2'
                        MaxWidth = Magnet*5+500;
                        closestpos = dsearchn(FREQ,MaxWidth);
                        closestposExp = dsearchn(f1.fq,MaxWidth);
                        OtherMaxWidth = -MaxWidth;
                        closestneg = dsearchn(FREQ,OtherMaxWidth);
                        closestnegExp = dsearchn(f1.fq,OtherMaxWidth);
                        % Sim Zeroing
                        SPE(1:closestneg)=0;
                        endval = length(SPE);
                        SPE(closestpos:endval)=0;
                        ExpY(1:closestnegExp)=0;
                        endval = length(ExpY);
                        ExpY(closestposExp:endval)=0;
                    case 'SC212'
                        MaxWidth = Magnet*5 + 50000;
                        closestpos = dsearchn(FREQ,MaxWidth);
                        closestposExp = dsearchn(ExpX,MaxWidth);
                        OtherMaxWidth = -MaxWidth;
                        closestneg = dsearchn(FREQ,OtherMaxWidth);
                        closestnegExp = dsearchn(ExpX,OtherMaxWidth);
                        % Sim Zeroing
                        SPE(1:closestneg)=0;
                        endval = length(SPE);
                        SPE(closestpos:endval)=0;
                    case 'C313'
                        MaxWidth = Magnet*5 + 50000;
                        closestpos = dsearchn(FREQ,MaxWidth);
                        closestposExp = dsearchn(ExpX,MaxWidth);
                        OtherMaxWidth = -MaxWidth;
                        closestneg = dsearchn(FREQ,OtherMaxWidth);
                        closestnegExp = dsearchn(ExpX,OtherMaxWidth);
                        % Sim Zeroing
                        SPE(1:closestneg)=0;
                        endval = length(SPE);
                        SPE(closestpos:endval)=0;
                end
            case 'Solo'
                Existence = nothing;
        end
    case '3D'
        switch PlotMode
            case 'Compare'
                minval = min(min(ExpZ));
                ExpZ = ExpZ-minval;
                switch Experiment_Type
                    case 'R16_3_2'
                        MaxWidth = Magnet*10;
                        closestposExp = dsearchn(ExpY,MaxWidth);
                        OtherMaxWidth = -MaxWidth;
                        closestnegExp = dsearchn(ExpY,OtherMaxWidth);
                        if closestnegExp<closestposExp
                            for i = 1:length(ExpX)
                                ExpZ(1:closestnegExp,i) = 0;
                                ExpZ(closestposExp:end,i) = 0;
                            end
                        else
                            for i = 1:length(ExpX)
                                ExpZ(1:closestposExp,i) = 0;
                                ExpZ(closestnegExp:end,i) = 0;
                            end
                        end
                end
            case 'Solo'
                Existence = nothing;
        end
end

%% Removal of artifact at 0Hz
switch PlotMode
    case 'Compare'
        switch Artifact_Removal
            case 'On'
                switch SimType
                    case '2D'
                        x0 = ExpX;
                        y0 = ExpY;
                        mid = dsearchn(ExpX,Artifact_mid_point);
                        x01 = x0(1:mid-Artifact_Removal_width);
                        x02 = x0(mid+Artifact_Removal_width:end);
                        y01 = y0(1:mid-Artifact_Removal_width);
                        y02 = y0(mid+Artifact_Removal_width:end);
                        y02 = fliplr(y02);
                        x0 = cat(1,x01,x02);
                        y0 = cat(1,y01,y02);
                        spl = spline(x0,y0);
                        ExpX = linspace(-Exp_2D_Hz_width/2,Exp_2D_Hz_width/2,1000);
                        ExpY = fnval(spl,ExpX);
                    case '3D'
                        for i = 1:length(ExpX)
                            y0 = ExpY;
                            z0 = ExpZ(:,i);
                            ExpYWigs = ExpY';
                            mid = dsearchn(ExpYWigs,Artifact_mid_point);
                            y01 = y0(1:mid-Artifact_Removal_width);
                            y02 = y0(mid+Artifact_Removal_width:end);
                            z01 = z0(1:mid-Artifact_Removal_width);
                            z02 = z0(mid+Artifact_Removal_width:end);
                            z02 = fliplr(z02);
                            y0 = cat(2,y01,y02);
                            z0 = cat(1,z01,z02);
                            spl = spline(y0,z0);
                            switch Experiment_Type
                                case 'SC212'
                                    ExpYY = linspace(-5000,5000,1000);
                                case 'C313'
                                    ExpYY = linspace(-5000,5000,1000);
                            end
                            MidData = fnval(spl,ExpYY);
                            MidData = fliplr(MidData);
                            ExpZZ(:,i) = MidData; %#ok<SAGROW>

                        end
                        ExpZ = ExpZZ;
                        ExpY = ExpYY;
                end
            case 'Off'
                Existence = nothing;
        end
    case 'Solo'
        Existence = nothing;
end
%% Sets max height to the same
switch SimType
    case '2D'
        switch PlotMode
            case 'Compare'
                minval = min(ExpY);
                ExpY = ExpY-minval;
                minval = min(SPE);
                SPE = SPE-minval;
                ymax=max(ExpY);
                SPEmax=max(SPE);
                if SPEmax>ymax
                    factor = SPEmax/ymax;
                    ExpY=ExpY*factor;
                else
                    factor = ymax/SPEmax;
                    SPE=SPE*factor;
                end
            case 'Solo'
                Existence = nothing;
        end
    case '3D'
        switch PlotMode
            case 'Compare'
                ymax=max(max(ExpZ));
                zmax=max(max(Z));
                if zmax>ymax
                    factor = zmax/ymax;
                    ExpZ=ExpZ*factor;
                else
                    factor = ymax/zmax;
                    Z=Z*factor;
                end
            case 'Solo'
                Existence = nothing;
        end
        Y=data{1,2};
        SExpY = length(Y);
        SExpY = SExpY/2;
        SExpY = SExpY+1;
        SExpY = round(SExpY);
        MidLocation = Y(SExpY);
        MidCorrection = MidLocation;
        Y = Y-MidCorrection;
end
switch Mirror_f1
    case 'On'
        switch SimType
            case '2D'
                ExpX=-ExpX;
                FREQ=-FREQ;
            case '3D'
                Y=-Y;
                ExpY=-ExpY;
        end
    case 'Off'
        Existence = nothing;
end

%% Plotting
switch SimType
    case '2D'
        SPE = SPE*Additional_Sim_Scaling;
        switch PlotMode
            case 'Compare'
                plot(ExpX,ExpY, 'color', 'r')
                 set(gca, 'XDir','reverse') %reverse x axis
                hold on
                plot(FREQ,SPE, 'color', 'k')
                 set(gca, 'XDir','reverse') %reverse x axis
            case 'Solo'
                plot(FREQ,SPE, 'color', 'k')
                 set(gca, 'XDir','reverse') %reverse x axis
        end
    case '3D'
        switch PlotMode
            case 'Compare'
                %% Plots Sim data
                pl=[1,0.75,0.7,0.65,0.6,0.55,0.5,0.49,0.48,0.47,0.46,0.45,0.44,0.43,0.42,0.41,0.4,0.39,0.38,0.37,0.36,0.35,0.34,0.33,0.32,0.31,0.3,0.29,0.28,0.27,0.26,0.25,0.24,0.23,0.22,0.21,0.2,0.19,0.18,0.17,0.16,0.15,0.14,0.13,0.12,0.11,0.1,0.09,0.08,0.07,0.06,0.05,0.04,0.03,0.02,0.01];
                pl=pl*max(max(Z));
                contour(X,Y,Z,pl,'k');
                 set(gca, 'XDir','reverse') %reverse x axis
                hold on
                %% Plots Experimental data
                pl=[1,0.75,0.7,0.65,0.6,0.55,0.5,0.49,0.48,0.47,0.46,0.45,0.44,0.43,0.42,0.41,0.4,0.39,0.38,0.37,0.36,0.35,0.34,0.33,0.32,0.31,0.3,0.29,0.28,0.27,0.26,0.25,0.24,0.23,0.22,0.21,0.2,0.19,0.18,0.17,0.16,0.15,0.14,0.13,0.12,0.11,0.1];
                %pl=[1.0,0.95,0.9,0.85,0.8,0.75,0.7,0.65,0.6,0.55,0.5,0.45,0.4,0.35,0.3,0.25,0.2];
                pl=pl*max(max(real(ExpZ)));
                contour(ExpX,ExpY,ExpZ,pl,'r')
                set(gca, 'XDir','reverse') %reverse x axis
                xlim([-2 30])
                hold off
            case 'Solo'
                Y=data{1,2};
                pl=[1.0,0.9,0.75,0.6,0.5,0.45,0.4,0.35,0.3,0.25,0.2];
                pl=pl*max(max(Z));
                contour(X,Y,Z,pl,'k');
                set(gca, 'XDir','reverse') %reverse x axis
        end
end
%% Cleanup Section
fclose('all');

switch SimType
    case '2D'
        cd 'C:\Matlab\development_pantheon_2\Fidfiles'
        thing = 'RRthing.fid';

        delete (thing);
        clear thing


        cd 'C:\Matlab\development_pantheon_2\RRfiles'


        thing = 'RRthing.in';
        delete (thing)
        clear thing


        cd 'C:\Matlab\development_pantheon_2'
        rmdir Fidfiles
        rmdir RRfiles

    case '3D'
        cd 'C:\Matlab\development_pantheon_2\Fidfiles'

        for v = 1:length(isofm)
            thing = ['RR', num2str(v), '.fid'];

            delete (thing);
            clear thing
        end

        cd 'C:\Matlab\development_pantheon_2\RRfiles'

        for h = 1:length(isofm)
            thing = ['RR', num2str(h), '.in'];
            delete (thing)
            clear thing
        end

        cd 'C:\Matlab\development_pantheon_2'
        rmdir Fidfiles
        rmdir RRfiles
end
