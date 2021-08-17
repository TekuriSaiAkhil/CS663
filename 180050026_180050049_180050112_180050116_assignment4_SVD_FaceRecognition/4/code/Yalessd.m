function [out1,out2] = Yalessd(K)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
tic;
X_train = zeros(192*168,38*40);
X_test = zeros(192*168,38*24);
Y_train = zeros(1,38*40);
Y_test = zeros(1,38*24);
tr_i=1;
te_i=1;
for i = 1:38
    if i<10
        d = dir(fullfile('..','data','CroppedYale',"yaleB0"+int2str(i),'*.pgm'));
        for k = 1:40
            temp = imread(fullfile('..','data','CroppedYale',"yaleB0"+int2str(i),d(k).name));
            temp = reshape(temp,[],1);
            X_train(:,tr_i) = temp;
            Y_train(:,tr_i) = i;
            tr_i = tr_i+1;
        end  
        for k = 41:size(d)
            temp = imread(fullfile('..','data','CroppedYale',"yaleB0"+int2str(i),d(k).name));
            temp = reshape(temp,[],1);
            X_test(:,te_i) = temp;
            Y_test(:,te_i) = i;
            te_i = te_i+1;
        end
    else
        if i~=14
    
            d = dir(fullfile('..','data','CroppedYale',"yaleB"+int2str(i),'*.pgm'));
            for k = 1:40
                temp = imread(fullfile('..','data','CroppedYale',"yaleB"+int2str(i),d(k).name));
                temp = reshape(temp,[],1);
                X_train(:,tr_i) = temp;
                Y_train(:,tr_i) = i;
                tr_i = tr_i+1;
            end  
            for k = 41:size(d)
                temp = imread(fullfile('..','data','CroppedYale',"yaleB"+int2str(i),d(k).name));
                temp = reshape(temp,[],1);
                X_test(:,te_i) = temp;
                Y_test(:,te_i) = i;
                te_i = te_i+1;
            end        
        
        end
    end
end

out1 = zeros(1,17);
out2 = zeros(1,17);
% using svd on X;
X_mean = mean(X_train,2);
X = X_train - X_mean;
Y = X_test - X_mean;
[U,S,~] = svd(X,'econ');
eig_f = U;
eig_f = normc(eig_f);
out_i=1;
for i = K
    temp = eig_f(:,1:i);
    alpha_train = (temp.')*X;
    alpha_test = (temp.')*Y;
    correct = 0;
    for j = 1:38*24
        test = alpha_test(:,j);
        dif = alpha_train - test;
        dif = dif.^2;
        dif = sum(dif,1);
        [~,Ind] = min(dif);
        if Y_test(:,j) == Y_train(:,Ind)
            correct = correct+1;
        end
    end
    out1(:,out_i) = correct/(38*24);
    out_i=out_i+1;
end

out1 = 100*out1;

out_i=1;
for i = K
    temp = eig_f(:,4:i+4-1);
    alpha_train = (temp.')*X;
    alpha_test = (temp.')*Y;
    correct = 0;
    for j = 1:38*24
        test = alpha_test(:,j);
        dif = alpha_train - test;
        dif = dif.^2;
        dif = sum(dif,1);
        [~,Ind] = min(dif);
        if Y_test(:,j) == Y_train(:,Ind)
            correct = correct+1;
        end
    end
    out2(:,out_i) = correct/(38*24);
    out_i=out_i+1;
end

out2 = 100*out2;
% percentage accuracy including top3 eigen vectors for different K
disp(out1);

% percentage accuracy without including top3 eigen vectors for different K
disp(out2);
end