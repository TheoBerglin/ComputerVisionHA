function S = openGT(fileName)
%OPENGT Summary of this function goes here
%   Detailed explanation goes here
fid = fopen(fileName);
C = textscan(fid, '%s%f32%f32%f32%f32%f32%f32%f32%f32%f32%f32%f32%f32%f32');
fclose(fid);
f = {'a','b','c', 'd', 'e', 'f', 'g', 'h', 'i','j', 'k','l','m','n','o'};
s = cell2struct(C,f,2);
S = struct('h', s.d, 'w', s.e);
end

