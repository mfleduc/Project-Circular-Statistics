clear variables
files = dir('data/*.txt');
rng(4567)
kappa = [];
nPoints = 1e3:1000:5e4;
decorrDiff = [];
alphas = [];
for ff = 1:length(files)
data = readers.readNdbc( fullfile(files(ff).folder, files(ff).name) ) ;
fs = 1/600;
months = 1:12 ;
% months(end) = 11;
maxLag = 600;
disp(files(ff).name)
for mm = 1:length(months)
    fprintf( '%d \n', months(mm) )
monthDesired = months(mm);
wDir = data.WDIR(data.MM==monthDesired)*pi/180;
if any(wDir>6.5)
    ndcs = find( wDir>6.5 );
    ndcs = ndcs(ndcs<length(wDir));
    ndcs = ndcs(ndcs>1);
    
        
    for nn = 1:length(ndcs)
        wDir(ndcs(nn)) = wrapTo2Pi(angle(0.5*(exp(1j*pi/180*wDir(ndcs(nn)+1))+exp(1j*pi/180*wDir(ndcs(nn)-1)))));
    end
    if any(diff(ndcs)==1)
        wDir = []; 
    end
end

wDir = wrapToPi(wDir);

if length(wDir)>2000
   
    params = stats.MLE.vonMises( wrapTo2Pi(wDir) );
    
    theta = (sin(params(1) - wDir(1:end-1)));
    B = zeros(length(theta), 2);
    B(:,1) = 1;
    % B(:,2) = wDir(1:end-1);
    B(:,2) = theta;

    A = (B.'*B)\(B.'*wrapToPi(diff(wDir)));

    ys = zeros([1, nPoints(end)]);
    ys(1) = (2*rand([1])-1)*pi;
    % b1 = 0.1;
    % a0 = 0.5;
    % params = [pi/4, 2];

    dataAc = stats.correlogram( wDir, maxLag);
    [~,ndx] = min(abs(dataAc-exp(-1)));
    a1 = 1/ndx;%A(end);% 1/ndx;
    if a1>0
        disp(a1)
        kappa(end+1) = params(2);
        alphas(end+1) = a1;
        sigma = sqrt(2*(a1)/params(2)^2);
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
            ys(ii) = (ys(ii-1)+a1*sin( params(1)-ys(ii-1) )+sigma*e(ii)); 
        end

        simAc = stats.correlogram( ys , maxLag);
        [~,simNdx] = min(abs(simAc-exp(-1)));
        decorrDiff(end+1) = (ndx-simNdx)/6;
    end
else
    disp('Not enough data')
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

