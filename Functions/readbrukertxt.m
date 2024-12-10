function [F1LEFT,F1RIGHT,F2LEFT,F2RIGHT,NROWS,NCOLS] = readbrukertxt(filename)
fileID = fopen(filename);
% read the whole file, interpret each line as a string
MyText = textscan(fileID, '%s%[^\n\r]', 'Delimiter', '', 'WhiteSpace', '',  'ReturnOnError', false);
% convert the cell array into a string array, for easier indexing
MyText = string(strtrim(MyText{1}));
% Get specific data
currLine = contains(MyText, "F1LEFT");
currLine = split(MyText(currLine),' ');
F1LEFT = str2double( currLine(4) );
F1RIGHT = str2double( currLine(8) );
currLine = contains(MyText, "F2LEFT");
currLine = split(MyText(currLine),' ');
F2LEFT = str2double( currLine(4) );
F2RIGHT = str2double( currLine(8) );
currLine = contains(MyText, "NROWS");
currLine = split(MyText(currLine),' ');
NROWS = str2double( currLine(4) );
currLine = contains(MyText, "NCOLS");
currLine = split(MyText(currLine),' ');
NCOLS = str2double( currLine(4) );
end