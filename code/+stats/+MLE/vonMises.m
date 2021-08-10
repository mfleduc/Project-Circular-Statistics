function params = vonMises(data)
%
%
if isreal(data)
    data = stats.calcDirStats( data ); 
end
zbar = stats.calcMean(data);
mu = wrapTo2Pi(angle( zbar ));
N = length(data);
k=0:0.001:20;
R2 = zbar*conj(zbar);
% R2e = (N/(N-1))*( R2 - 1/N );

fk = besseli(1,k)./besseli(0,k) - sqrt(R2);

kappa = optim.newton( k,fk,2 );
% keyboard
% R = sqrt(R2);
% if R<0.53
%     k = 2*R+R^3+5*R^5/6;
% elseif R<0.85
%     k = -0.4+1.39*R+0.43/(1-R);
% else
%     k = 1/(R^3+3*R-4*R^2);
% end
params(1) = mu;
params(2) = kappa;
end