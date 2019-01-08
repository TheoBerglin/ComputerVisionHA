function [confidenceL,confidenceR] = getConfidenceArrays(data_l,data_r)
%GETCONFIDENCEARRAYS Summary of this function goes here
%   Detailed explanation goes here
confidenceL = extractConfidence(data_l);
confidenceR = extractConfidence(data_r);
end

function conf = extractConfidence(data)
conf = zeros(1, size(data,2));
for i=1:size(data,2)
   conf(i) = sigmoid(data{i}.confidence); 
end

end
