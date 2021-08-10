function out = circPeriodogram( data, fs,win ,nOverlap, varargin )
% unitVecs = stats.calcDirStats(data);
m = stats.trigMoment(data, 1);
n = length(data);
zmd = exp(1j*data)-m;
p = 0:n/2;
ghat = zeros( [1 ,length(p)] );
% for jj = 1:length(p)
% ghat(jj) = 1/n*abs(sum( zmd.'.*exp(1j*2*pi*p(jj)*( 1:n )./n)))^2;
% end
% out.periodogram = ghat;
% out.freqs = pi/n*p;
[psd,f] = pwelch(zmd,win,nOverlap,[],fs);
out.periodogram = psd;
out.freqs = f;
end