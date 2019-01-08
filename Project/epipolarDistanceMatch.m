function matchIndices = epipolarDistanceMatch(data1,data2, F)
%EPIPOLARDISTANCEMATCH Summary of this function goes here
%   Detailed explanation goes here
matchFound = zeros(1, size(data2,2));
matchIndices = 99*ones(1, size(data1,2));
for i=1:size(data1,2)
    keyPoints1 = data1{i}.keypoints;
    l = calculateEpipolarLines(F, keyPoints1);
    minIndice = 0;
    minDist = 100; %Default value, laaaaaaaaaaarge
    for j = 1 : size(data2,2)
        if matchFound(j) == 0
            comparePoints = data2{j}.keypoints;
            % Compute distance to epipolar line
            dist = abs(diag(l'*makeHomogenous(comparePoints)));
            distSum = sum(dist);
            distSum = distSum+0.1*norm(abs(keyPoints1-comparePoints));
            if distSum < minDist
                minDist = distSum;
                minIndice = j;
            end
        end
    end
    if minIndice ~=0
        matchFound(minIndice) = 1;
        matchIndices(i) = minIndice;
    end
end

end

