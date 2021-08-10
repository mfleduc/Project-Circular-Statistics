function d = metropolisHastings( x0, p, q, nTrials)
%% An implementation of the metropolis-hastings algorithm for generating Markov processes on the circle
% pi: Desired distribution to simulate
% q: 
% nTrials: The number of trials to simulate
d = [];
d(1) = x0;
rho = 0.0;%p.params.kappa;
piInt = @(z)interp1(p.x,p.pdf, z);
count = 0;

while count < nTrials
    tmp = rand( 1 );
    if count >0
        q = markov.transition(p, d(end), q.meta.linkdist, q.meta.linkparams );%recompute this at each step
    end
    [qc, n] = unique( q.cdf );
    y = (interp1( qc, q.x(n), tmp ,'linear', 'extrap'));
%     x = normrnd(0,2,[2,1]);
%     y = angle( x(1)+1j*x(2));
    yp = ((rho)*d( end )+ ( 1-rho )*(y));
%     yp = y;
    q2 = markov.transition(p, yp, q.meta.linkdist, q.meta.linkparams );
    [~,n1] = min(abs( q2.x - d(end) ));
    qxy = q2.pdf(n1);%(interp1( q2.x, q2.pdf,d(end) , 'linear', 'extrap' ));
    [~,n2] = min(abs( q.x - yp ));
    qyx = q.pdf(n2);%(interp1( q.x, q.pdf, yp, 'linear', 'extrap' ));
    a = min(1, ((piInt(yp)*qxy)/(qyx*piInt(d(end)))));
    accept = rand(1);
    if accept<=a

        d(end+1) = yp;
        count = count+1;
    else
        d(end+1) = d(end);
        count = count+1;
    end
%     count = count+1;
%     keyboard
end
d = wrapTo2Pi( (d) );

end