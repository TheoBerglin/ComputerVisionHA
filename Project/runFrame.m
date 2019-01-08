function [objects] = runFrame(data_l, data_r,frame_id, P_l, P_r, image_l, image_r)

plot_analysis_images = false;
%RUNFRAME takes inputs from a stereo frame and yields 3D boxes
%
%   This is the function that you are supposed to complete.
%   Feel free to add extra files.
%
%   The output format of this file is exemplified also in:
%     example_frame_output.mat
%

%% INSERT YOUR CODE HERE
%test(P_l, P_r);
F1 = extractFundamentalMatrix(P_l, P_r);
F2 = extractFundamentalMatrix(P_r, P_l);
certaintyFactor = 1;
if size(data_l,2) == 0 || size(data_r, 2) == 0
    certaintyFactor = certaintyFactor*0.5; % No detection in one image will make it very uncertain
end

%% Works best with fewer cells
matchFoundL2R = epipolarDistanceMatch(data_l, data_r, F1); % Matched indices in right image
%data_l(matchFoundL2R(i))
matchFoundR2L = epipolarDistanceMatch(data_r, data_l, F2); % Matched indices in left image
%data_r(matchFoundR2L(i))
matches = getCellMatches(data_l, data_r, matchFoundL2R, F1, F2);

[matchesFound, matchesNotFound] = splitMatches(matches);
if ~isempty(matchesFound)
    if ~isempty(matchesNotFound)
        %disp('match not found');
        matchesFound = addUnfoundMatches(matchesFound, matchesNotFound, data_l, data_r);
    end
    threshold = 0.3;
    matchesFound = extract3DPoints(matchesFound, P_l, P_r);
    
    matchesFound = removeBadMatches(matchesFound, threshold);
    %frame_id
    [matchesFound, objects] = add3DDimensions(matchesFound, data_l, data_r);
    %objects = matchesFound.Objects;
    %fprintf('Inliners: %d, %d, %d, %d\n',frame_id, sum(maxInlinersL),sum(maxInlinersR), size(keypointsL,2));
    % matchesFound =
    %matchesFound = normalizeMatchesFound(matchesFound);
else
    %objects(1).h = 1.45;        % Object height: meters
    %objects(1).w = 1.6;        % Object width: meters
    %objects(1).l = 3.2;        % Object length: meters
    %objects(1).t = [-5.5 1.77 9.9]; % X, Y, Z: meters, world (camera) coordinates
    %objects(1).ry = 1.56;       % Object yaw angle: radians,
    %objects(1).score = 5.7;    % How confident are you in this detection? Used to rank detections for PR-curve
    objects = [];
end
%A = matches{1}.RightKeyPoints-data_r{1}.keypoints;
%B = matches{1}.LeftKeyPoints-data_l{1}.keypoints;
%fprintf('%.2f, %.2f\n', norm(A), norm(B));
%data_r{1}.keypoints
% Plot analysis images
if plot_analysis_images
    writeAnalysisImages(frame_id, image_l, image_r, matchesFound, P_l, P_r)
end
% Keep nonmatching points of high probability

%

%% Example output format. YOU SHOLD REMOVE THIS
% objects(1).h = 1.45;        % Object height: meters
% objects(1).w = 1.6;        % Object width: meters
% objects(1).l = 3.2;        % Object length: meters
% objects(1).t = [-5.5 1.77 9.9]; % X, Y, Z: meters, world (camera) coordinates
% objects(1).ry = 1.56;       % Object yaw angle: radians,
% objects(1).score = 5.7;    % How confident are you in this detection? Used to rank detections for PR-curve
% 
% objects(2).h = 1.6;
% objects(2).w = 1.55;
% objects(2).l = 3.62;
% objects(2).t = [7.5 1.3 14];
% objects(2).ry = -0.6;
% objects(2).score = 9.7;


end

