clear variables
files = dir('data/41047_2019.txt');
rng(4567)
data = readers.readNdbc( fullfile(files(1).folder, files(1).name) ) ;
fs = 1/600;
months = 1:12;
figure;
for mm = months
    wdir = data.WDIR(data.MM == mm);
    wdir = wdir(wdir<370);
    plot( (0:length(wdir)-1)/6, unwrap(wdir*pi/180) ) ;
    hold on
    grid on
end