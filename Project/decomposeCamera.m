function [K, P_N] = decomposeCamera(P)
[K, P_N] = rq(P);
end