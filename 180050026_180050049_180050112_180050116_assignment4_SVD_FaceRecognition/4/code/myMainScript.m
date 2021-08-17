%% MyMainScript
%% USING ORL DATASET
tic;
K = [1, 2, 3, 5, 10, 15, 20, 30, 50, 75, 100, 150, 170];
[out_a_svd,out_b_eig] = ORL(K);
figure;
plot(K,out_a_svd);
title('Plot of % recognition rate v/s k using SVD, ORL Dataset');
xlabel('k') ;
ylabel('percentage recognition rate') ;
figure;
plot(K,out_b_eig);
title('Plot of % recognition rate v/s k using eig, ORL Dataset');
xlabel('k') ;
ylabel('percentage recognition rate') ;
toc;
%% USING YALE DATASET
tic;
K = [1, 2, 3, 5, 10, 15, 20, 30, 50, 60, 65, 75, 100, 200, 300, 500, 1000];
[yale_a_svd,yale_b_svd] = Yalessd(K);
figure;
plot(K,yale_a_svd);
title('Plot of % recognition rate, including top 3 eigen vectors');
xlabel('k') ;
ylabel('percentage recognition rate') ;
figure;
plot(K,yale_b_svd);
title('Plot of % recognition rate, without including top 3 eigen vectors');
xlabel('k') ;
ylabel('percentage recognition rate') ;
toc;


