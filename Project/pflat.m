function  output_state = pflat(input_state)
%PFLAT  divides the homogeneous coordinates with
%their last entry for points of any dimensionality. 
%(You may assume that none of the points have last homogeneous coordinate zero.)
output_state = input_state(1:end-1,:)./input_state(end,:);
end

