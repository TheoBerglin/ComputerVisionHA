function data = calculateInitialPlanes(data, K)
%CALCULATEPLANES Summary of this function goes here
%   Detailed explanation goes here

n_objects = size(kp, 2);
for i = 1 : n_objects
    data{i}.N_keypoints = K\makeHomgenous(data{i}.keypoints);
    data{i}.zone = getZone(data{i}.keypoints);
    data{i}.direction = getDirection(data{i}.keyPoints);
    data{i}.mostProbablePlane = calculateMostProbablePlane(data{i});
    % Car viewing angle is the difference between the front and back mean
    % point normalized. Use this to choose which planes to calculate.
    
end

end

function plane = calculateMostProbablePlane(data)
bestIndices = getBestIndices(data);




end

function indices = getBestIndices(data)
backIndices = [1 4 5 8];
frontIndices = [2 3 6 7];
leftIndices = [1 2 5 6];
rightIndices = [3 4 7 8];
%topIndices = [5 6 7 8];
%bottomIndices = [1 2 3 4];
if data.zone == 2
    
else
    if data.direction == 1
        if data.zone == 1
            indices = leftIndices;
        else
            indices = frontIndices;
        end
        
    elseif data.direction == 2
        if data.zone == 1
            indices = frontIndices;
        else
            indices = rightIndices;
        end
    elseif data.direction == 3
        if data.zone == 1
            indices = backIndices;
        else
            indices = leftIndices;
        end
    elseif data.direction == 4
        if data.zone == 1
            indices = rightIndices;
        else
            indices = backIndices;
        end
    elseif data.direction == 5
        indices = leftIndices;
    elseif data.direction == 6
        indices = rightIndices;
    end
    
end
end

function dir = getDirection(keyPoints)
C = keyPoints(:, 2) -keyPoints(:,1);
Csign = sign(C);

if Csign(2) == -1 && Csign(1) == -1
    dir = 1;
elseif Csign(2) == -1 && Csign(1) == 1
    dir = 2;
elseif Csign(2) == 1 && Csign(1) == -1
    dir = 3;
elseif Csign(2) == 1 && Csign(1) == 1
    dir = 4;
end
% Could belooking horizontally
angleD = atand(C(2)/C(1));
if abs(angleD) < 10
    if Csign(1) == -1
        dir = 5;
    elseif Csign(1) == 1
        dir = 6;
    end
end


end

function zone = getZone(keyPoints)
xMean = mean(keyPoints(1,:));
xMiddle = 1242/2;
if xMean < (xMiddle - 100)
    zone = 1;
elseif xMean > (xMiddle + 100)
    zone = 3;
else
    zone = 2;
end

end