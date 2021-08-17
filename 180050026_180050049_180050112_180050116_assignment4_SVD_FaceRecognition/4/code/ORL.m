function [out1,out2] = ORL(K)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
tic;
X_train = zeros(112*92,32*6);
X_test = zeros(112*92,32*4);
Y_train = zeros(1,32*6);
Y_test = zeros(1,32*4);
tr_i=1;
te_i=1;
for i = 1:32
    d = dir(fullfile('..','data','ORL',"s"+int2str(i),'*.pgm'));
    for k = 1:6
        temp = imread(fullfile('..','data','ORL',"s"+int2str(i),d(k).name));
        temp = reshape(temp,[],1);
        X_train(:,tr_i) = temp;
        Y_train(:,tr_i) = i;
        tr_i = tr_i+1;
    end  
    for k = 7:10
        temp = imread(fullfile('..','data','ORL',"s"+int2str(i),d(k).name));
        temp = reshape(temp,[],1);
        X_test(:,te_i) = temp;
        Y_test(:,te_i) = i;
        te_i = te_i+1;
    end
end

out1 = zeros(1,13);

% using svd on X;
X_mean = mean(X_train,2);
X = X_train - X_mean;
Y = X_test - X_mean;
[U,S,~] = svd(X);
eig_f = U;
eig_f = normc(eig_f);
out_i=1;
for i = K
    temp = eig_f(:,1:i);
    alpha_train = (temp.')*X;
    alpha_test = (temp.')*Y;
    correct = 0;
    for j = 1:32*4
        test = alpha_test(:,j);
        dif = alpha_train - test;
        dif = dif.^2;
        dif = sum(dif,1);
        [~,Ind] = min(dif);
        if Y_test(:,j) == Y_train(:,Ind)
            correct = correct+1;
        end
    end
    out1(:,out_i) = correct/(32*4);
    out_i=out_i+1;
end
out1 = 100*out1;
out2 = zeros(1,13);

% using eig on L = X'*X ;
X_mean = mean(X_train,2);
X = X_train - X_mean;
Y = X_test - X_mean;
L = (X.')*X;
[V,D] = eigs(L,32*6);
eig_f = X*V;
eig_f = normc(eig_f);
out_i=1;
for i = K
    temp = eig_f(:,1:i);
    alpha_train = (temp.')*X;
    alpha_test = (temp.')*Y;
    correct = 0;
    for j = 1:32*4
        test = alpha_test(:,j);
        dif = alpha_train - test;
        dif = dif.^2;
        dif = sum(dif,1);
        [~,Ind] = min(dif);
        if Y_test(:,j) == Y_train(:,Ind)
            correct = correct+1;
        end
    end
    out2(:,out_i) = correct/(32*4);
    out_i=out_i+1;
end
out2 = 100*out2;

% percentage accuracy using SVD for different K
disp(out1);

% percentage accuracy using eig for different K
disp(out2);
end