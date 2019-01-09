%% Settings (you can change this part) %%
clear

output_path = 'outputs';
experiment_name = 'version_1';
write_output_to_files = true;

use_images = true;
plot_outputs = true;
frames_to_plot = [000322, 000917, 004388, 4835, 6365, 4465,1512, 6394, 3825];

%% Main (you do not need to change this, see runFrame.m instead) %%
addpath('data', 'util')

data_list = importdata('train_list.txt');
load('data.mat')

disp(['Experiment name: ', experiment_name])

if ~use_images
    disp("To use image data, make sure it is downloaded to data/images and that usage is activated in main.m")
end

if write_output_to_files
    path = fullfile(output_path, experiment_name, 'data');
    if ~exist(path, 'dir')
        mkdir(path);
    end
    disp(['Writing outputs to ', path])
end

for frame_id = data_list'
    frame_id_str = num2str(frame_id, '%06.f');
    
    % Load data
    data_left = getfield(left, strcat('img_', frame_id_str));
    data_right = getfield(right, strcat('img_', frame_id_str));
    
    if size(data_left,2) ~= size(data_right,2)
      %  frames_to_plot = [frames_to_plot, frame_id];
       fprintf('%s, %d, %d\n', frame_id_str, size(data_left,2), size(data_right,2)) 
    end
    
    P_left = readCalibration('data/calib', frame_id, 2);
    P_right = readCalibration('data/calib', frame_id, 3);
    
    
    % Run algorithm
    if use_images
        img_left = imread(strcat('data/images/left/', frame_id_str, '.png'));
        img_right = imread(strcat('data/images/right/', frame_id_str, '.png'));
        frame_detections = runFrame(data_left, data_right, P_left, P_right, img_left, img_right);
    else
        frame_detections = runFrame(data_left, data_right, P_left, P_right);
    end
    % Save results
    if write_output_to_files
        writeLabels(frame_detections, path, frame_id, P_left);
    end
    
    
    % Plot results
    if use_images && plot_outputs && ismember(frame_id, frames_to_plot)
        plotImg(frame_detections, img_left, img_right, P_left, P_right, frame_id);
    end
end