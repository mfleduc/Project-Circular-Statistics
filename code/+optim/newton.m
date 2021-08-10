function root = newton( x, fx , x0, varargin)
tol = 1e-3;
nMax = 10000;
n = 1;
t0 = 1;
xn = [x0];
fprime = [diff(fx)./diff(x)];
fprime = [fprime(1), fprime];
while t0>tol && n<nMax
    fp = interp1( x, fprime, xn(end),'linear' );
    fv = interp1( x, fx, xn(end) ,'linear');
    xn(end+1) = xn(end)-fv/fp;
    if xn(end)<0
        xn(end) = 0;
    end
    t0 = abs( fv );
    n=n+1;
end
root = xn(end);
if isnan(root)
    root = xn(end-1);
end
end