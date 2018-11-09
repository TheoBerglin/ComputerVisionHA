clc, clear all, close all
load('assignment1data/compEx3.mat')
%% Plot initial data
figure()
plotLines(startpoints, endpoints)







function plotLines(s_p, e_p)

plot([s_p(1,:); e_p(1,:)], [s_p(2,:); e_p(2,:)], 'b-')

end