function matchesFound = addUnfoundMatches(matchesFound, matchesNotFound, data_l, data_r)


[bestHL, bestHR, probL, probR] = getHomeographys(matchesFound);
matchInd = size(matchesFound,2)+1;
for i = 1 : size(matchesNotFound,2)
    tmpStruct = matchesNotFound{i};
    if isnan(tmpStruct.LeftIndex)
        tmpStruct.RightKeyPoints = data_r{tmpStruct.RightIndex}.keypoints;
        tmpStruct.LeftKeyPoints = pflat(bestHR*makeHomogenous(tmpStruct.RightKeyPoints));
        tmpStruct.RightProb = probR*tmpStruct.RightProb;
        tmpStruct.LeftProb =0;
    else
        tmpStruct.LeftKeyPoints = data_l{tmpStruct.LeftIndex}.keypoints;
        tmpStruct.RightKeyPoints = pflat(bestHL*makeHomogenous(tmpStruct.LeftKeyPoints));
        tmpStruct.LeftProb = probL*tmpStruct.LeftProb;
        tmpStruct.RightProb = 0;
    end
    matchesFound{matchInd} = tmpStruct;
    matchInd = matchInd + 1;
end
end