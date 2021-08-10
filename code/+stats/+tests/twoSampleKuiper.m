function [V, p] = twoSampleKuiper(cdf1, cdf2)
%TWOSAMPLEKUIPER 
% Kuiper, N. H. (1960). 
% "Tests concerning random points on a circle". Proceedings of the Koninklijke Nederlandse Akademie van Wetenschappen, Series A. 63: 38–47.
% Assume both CDFs are interpolated onto the same grid
% null hypothesis: cdf1 and cdf2 represent identically distributed random
% variables
cdf2 = reshape(cdf2, size(cdf1));
tmp1 = cdf1-cdf2;
tmp2 = -tmp1;
V = max(tmp1)+max(tmp2);
n = length(cdf1);
j=1:1e3;

c = (0.01:0.01:20).';
P = 1-sum( (2*j.^2.*c.^2-1 ).*exp( -j.^2.*c.^2 ),2)...
    +1/(6*n)*(1+sum( j.^2.*c.^2.*(2*j.^2.*c.^2-7 ).*exp( -j.^2.*c.^2 ),2));
% P(P>1) = 1;
c = [0;c];
P = [0;P];


p = interp1(c,P, V);
V = sqrt(n)*V;
end

