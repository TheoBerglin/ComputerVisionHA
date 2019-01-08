function [matchesFound, Objects] = add3DDimensions(matchesFound, data_l, data_r)
backIndices = [1 4 5 8];
frontIndices = [2 3 6 7];
leftIndices = [1 2 5 6];
topIndices = [5 6 7 8];
bottomIndices = [1 2 3 4];
rightIndices = [3 4 7 8];
maxLength = 7;
maxWidth = 4;
maxHeight = 2;
objInd = 1;
for i = 1 : size(matchesFound,2)
    X = pflat(matchesFound{i}.X);
    
    topX = X(:, topIndices);
    mTopX = mean(topX, 2);
    bottomX = X(:, bottomIndices);
    mBottomX = mean(bottomX, 2);
    
    frontX = X(:, frontIndices);
    mFrontX = mean(frontX, 2);
    backX = X(:, backIndices);
    mBackX = mean(backX, 2);
    
    leftX = X(:, leftIndices);
    mLeftX = mean(leftX, 2);
    rightX = X(:, rightIndices);
    mRightX = mean(rightX, 2);
    
    height = norm(mTopX(1:2)-mBottomX(1:2));
    %height = norm(mTopX-mBottomX);
    length = norm(mFrontX-mBackX);
    width = norm(mLeftX-mRightX);
    C = mBottomX';
    dir = mFrontX-mBackX;
    dir = dir/norm(dir);
    ry = -pi/2+atan2(dir(1), dir(3));
    % Not best result but correct angle, take this one
    
    %ry = -pi/2+atan2(dir(1), dir(3));
    %A6 = [24.153297 16.943949 15.721835];
    %B6=[ 23.826998 16.628098 15.537840];
    
    %Even better
    %ry = -pi/2-atan2(dir(1), dir(3));
    %A5 = [24.666285 16.919193 15.822511];
    %B5 = [23.932848 16.452993 15.223326];
    %sum(A5)+sum(B5)
    
    % This is the best one now!!
    %ry = pi/2+atan2(dir(1), dir(3));
    %A4=[ 24.153297 16.943949 15.721835];
    %B4=[23.826998 16.628098 15.537840];
   %car_detection_3D_AP_0.5 : 25.939396 17.440710 16.124456
    %car_orientation_3D_AHS_0.5 : 21.823376 15.545636 14.272030
    % Best total score!! 
    % A3 = [25.939396 17.440710 16.124456];
    % B3 = [21.823376 15.545636 14.272030];
    %ry = -atan(dir(1)/dir(2));
%    if sign(dir(3))<0
%        ry =  sign(dir(3))*atan2(dir(1), dir(2));
%    else
%        ry = -sign(dir(3))*atan2(dir(1), dir(2));
%    end
    %25.939396 17.440710 16.124456
    %car_orientation_3D_AHS_0.5 : 18.552464 13.952285 12.487526
    %ry = -
    %car_detection_3D_AP_0.5 : 28.283537 20.263559 16.723133
    %car_orientation_3D_AHS_0.5 : 19.378700 13.303169 11.851776
    %A1 = [28.283537 20.263559 16.723133];
    %B1=[ 19.378700 13.303169 11.851776];
    %dir = mFrontX-mBackX;
    %dir = dir/norm(dir);
    %ry = -sign(dir(3))*atan(dir(1)/dir(2));
    
    %ry = -sign(dir(3))*atan(dir(1)/dir(2));
    
    
     %car_detection_3D_AP_0.5 : 27.865612 19.803295 16.376457
    %car_orientation_3D_AHS_0.5 : 19.917274 14.213417 12.455518
    % BEST
    %A2 = [27.865612 19.803295 16.376457];
    %B2=[ 19.917274 14.213417 12.455518];
    %ry = -atan2(dir(1), -dir(2));
    
    %ry = -atan2(dir(1), dir(2));
    if matchesFound{i}.LeftProb>= matchesFound{i}.RightProb
        mostProbableSide = data_l;
        indices = 'LeftIndex';
        mostProbableSize = data_l{matchesFound{i}.LeftIndex}.size;
        mostProbableDepth = data_l{matchesFound{i}.LeftIndex}.depth;
    else
        mostProbableSide = data_r;
        indices = 'RightIndex';
        mostProbableSize = data_r{matchesFound{i}.RightIndex}.size;
        mostProbableDepth = data_r{matchesFound{i}.RightIndex}.depth;
    end
    
    C = C*mostProbableDepth/norm(C);
    if height <0 || height >0%maxHeight
        height = mostProbableSize(1);
        %height = mostProbableSide{matchesFound{i}.(indices)}.size(1);
    end
    
    if width <0 || width >0%maxWidth
        width = mostProbableSize(2);
        %width = mostProbableSide{matchesFound{i}.(indices)}.size(2);
    end
    
    if length <0 || length >0%maxLength
        length = mostProbableSize(3);
        %length = mostProbableSide{matchesFound{i}.(indices)}.size(3);
    end
    
    if height >0 && height < maxHeight && width >0 && width<maxWidth && length >0 && length <maxLength
        Objects(objInd).h = height;        % Object height: meters
        Objects(objInd).w = width;        % Object width: meters
        Objects(objInd).l = length;        % Object length: meters
        Objects(objInd).t = C; % X, Y, Z: meters, world (camera) coordinates
        Objects(objInd).ry = ry;       % Object yaw angle: radians,
        p = max(matchesFound{i}.LeftProb, matchesFound{i}.RightProb);
        Objects(objInd).score = log(p/(1-p));
        objInd = objInd + 1;
    
    %else
        %fprintf('Denna suger: %.2f\n', max(matchesFound{i}.LeftProb, matchesFound{i}.RightProb))
        %disp(mostProbableSide{matchesFound{i}.(indices)}.size)
        %fprintf('%.2f, %.2f, %.2f \n', height, width, length)
        
    end
    
    
end
if ~exist('Objects', 'var')
    %Objects(1).h = 1.45;        % Object height: meters
    %Objects(1).w = 1.6;        % Object width: meters
    %Objects(1).l = 3.2;        % Object length: meters
    %Objects(1).t = [-5.5 1.77 9.9]; % X, Y, Z: meters, world (camera) coordinates
    %Objects(1).ry = 1.56;       % Object yaw angle: radians,
    %Objects(1).score = 5.7;    % How confident are you in this detection? Used to rank detections for PR-curve
    Objects = [];
end
end