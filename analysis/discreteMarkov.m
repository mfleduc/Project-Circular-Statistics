startAnalysis();
files = dir('data/41047_2019.txt');
rng(456738568)
data = readers.readNdbc( fullfile(files(1).folder, files(1).name) ) ;
fs = 1/600;
monthDesired = 12;
wDir = data.WDIR(data.MM==monthDesired);
wDir = wrapTo360(wDir( wDir<=360 ));
wDir = (15*floor(wDir/15));
dirs = unique(wDir);
wDir(wDir == 360) = 0; 
dirs = dirs(1:end-1);
T = zeros(length(dirs));
for dd = 1:length(dirs)
    n = nnz( wDir == dirs(dd) );
    [ndcs] = find( wDir(1:end-1) == dirs(dd) );
    next = wDir(ndcs+1);
    for ds = 1:length(dirs)
        T(ds,dd) = 1/n*nnz( next == dirs(ds) );
    end
end
x0 = 0;
nTrials = 5000;
xs = [x0];
for nn = 1:nTrials
    state = [ dirs == xs(nn) ];
    probs = cumsum( T*state );
    p = rand(1);
    cprob = probs(1);
    cnt = 1;
    while cprob<p
        cnt = cnt+1;
        cprob = probs(cnt);
    end
    xs(end+1) = dirs(cnt);
end