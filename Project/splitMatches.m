function [foundMatches,matchNotFound] = splitMatches(matches)
%SPLITMATCHES Summary of this function goes here
%   Detailed explanation goes here
foundMatches = {};
matchInd = 1;
matchNotFound = {};
matchNotFoundInd = 1;
for i = 1 : size(matches,2)
    if matches{i}.MatchFound
        foundMatches{matchInd} = matches{i};
        matchInd = matchInd + 1;
    else
        matchNotFound{matchNotFoundInd} = matches{i};
        matchNotFoundInd = matchNotFoundInd + 1;
    end
end
end

