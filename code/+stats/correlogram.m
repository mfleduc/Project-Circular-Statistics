function rho = correlogram(data,maxLag)
%%
if isreal(data)
    data = stats.calcDirStats(data);
end
if isempty(maxLag)
    maxLag = length(data);
end
data = reshape(data, length(data), 1);
N = length(data);
X = [real(data),imag(data)].';%cos, sin
k = 0:maxLag;
rho = zeros([1, maxLag+1]);
for ii = k
    tmpnum = X(:,1:(N-ii))*X(:,ii+1:N)';
    tmpdenom = X(:,1:(N-ii))*X(:,1:(N-ii))';
    tmpdenom2 = X(:,ii+1:N)*X(:,ii+1:N)';
    
    numerator = det(sum(tmpnum,3));
    dnm = det(sum(tmpdenom,3))*det(sum(tmpdenom2,3));
    rho(ii+1) = numerator/sqrt(dnm);
end
end