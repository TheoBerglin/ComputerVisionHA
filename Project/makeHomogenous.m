function xh = makeHomogenous(x)
%MAKEHOMOGENOUS Summary of this function goes here
%   Detailed explanation goes here
n_points = size(x,2);
xh = [x; ones(1, n_points)];
end

