function [bestHL, bestHR, probL, probR] = getHomeographys(matchesFound)

keypointsL = [];
keypointsR = [];
for i = 1 : size(matchesFound,2)
    keypointsL = [keypointsL, matchesFound{i}.LeftKeyPoints];
    keypointsR = [keypointsR, matchesFound{i}.RightKeyPoints];
end
keypointsL = makeHomogenous(keypointsL);
keypointsR = makeHomogenous(keypointsR);
threshold = 10;
rRuns = 20;
m = 4;
[bestHL, maxInlinersL] = calculateHomographyRANSAC(m, rRuns, threshold, keypointsL, keypointsR);
[bestHR, maxInlinersR] = calculateHomographyRANSAC(m, rRuns, threshold, keypointsL, keypointsR);
probL = maxInlinersL/size(keypointsL,2);
probR = maxInlinersR/size(keypointsR,2);
end