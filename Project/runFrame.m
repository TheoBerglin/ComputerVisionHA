function [objects] = runFrame(data_l, data_r, P_l, P_r, image_l, image_r)
%RUNFRAME takes inputs from a stereo frame and yields 3D boxes
%
%   This is the function that you are supposed to complete.
%   Feel free to add extra files.
%
%   The output format of this file is exemplified also in:
%     example_frame_output.mat
%

%% INSERT YOUR CODE HERE

%% Example output format. YOU SHOLD REMOVE THIS
objects(1).h = 1.45;        % Object height: meters
objects(1).w = 1.6;        % Object width: meters
objects(1).l = 3.2;        % Object length: meters
objects(1).t = [-5.5 1.77 9.9]; % X, Y, Z: meters, world (camera) coordinates
objects(1).ry = 1.56;       % Object yaw angle: radians, 
objects(1).score = 5.7;    % How confident are you in this detection? Used to rank detections for PR-curve

objects(2).h = 1.6;
objects(2).w = 1.55;
objects(2).l = 3.62;
objects(2).t = [7.5 1.3 14];
objects(2).ry = -0.6;
objects(2).score = 9.7;

