clear variables
startAnalysis();
files = dir('data/41047_2019.txt');
rng(4567)
data = readers.readNdbc( fullfile(files(1).folder, files(1).name) ) ;
fs = 1/600;
months = [1] ;
% months(end) = 1;
maxLag = 600;
% figure;
YY = struct;
for mm = 1:length(months)
monthDesired = months(mm);
wDir = data.WDIR(data.MM == monthDesired)*pi/180;
if any(wDir>6.5)
    ndcs = find( wDir>6.5 );
    ndcs = ndcs(ndcs<length(wDir));
    for nn = 1:length(ndcs)
        wDir(ndcs) = wrapTo2Pi(angle(0.5*(exp(1j*pi/180*wDir(ndcs+1))+exp(1j*pi/180*wDir(ndcs-1)))));
    end
end
wDir = wrapToPi(wDir);
wDir = wDir( wDir<10 );

params = stats.MLE.vonMises( wrapTo2Pi(wDir) );
% disp(params)
theta = (sin(params(1) - wDir(1:end-1)));
B = zeros(length(theta), 2);
B(:,1) = 1;
% B(:,2) = wDir(1:end-1);
B(:,2) = theta;

A = (B.'*B)\(B.'*wrapToPi(diff(wDir)));

ys = zeros([1, length(wDir)]);
ys(1) = (2*rand([1])-1)*pi;
% b1 = 0.1;
% a0 = 0.5;
% params = [pi/4, 2];

dataAc = stats.correlogram( wDir, maxLag);
[~,ndx] = min(abs(dataAc-exp(-1)));
a1 =  1/ndx;
disp(A)
sigma = sqrt(2*(a1)/params(2));
% a1 = params(2)^2/2;
% for ii = 4:length(ys)
%     gamma = angle( exp(1j*ys(ii-1))-exp(1j*ys(ii-2) ));
%     edist = dists.vonMises([-pi:0.01:pi,pi], [0 exp( a0+a1*cos(ys(ii-1)))]);
%     u = rand(1);
%     e = interp1(edist.cdf, edist.x, u,'linear', 'extrap');
%     ys(ii) = b1*gamma+e;
% end
e = normrnd(0,1,[1 length(ys)]);
for ii = 2:length( ys )
    ys(ii) = (ys(ii-1)+a1*sin( params(1)-A(1)-ys(ii-1) )+sigma*e(ii)); 
end
[y,x] = ecdf(wrapTo2Pi(wDir));
[y2,x2] = ecdf(wrapTo2Pi(ys));
figure;plot(x,y);
hold on;
plot(x2,y2)
d = dists.vonMises(0:0.01:2*pi, params);
plot(d.x, d.cdf, 'k')
axis tight
xlabel('\theta, radians')
ylabel('F(\theta)')
grid on
legend('NDBC data', 'Simulated data', sprintf('M(\\mu = %.2f, \\kappa = %.2f)',params(1), params(2)))
title(sprintf('Comparison of real and simulated data \n NDBC buoy 41047, Month %d , 2019', monthDesired))
% yi = interp1(x(2:end),y(2:end),x2,'linear', 'extrap');
% pval = circ_kuipertest(wrapTo2Pi(ys), wrapTo2Pi(wDir), 500,1);
% simAc = stats.correlogram( ys , maxLag);
% 
% subplot(2,2,mm);plot( (0:maxLag)/6 , simAc,'r' );
% hold on;plot((0:maxLag)/6 , dataAc,'b' )
% % plot((0:maxLag)/6, [exp(-a1*(0:maxLag))], 'k')
% legend('Model', 'Data')
% xlabel('Lag, hours')
% ylabel('Autocorrelation')
% title(sprintf('Month %d, \\kappa = %.2f, \\alpha = %.4f', monthDesired,params(2),a1))
% grid on
% end
% sgtitle('Data vs Model autocorrelation, NDBC buoy 41010, 2018')
YY.(sprintf('month%d',monthDesired)) = ys; 
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

