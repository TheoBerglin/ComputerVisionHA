x = 0:0.1:3;
y = 0.5.*x+0.5;
figure()
plot(1,1, 'x')
hold on
plot(3,2, 'x')
plot(x,y)
line = lineFromPoints([1 3;1 2]);
y2 = line(1).*x+line(3);
y2 = -line(2)*y2;
plot(x, y2, '-o')

function coefficients = lineFromPoints(points_cart)
p_diff = points_cart(:,2)-points_cart(:,1);
k = p_diff(2)/p_diff(1);
m = points_cart(2,2)-k*points_cart(1,2);
coefficients = [k -1 m]';
%line_coeff = polyfit([points_cart(1,1), points_cart(1,2)], [points_cart(2,1), points_cart(2,2)], 1);
%coefficients = [1/line_coeff(2), -line_coeff(1)/line_coeff(2), +1]';
end