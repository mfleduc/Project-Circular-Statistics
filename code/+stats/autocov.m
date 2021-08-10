function [ac] = autocov(unitVecs, lag)
%AUTOCOV Summary of this function goes here
%   Detailed explanation goes here
n = length( unitVecs );
angles = angle(unitVecs);
ac = zeros([1, 1+lag]);
for LL = 0:lag
    ac(LL+1) = sum( sin( angles(1:n-LL) ).*sin( angles( LL+1:end ) ) );
end
end

