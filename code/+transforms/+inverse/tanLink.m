function out = tanLink( in )
%Going from linear space to the circle
%Must pass in de-meaned data
out = tan((in-pi)/2);
end