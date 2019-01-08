function [bestH, maxInliners] = calculateHomographyRANSAC(m, rRuns, threshold, x, y)
n_points = size(x,2);
maxInliners = 0;
bestH = 0;
for i = 1:rRuns
    randIndices = randperm(n_points, m); % Grab m random points
    xsub = x(:, randIndices);
    ysub = y(:,randIndices);
    M = setUpM(xsub, ysub);
    v = null(M); % Solve directly 
    H = reshape(v(:,end), [3,3])'; % Reshape solution
    inliners = getInliners(H, threshold, x, y);
    if inliners > maxInliners
        maxInliners = inliners;
        bestH = H;
    end
end
end
function inliners = getInliners(H, threshold, x, y)
x_proj = pflat(H*x);
x = pflat(y);
diff = x-x_proj;
diff2 = diff.^2;
dist = sqrt(sum(diff2,1));
inliners = dist < threshold;
inliners = sum(inliners);
end


function M = setUpM(x, y)
x = x./x(3,:);
y = y./y(3,:);
M = zeros(size(y,2), 9);
for i=1:size(y,2)
    row1 = 2*i-1;
    
    
    yi = y(:,i);
    xi = x(:,i);
    M(row1, 4:6) = -xi';
    M(row1+1,1:3) = xi';
    
    M(row1, 7:9) =  yi(2)*xi';
    M(row1+1, 7:9) = -yi(1)*xi';
end
end