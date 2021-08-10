clear variables
files = dir('data/*.txt');
rng(4567697)
kappa = 0.5:0.5:4;
mu =  [ 0 0 0 0 0 0 0 0 0 0 0 0 0] ;
[K,M] = meshgrid( kappa,mu );
M = M(:);
K = K(:);
nPoints = unique([1000:2000:10e5, 10e5]);
vals = [];
temp = 0;
a1 = 0.01;

for temp = 1:length(kappa)
    for temp2 = 1:length(mu)
    ys = zeros([1, (nPoints(end))]);
    ys(1) = 0;
    params = [mu(temp2), kappa(temp)];
    %         alphas(end+1) = a1;
    sigma = sqrt(2*(a1)/params(2));

    e = normrnd(0,1,[1 length(ys)]);
    for ii = 2:length( ys )
        ys(ii) = (ys(ii-1)+a1*sin( params(1)-ys(ii-1) )+sigma*e(ii)); 
    end
    for nn = 1:length(nPoints)
        p2 = stats.MLE.vonMises(wrapTo2Pi(ys(1:nPoints(nn))));
        vals(1,nn,temp,temp2) = 1-cos(params(1)-p2(1));%abs(angle(exp(1j*params(1))-exp(1j*p2(1))));
        vals(2,nn,temp,temp2) = abs((params(2)-p2(2)))/params(2) ;
    end  
    end
end
   
    
keyboard
nPoints = 10.^ceil(linspace(3, log10(length(ys)), 100));
pests = zeros(2, length(nPoints));
for nn = 1:length(nPoints)
    pp = nPoints(nn);
    pests(:,nn) = stats.MLE.vonMises(ys(1:pp));
end
figure;semilogx(nPoints, pests(1,:),'b');
grid on
hold on
semilogx(nPoints, ones([1, length(nPoints)])*params(1),'b--')
semilogx(nPoints, pests(2,:),'r')
semilogx(nPoints, ones([1, length(nPoints)])*params(2),'r--')
legend('Estimate of \mu', 'True value of \mu', 'Estimate of \kappa', 'True value of \kappa')

