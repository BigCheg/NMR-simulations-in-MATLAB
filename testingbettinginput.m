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
left_shift_FID_points = 0;
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
            disp(newtext1)
            filename = ['RRfiles/RR', num2str(i), '.in'];
            file = fopen(filename,'w');
            fprintf(file,newtext1);
            fclose(file);
        end
end


% % Change to the folder
% cd('C:\Matlab\development_pantheon_2\RRfiles');
% 
% % Delete all files
% delete('*.*');
% 
% % Return to parent directory and remove folder
% cd('C:\Matlab\development_pantheon_2');
% rmdir('RRfiles', 's');