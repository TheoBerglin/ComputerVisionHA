function projectedKeyPoints = projectKeyPoints(keypoints1, F, keypoints2)
projectedKeyPoints = zeros(size(keypoints1));
epipolarLines = calculateEpipolarLines(F, keypoints1);
x1 = 0;
x2 = 1200;
maximumMovement = 4;
for i = 1 : size(keypoints2,2)
   point = keypoints2(:,i);
   line = epipolarLines(:,i);
   %Project point on line
   p1 = [x1;getY(line,x1)];
   p2 = [x2;getY(line,x2)];
   v = getDirection(p1,p2);
   u = point-p1;
   pointProj = sum(u.*v)/norm(v)^2*v+p1;
   
   if norm(pointProj - point) < maximumMovement
        projectedKeyPoints(:,i) = pointProj;
   else
       projectedKeyPoints(:,i) = point;
   end
   
    
end

end
function dir = getDirection(p1, p2)
A = p2-p1;
dir = A;
end

function y = getY(line,x)
y = -(line(3)+line(1)*x)/line(2);

end