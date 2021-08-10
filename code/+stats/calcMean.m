function [m] = calcMean(data)
%% Calculates resultant length and mean direction of input data
%Assumes input data is a vector or matrix of angles in degrees
%% Inputs
%   data: A vector or matrix of angles in degrees 
%% Outputs
%   m: circular mean of the input data, equivalent to the 1st trigonometric
%   moment about 0
if isreal(data)
    unitVecs = stats.calcDirStats(data);
else
    unitVecs = data;
end
S = mean(imag(unitVecs));
C = mean(real(unitVecs));
R = sqrt(S.^2+C.^2);
thetaHat = atan2( S,C );
m = R*exp(1j*thetaHat);
end