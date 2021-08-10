function [output] = projectedNormal(x, rho)
%PROJECTEDNORMAL Summary of this function goes here
%   Projected normal distribution for zero-mean projected normal
%   distribution with parameter rho
output.x = x;
output.pdf = sqrt(1-rho^2)./( 1-rho*sin(2*x) )/(2*pi);
output.pdf = output.pdf/trapz(x,output.pdf);
output.cdf = cumsum(output.pdf)/sum(output.pdf);
end

