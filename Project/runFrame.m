function [objects] = runFrame(data_l, data_r,frame_id, P_l, P_r, image_l, image_r)


%RUNFRAME takes inputs from a stereo frame and yields 3D boxes
%
%   This is the function that you are supposed to complete.
%   Feel free to add extra files.
%
%   The output format of this file is exemplified also in:
%     example_frame_output.mat
%

%% INSERT YOUR CODE HERE
F1 = extractFundamentalMatrix(P_l, P_r);
F2 = extractFundamentalMatrix(P_r, P_l);


%% Works best with fewer cells
% Match points based on epipolar distance
matchFoundL2R = epipolarDistanceMatch(data_l, data_r, F1); % Matched indices in right image
% New data structre
matches = getCellMatches(data_l, data_r, matchFoundL2R, F1, F2);
% Split into found and not found matches
[matchesFound, matchesNotFound] = splitMatches(matches);
if ~isempty(matchesFound)
    if ~isempty(matchesNotFound)
        matchesFound = addUnfoundMatches(matchesFound, matchesNotFound, data_l, data_r);
    end
    matchesFound = extract3DPoints(matchesFound, P_l, P_r);
    
    threshold = 0.3; 
    matchesFound = removeBadMatches(matchesFound, threshold);
    
    [matchesFound, objects] = add3DDimensions(matchesFound, data_l, data_r);
    
else
    % No Matches found
    objects = [];
end

plot_analysis_images = false;
if plot_analysis_images
    writeAnalysisImages(frame_id, image_l, image_r, data_l, data_r, P_l, P_r)
end




end

