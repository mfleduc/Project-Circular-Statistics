function cVar = circVar(data)
%% cVar = circVar(data);
%Calculates the circular variance of the input data in degrees
%   Matthew F. LeDuc
%   6-16-2021
%% Inputs
%   data: A vector or matrix of angles in degrees
%% Outputs
%   cVar: The circular variance of data
unitVecs = stats.calcDirStats( data );
m = stats.calcMean( unitVecs );
cVar = 1-abs(m);
end