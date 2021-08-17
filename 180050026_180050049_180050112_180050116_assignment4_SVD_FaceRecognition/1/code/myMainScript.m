%% Sample script to test MySVD function.
A = [[1,2,3];[4,5,6];[7,8,9]];
[U,S,V] = MySVD(A);

disp(sum(sum(U*S*(V.') - A)));

A = [[1,2];[4,5];[7,8]];
[U,S,V] = MySVD(A);

disp(sum(sum(U*S*(V.') - A)));

A = [[1,2,3];[4,5,6]];
[U,S,V] = MySVD(A);

disp(sum(sum(U*S*(V.') - A)));

A = randi([0, 10], [5,20]);
[U,S,V] = MySVD(A);

disp(sum(sum(U*S*(V.') - A)));

% As you can see, A = U*S*(V.')
% Ideally sum(sum(U*S*(V.') - A)) should be exactly zero.
% But here it is of the order of 10^-15 (negligible).
% This error is due to the precision errors in multiplication. 
