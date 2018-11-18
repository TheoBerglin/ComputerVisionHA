CE1
clearvars -except T1 T2 PT1 PT2
close all
clc
%%
im_ind = 1;
[K1, R1] = rq(PT1{im_ind})

[K2, R2] = rq(PT2{im_ind})
