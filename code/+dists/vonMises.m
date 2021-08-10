function [output] = vonMises(x0, params)
%% Assume mu,x0 \in [0,2\pi)
mu=params(1);
kappa=params(2);
x = unique([min(x0):.001:max(x0),max(x0)]);
p = exp( kappa*cos(x-mu))/(besseli(0,kappa)*(2*pi)); 
% p = p/trapz(x,p);
pdf = interp1(x, p, x0);
c = cumsum(p)/sum(p);
cdf = interp1( x,c,x0 );
output.x = x0;
output.pdf = pdf;
output.cdf = cdf;
output.params.mu = mu;
output.params.kappa = kappa;
end

