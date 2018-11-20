CE1
clearvars -except T1 T2 PT1 PT2 P
close all
clc
%%
im_ind = 1;
[KT1, ~] = rq(PT1{im_ind})

[KT2, ~] = rq(PT2{im_ind})

im_ind = 1;
[K, ~] = rq(P{im_ind})


