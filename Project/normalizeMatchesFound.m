function matchesFound = normalizeMatchesFound(matchesFound)
keypointsL = [];
keypointsR = [];
for i = 1 : size(matchesFound,2)
    keypointsL = [keypointsL, matchesFound{i}.LeftKeyPoints];
    keypointsR = [keypointsR, matchesFound{i}.RightKeyPoints];
end
[keyPointsLNormalized, NL] = normalizePoints(makeHomogenous(keypointsL));
[keyPointsRNormalized, NR] = normalizePoints(makeHomogenous(keypointsR));

for i = 1 : size(matchesFound,2)
   matchesFound{i}.keyPointsLN = keyPointsLNormalized(1:2, (i-1)*8+1:i*8);
   matchesFound{i}.NL = NL;
   matchesFound{i}.keyPointsRN = keyPointsRNormalized(1:2, (i-1)*8+1:i*8);
   matchesFound{i}.NR = NR;
end


end

function [x_norm, N] = normalizePoints(x)
x = x./x(3,:); % Set third coordinate to 1



N = eye(3);
mu = mean(x, 2);
sigma = std(x,[], 2);
N(1,1) = 1/sigma(1);
N(2,2) = 1/sigma(2);
N(1,3) = -mu(1)/sigma(1);
N(2,3) = -mu(2)/sigma(2);
x_norm = N*x;


end