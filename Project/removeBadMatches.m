function matchesFound2 = removeBadMatches(matchesFound, threshold)
matchesFound2 = {};
cellInd = 1;

for i = 1 : size(matchesFound,2)
    X = pflat(matchesFound{i}.X);
   if max(matchesFound{i}.LeftProb, matchesFound{i}.RightProb) >= threshold && X(3) >-3
      matchesFound2{cellInd} = matchesFound{i}; 
      cellInd = cellInd + 1;
   %else
       %fprintf('removed: %.2f, %.2f\n', max(matchesFound{i}.LeftProb, matchesFound{i}.RightProb), X(3))
   end
    
end

end