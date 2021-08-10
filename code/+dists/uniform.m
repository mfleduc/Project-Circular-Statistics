function [output] = uniform( in,varargin )
%UNIFORM Summary of this function goes here
%   Detailed explanation goes here
output.x = in;
output.pdf = 1/(2*pi)*ones(size(in));
output.cdf = in/(2*pi);
end

