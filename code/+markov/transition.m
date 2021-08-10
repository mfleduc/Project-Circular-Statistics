function transition = transition(marginal, theta, linkName,linkParams)
%% Takes input: marginal distribution of theta_1, value of theta, and link distribution
%marginal: Generated by =dists.vonMises
%theta: some angle
%linkName: string, type of distribution to use as the link
%linkParams: parameter of teh link distribution
% angles = 0:0.01:2*pi;

[~,ndx] = min(abs( marginal.x-theta ) );
tmp = sort(wrapTo2Pi(2*pi*( marginal.cdf - marginal.cdf(ndx) )));


link = eval( ['dists.' linkName '(tmp,linkParams);' ]);
transition = struct;
transition.x = link.x;
transition.pdf = 2*pi*link.pdf.*marginal.pdf;
transition.pdf = transition.pdf/trapz(link.x, transition.pdf);
transition.cdf = cumsum(transition.pdf)/sum(transition.pdf);
transition.meta.linkdist = linkName;
transition.meta.linkparams = linkParams;
end