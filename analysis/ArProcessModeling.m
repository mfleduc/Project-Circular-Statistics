% startAnalysis();
files = dir('data/41047_2019.txt');
rng(456738568)
data = readers.readNdbc( fullfile(files(1).folder, files(1).name) ) ;
fs = 1/600;
for ii = 12
    monthDesired = 12;
    disp(ii)
    wDir = data.WDIR(data.MM<=monthDesired)*pi/180;
    wDir = wDir( wDir<10 );
    dataAc = stats.correlogram(wDir, 600);
    rho = dataAc(2);
    % idea: Simulate jumps via metropolis-hastings: jumps are independent,
    % and we can generate a correlated time series by adding jumps onto the
    % data
%     wDir = wrapTo180( wDir(wDir<999));
%     acorr = stats.correlogram(wDir, 7*24*6);
%     [params] = stats.MLE.vonMises(wDir);

    r1 = 0.995;
    w = -pi/2:0.001:pi/2;
    psd = (1-r1^2)/(2*pi)./abs(1+r1*exp(1j*(w-(pi)))).^2;
    
    figure;semilogx(w*fs/pi,(psd))
    grid on
    acf = ifft( psd );
    figure;plot((0:length(dataAc)-1)/(3600*fs),dataAc);hold on;
    acf = (abs(acf)/max(abs(acf)));
    dt = 1/((w(2)-w(1))*fs/pi);
    plot(dt/(length(psd))*[0:length(psd)/2]/3600, (acf(1:1+ceil(length(acf)/2))))
    xlim([0 100])
    ylabel('Circular autocorrelation')
    xlabel('Lag, hours')
    grid on
    keyboard
    mu=pi;k=2;
    params = [mu,k];
    vm = dists.vonMises(pi/180*(0:0.1:359.9),params);%vm = p(theta_0)
    uni = dists.uniform( pi/180*(0:0.1:359.9) );
    dp = stats.MLE.vonMises(wrapTo2Pi( wDir(1:end-1)-wDir(2:end)) );
    a = dists.projectedNormal(0:0.01:(2*pi), 0.5);
    linkDist = markov.transition(vm, mu, 'uniform',[mu 0.5]);
    simDirs = markov.metropolisHastings(mu, vm,linkDist, 4000);
    [y,x] = ecdf(simDirs);
    figure;plot(x,y);
    hold on;grid on;
    plot( vm.x, vm.cdf )
    plot([0:0.1:2*pi],[0:0.1:2*pi]/(2*pi),'k--')
    axis tight
    xlabel('Angle, radians')
    ylabel('cumulaative density')
    legend('Simulated data', 'Actual distribution (\mu=\pi,\kappa = 2)', 'Uniform distribution', 'Location', 'southeast') 
    title('Simulated data vs real distribution, uniform binding distribution')
    keyboard
    if false
        if length(wDir)>15
            params = stats.MLE.vonMises(wDir);

            diffs = wrapTo180(wDir-wDir(randperm(length(wDir))));
            figure;histogram( diffs*pi/180,'normalization' , 'pdf' );
            z = (-pi:0.01:pi)*180/pi;
            hold on
            linkDist =  besseli(0,params(2)*sqrt(2*(1+cosd(z))))/(2*pi*(besseli(0,params(2)))^2);
            plot(z*pi/180 ,linkDist)
            figure;
            histogram( (wDir*pi/180),200 ,'normalization' , 'pdf', 'displaystyle', 'bar' )
            hold on
            a = dists.vonMises(z, params(1), params(2));
            plot( z*pi/180, a.pdf );

            [y,x] = ecdf( (wDir) );
            figure;plot( x*pi/180,y );
            hold on
            plot( z*pi/180,a.cdf );
            grid on
            axis tight
        end
    end
end