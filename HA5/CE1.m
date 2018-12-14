clear all, close all, clc;
load('HA5_ess.mat')
load('compEx1data.mat');
%% Create camera structure
save_fig = true;
P = {P1_UN ,P2_UN};
maxIterations = 100;
lambda = 1;
X = X./X(4,:);
[errors, P, res1, res2] = runLevenbergMaquardt(lambda, maxIterations, P, X, x);
clc
%%
figure()
histogram(res1, 100,'FaceAlpha', 1);
xlabel('Residual errors', 'interpreter', 'latex', 'FontSize', 18)
if save_fig
   saveFigureOwn('CE1_Residuals_Prior') 
end
figure()
histogram(res2, 100,'FaceAlpha', 1);
xlabel('Residual errors', 'interpreter', 'latex', 'FontSize', 18)
if save_fig
   saveFigureOwn('CE1_Residuals_After') 
end
figure()
plot(errors)
xlabel('Iterations', 'interpreter', 'latex', 'FontSize', 18)
ylabel('Reprojection error', 'interpreter', 'latex', 'FontSize', 18)
if save_fig
   saveFigureOwn('CE1_Reprojection_error') 
end

figure()
start = 10;
x_vec = start:length(errors)-1;
plot(x_vec, errors(start+1:end))
xlim([x_vec(1), x_vec(end)])
xlabel('Iterations', 'interpreter', 'latex', 'FontSize', 18)
ylabel('Reprojection error', 'interpreter', 'latex', 'FontSize', 18)
if save_fig
   saveFigureOwn('CE1_Reprojection_error_not_all') 
end
save('HA5_CE2', 'P')
function [errors,P, res1, res2] = runLevenbergMaquardt(lambda, maxIterations, P, U, u)
errors = ones(1, maxIterations+1);
[errors(1), res1] = ComputeReprojectionError(P,U,u);

for i=1:maxIterations
    [r,J] = LinearizeReprojErr(P,U,u);
    % Computes the LM update .
    C = J'*J+lambda*speye(size(J ,2));
    c = J'*r;
    deltav = -C\c;
    % Updates the variabels
    [P , U ] = update_solution(deltav,P,U);
    [errors(i+1), ~] = ComputeReprojectionError(P,U,u);
    
end
[~, res2] = ComputeReprojectionError(P,U,u);

end