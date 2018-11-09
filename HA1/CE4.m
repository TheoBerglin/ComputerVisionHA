clear all, close all, clc;
load('compEx4.mat')
%% Images loaded
im1 = imread('compEx4im1.jpg');
im2 = imread('compEx4im2.jpg');
%% Plot images
figure()
imagesc(im1)
colormap gray

figure()
imagesc(im2)
colormap gray
%%