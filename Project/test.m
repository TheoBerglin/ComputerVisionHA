function test(P_left, P_right)
[K,R] = rq(P_right);
T = [R(:,1:3)' -R(:,1:3)'*R(:,4); 0 0 0 1];
P_right = P_right*T;
P_left = P_left*T;

%rescale images
[K,R] = rq(P_left);
%K(1:2,:) = K(1:2,:)*sc;
P_left = K*R;
[K,R] = rq(P_right);
%K(1:2,:) = K(1:2,:)*sc;
P_right = K*R;
end