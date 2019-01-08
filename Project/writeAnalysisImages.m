function writeAnalysisImages(frame_id, img_left, img_right, matchesFound, P_l, P_r)

f = figure('visible','off');

imagesc(img_left)
hold on
for i=1:size(matchesFound,2)
    key_points = matchesFound{i}.LeftKeyPoints;
    meanKeyPoints = mean(key_points(:,1:4),2);
    plot(key_points(1,:), key_points(2,:), '.', 'markersize', 10)
    conf = matchesFound{i}.LeftProb;
    text(meanKeyPoints(1), meanKeyPoints(2), sprintf('%.2f', conf), 'Color','red');
    key_points2 = matchesFound{i}.ProjectedL;
    plot(key_points2(1,:), key_points2(2,:), 'o', 'markersize', 10)
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

imagesc(img_right)
hold on
for i=1:size(matchesFound,2)
    key_points = matchesFound{i}.RightKeyPoints;
    %key_points = pflat(K_r\makeHomogenous(key_points));
    plot(key_points(1,:), key_points(2,:), '.', 'markersize', 10)
    conf = matchesFound{i}.RightProb;
    meanKeyPoints = mean(key_points(:,1:4),2);
    text(meanKeyPoints(1), meanKeyPoints(2), sprintf('%.2f', conf), 'Color','red');
    key_points2 = matchesFound{i}.ProjectedR;
    plot(key_points2(1,:), key_points2(2,:), 'o', 'markersize', 10)
    %if ~isempty(data_left)
    %key_points_2 = data_left{matchFoundR2L(i)}.keypoints;
    %plot(key_points_2(1,:), key_points_2(2,:), 'o', 'markersize', 10)
    %end
end
axis equal
saveas(f,sprintf('data/analysis_images/%d_R.png', frame_id));

% 3D image

f = figure('visible','off');
%f = figure()

plotcams({P_l, P_r});
hold on

for i=1:size(matchesFound,2)
    X = pflat(matchesFound{i}.X);
    %key_points = pflat(K_r\makeHomogenous(key_points));
    plot3(X(1,:), X(2,:), X(3,:), '.-', 'markersize', 10)
    conf = matchesFound{i}.RightProb;
    meanKeyPoints = mean(X(:,1:4),2);
    %text(meanKeyPoints(1), meanKeyPoints(2),meanKeyPoints(3), sprintf('%.2f', conf), 'Color','red');
    %key_points2 = matchesFound{i}.ProjectedR;
    %plot(key_points2(1,:), key_points2(2,:), 'o', 'markersize', 10)
    %if ~isempty(data_left)
    %key_points_2 = data_left{matchFoundR2L(i)}.keypoints;
    %plot(key_points_2(1,:), key_points_2(2,:), 'o', 'markersize', 10)
    %end
end

saveas(f,sprintf('data/analysis_images/%d_3D.png', frame_id));

end