function sampleDispersion = sampleCircularDispersion( data )
%%
%
%   Matthew F. LeDuc
%   6-16-2021
%% Inputs
%   data: A vector or matrix of angles in degrees
%% Outputs
%   sampleDispersion: The sample dispersion of the data
means = functions.stats.trigMoment(data, [1,2]);
sampleDispersion = (1-means(2))/(2*means(1)^2);
end