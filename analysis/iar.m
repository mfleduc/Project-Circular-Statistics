% startAnalysis();
files = dir('data/41047_2019.txt');
rng(456738568)
data = readers.readNdbc( fullfile(files(1).folder, files(1).name) ) ;
fs = 1/600;
months = 1:3:12;
lags = 600;
ac = zeros(length(months), lags+1);
for mm = 1:length(months)
    wd = data.WDIR(data.MM == months(mm)); 
    wd = wd(wd<=360)*pi/180;
    ac(mm,:) = stats.correlogram( wd ,lags);
    
end
