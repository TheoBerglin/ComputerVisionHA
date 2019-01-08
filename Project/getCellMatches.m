function matches = getCellMatches(data_l, data_r, matchFoundL2R, F1, F2)

[confidenceL, confidenceR] = getConfidenceArrays(data_l, data_r);
s = max(size(data_l,2), size(data_r,2)); % We should go through all points

matches = cell(1,s);
% Match points
for i=1:s
    matchStruct = struct('LeftIndex', nan, 'RightIndex', nan,...
        'LeftProb', nan, 'RightProb', nan, 'MatchFound', false);
    if i <= size(data_l,2)
        matchStruct.LeftIndex = i;
        matchStruct.LeftProb = confidenceL(i);
        if i <= size(data_r,2) &&  matchFoundL2R(i) <= size(data_r, 2)
            matchStruct.RightIndex = matchFoundL2R(i);
            matchStruct.RightProb = confidenceR(matchFoundL2R(i));
            matchStruct.MatchFound = true;
        end
    else
        if i <= size(data_r,2)
            matchStruct.RightIndex = i;
            matchStruct.RightProb = confidenceR(i);
        end
    end
    if matchStruct.MatchFound
        if matchStruct.LeftProb >= matchStruct.RightProb
            matchStruct.LeftKeyPoints = data_l{i}.keypoints;
            % Project right to epipolar lines from left
            matchStruct.RightKeyPoints = projectKeyPoints(data_l{i}.keypoints,...
                F1, data_r{i}.keypoints);
        else
            matchStruct.RightKeyPoints = data_r{i}.keypoints;
            % Project left to epipolar lines from right
            matchStruct.LeftKeyPoints = projectKeyPoints(data_r{i}.keypoints,...
                F2, data_l{i}.keypoints);
        end
    end
    matches{i} = matchStruct;
    
end
end