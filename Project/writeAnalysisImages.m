function writeAnalysisImages(frame_id, image_l, image_r, data_l, data_r, P_l, P_r)

f = figure('visible','off');

imagesc(image_l)
hold on
for i=1:size(data_l,2)
    key_points = data_l{i}.keypoints;
    %meanKeyPoints = mean(key_points(:,1:4),2);
    plot(key_points(1,:), key_points(2,:), '.', 'markersize', 10)
    %conf = data_l{i}.confidence;
    %text(meanKeyPoints(1), meanKeyPoints(2), sprintf('%.2f', conf), 'Color','red');
    %key_points2 = matchesFound{i}.ProjectedL;
    %plot(key_points2(1,:), key_points2(2,:), 'o', 'markersize', 10)
    % if ~isempty(data_right)
    %     key_points_2 = data_right{matchFoundL2R(i)}.keypoints;
    %     plot(key_points_2(1,:), key_points_2(2,:), 'o', 'markersize', 10)
    % end
    
end

%for i=1:size(data_right,2)
%    key_points = data_right{i}.keypoints;
%    plot(key_points(1,:), key_points(2,:), 'o', 'markersize', 10)
%end
axis equal
saveas(f,sprintf('data/analysis_images/%d_L.png', frame_id));
f = figure('visible','off');

imagesc(image_r)
hold on
for i=1:size(data_r,2)
    key_points = data_r{i}.keypoints;
    %key_points = pflat(K_r\makeHomogenous(key_points));
    plot(key_points(1,:), key_points(2,:), '.', 'markersize', 10)
    %conf = matchesFound{i}.RightProb;
    %%meanKeyPoints = mean(key_points(:,1:4),2);
    %text(meanKeyPoints(1), meanKeyPoints(2), sprintf('%.2f', conf), 'Color','red');
    %key_points2 = matchesFound{i}.ProjectedR;
    %plot(key_points2(1,:), key_points2(2,:), 'o', 'markersize', 10)
    %if ~isempty(data_left)
    %key_points_2 = data_left{matchFoundR2L(i)}.keypoints;
    %plot(key_points_2(1,:), key_points_2(2,:), 'o', 'markersize', 10)
    %end
end
axis equal
saveas(f,sprintf('data/analysis_images/%d_R.png', frame_id));

% 3D image

end