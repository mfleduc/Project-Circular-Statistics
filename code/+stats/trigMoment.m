function mp = trigMoment( data, p , varargin)
%% out = calcTrigMoment( data, p , varargin)
% Returns the p-th trigonometric moment about the zero direction of data.
% The first trigonometric moment is equal to the mean of the data
%    Matthew F. LeDuc
%    6-16-2021
%% Inputs
%   data: A vector of data in degrees
%   p: The order of the moment to be calculated. Can be a vector or scalar
%% Outputs
%   mp: The p-th trigonometric moment of the data about 0
%% References
%   [1] 
mp = zeros([1,length(p)]);
for ii = 1:length(p)
    unitVecs = stats.calcDirStats(p(ii)*data);
    ap = mean(real(unitVecs));
    bp = mean(imag(unitVecs));
    mp(ii) = ap+1j*bp;
end
end