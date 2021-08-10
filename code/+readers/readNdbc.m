function out = readNdbc(fileName)
%%  out = readNdbc(fileName)
%Reads data from an NDBC buoy and returns a table containing data from the
%buoy
% Matthew F. LeDuc
% Last updated 6/16/2021
%% Inputs 
%   fileName: Name of a text file containing NDBC data
%% Outputs
%   out: A table of the data contained in fileName
opts = detectImportOptions(fileName);
opts.VariableNamesLine = 1;
fid = fopen(fileName);
line1 = fgetl(fid);
fclose(fid);
opts.VariableNames = strsplit( line1(2:end), ' ' );
opts.ExtraColumnsRule = 'ignore';
out = readtable(fileName, opts);
end