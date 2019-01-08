function l = calculateEpipolarLines(F, keypoints)
%CALCULATEEPIPOLARLINES Summary of this function goes here
%   Detailed explanation goes here
if size(keypoints,1) == 2
    keypoints = makeHomogenous(keypoints);
end
l = F*keypoints;
l = l./sqrt(repmat(l(1,:).^2+l(2,:).^2+l(3,:).^2, [3,1]));
end

