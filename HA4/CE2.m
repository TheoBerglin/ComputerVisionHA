clear all, close all, clc
A = imread('assignment4data\a.jpg');
B = imread('assignment4data\b.jpg');
save_fig = false;
%%
[fA dA] = vl_sift(single(rgb2gray(A)));
[fB dB] = vl_sift(single(rgb2gray(B)));
matches = vl_ubcmatch (dA ,dB );
xA = fA (1:2 , matches (1 ,:));
xB = fB (1:2 , matches (2 ,:));

perm = randperm(size(matches ,2));
figure;
imagesc ([ A B ]);
hold on;
plot([xA(1, perm(1:10)); xB(1, perm(1:10))+ size(A ,2)] , ...
    [xA(2, perm (1:10)); xB(2, perm (1:10))] , '-');
hold off;

fprintf('The number of features for A is: %d\n', size(dA,2))
fprintf('The number of features for B is: %d\n', size(dB,2))
fprintf('The number of matches are: %d\n', size(matches,2))
%% Set up M for DLT
[bestH, maxInliners] = calculateHomographyRANSAC(4, 5, 5, makeHomogenous(xA), makeHomogenous(xB));

fprintf('The number of inliners are: %d\n', sum(maxInliners))

%% Projection

tform = maketform ('projective',bestH');
% Creates a transfomation that matlab can use for images
% Note : imtransform uses the transposed homography
transfbounds = findbounds (tform ,[1 1;size(A, 2) size(A, 1)]);
% Finds the bounds of the transformed image
xdata = [min([ transfbounds(: ,1); 1]) max([ transfbounds(: ,1); size(B ,2)])];
ydata = [min([ transfbounds(: ,2); 1]) max([ transfbounds(: ,2); size(B ,1)])];
% Computes bounds of a new image such that both the old ones will fit.
[ newA ] = imtransform(A,tform ,'xdata ',xdata ,'ydata ',ydata );
% Transform the image using bestH
tform2 = maketform('projective',eye (3));
[ newB ] = imtransform(B,tform2 ,'xdata ',xdata ,'ydata ',ydata ,'size ',size ( newA ));
% Creates a larger version of B
newAB = newB ;
newAB ( newB < newA ) = newA ( newB < newA );
% Writes both images in the new image . %(A somewhat hacky solution is
figure()
imagesc(newAB)
if save_fig
    saveFigureOwn('CE2_panorama')
end
function xH = makeHomogenous(x)

xH = [x; ones(1, size(x,2))];
end
function [bestH, maxInliners] = calculateHomographyRANSAC(m, rRuns, threshold, x, y)
n_points = size(x,2);
maxInliners = [];
bestH = 0;
for i = 1:rRuns
    randIndices = randperm(n_points, m); % Grab m random points
    xsub = x(:, randIndices);
    ysub = y(:,randIndices);
    M = setUpM(xsub, ysub);
    v = null(M); % Solve directly 
    H = reshape(v(:,end), [3,3])'; % Reshape solution
    inliners = getInliners(H, threshold, x, y);
    if sum(inliners) > sum(maxInliners)
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
end


function Vn = solveAndAnalyzeSVD(M)
[~, ~, V] = svd(M);
Vn = V(:,end); % Corresponds to smallest eigenvalue

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

function saveFigureOwn(name)
export_fig(sprintf('Results/%s.pdf', name),...
    '-pdf','-transparent');
end
