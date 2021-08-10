startAnalysis();
files = dir('data/41047_2019.txt');
data = readers.readNdbc( fullfile(files(1).folder, files(1).name) ) ;
fs = 1/600;
month = 1;
wDir = data.WDIR(data.MM==month&data.WDIR<=360)*pi/180;

% a = xcorr(exp(1j*wDir));


if false
    kVals = struct;
    mVals = struct;
    kVals.wind = zeros([12, length(files)]);
    kVals.wave = zeros([12, length(files)]);
    mVals.wind = zeros( [12, length(files)]);
    mVals.wave = zeros( [12, length(files)]);

    for ii = 1:length(files)
        data = readers.readNdbc( fullfile(files(ii).folder, files(ii).name) );%reading in the ndbc data
        wvdir = data.MWD;
        winddir = data.WDIR;
        for jj = 1:12
            wv = winddir( data.MM == jj & data.WDIR<999 );
    %         wd = winddir( data.MM == jj & data.WDIR<999 );
            vmWv = stats.MLE.vonMises(wv);
    %         vmWd = stats.MLE.vonMises(wd);
            kVals.wave(jj,ii) = vmWv(2);
    %         kVals.wind(jj,ii) = vmWd(2);
            mVals.wave(jj,ii) = vmWv(1);
    %         mVals.wind(jj,ii) = vmWd(1); 
            [yWv, xWv] = ecdf( wv );
            wvDist = dists.vonMises(xWv, vmWv(1), vmWv(2));
    %         wdDist = dists.vonMises(0:0.1:360, vmWd(1), vmWd(2));
            figure;hold on
            plot( wvDist.x, wvDist.cdf );        
            plot( xWv,yWv);
            grid on
            xlim([0 360])
            ylim([0 1])
            xlabel('Angle')
            ylabel('Cumulative density')
            title(sprintf('Maximum-Likelihood Von-Mises CDF vs Empirical CDF for wind direction \n Month %d', jj))
            legend(['Von-Mises CDF, $\mu$ = ',sprintf('%.1f, ',wvDist.params.mu), '$\kappa$ = ', sprintf('%.2f',  wvDist.params.kappa)], ...
                'Emprical CDF', 'location', 'southeast', 'interpreter', 'latex');
            [a,b] = stats.tests.twoSampleKuiper(wvDist.cdf, yWv);
            if b<=0.05
                fprintf('Failed Kuiper test in month %d \n', jj)
            end
        end
    end
end
