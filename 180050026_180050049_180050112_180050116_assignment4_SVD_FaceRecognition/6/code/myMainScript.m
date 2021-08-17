%% MyMainScript
% If we test our system on image of a person who is not in the dataset then
% the max probabilities will be very less when compared to when we test on 
% a image of a person in the dataset. 
% Therefore if we apply the threshold on the probability and if max
% probability is less than the threshold then we can say that this image
% does not match will any one in the dataset.
% But there may also be a case in which even if the image of a person who
% is in the dataset may have their max probabilities less than this 
% threshold. This may lead to some of the false negetives.
% So, there is a trade of between false negatives adn false positives.
% The thresold also depend on the value of K.
% here i fixed K= 50 and th=0.02,i got false_neg = 27, false_pos = 25;
% When  the th = 0.03,false_neg = 47, false_pos = 2;



%% ORL dataset
% part a
tic;
X_train = zeros(112*92,32*6);
X_test = zeros(112*92,32*4);
X_test_unseen = zeros(112*92,8*10);
Y_train = zeros(1,32*6);
Y_test = zeros(1,32*6);
Y_test_unseen = zeros(1,8*10);
tr_i=1;
te_i=1;
tn_i=1;
for i = 1:32
    d = dir(fullfile('..','data','ORL',"s"+int2str(i),'*.pgm'));
    for j = 1:6
        temp = imread(fullfile('..','data','ORL',"s"+int2str(i),d(j).name));
        temp = reshape(temp,[],1);
        X_train(:,tr_i) = temp;
        Y_train(:,tr_i) = i;
        tr_i = tr_i+1;
    end  
    for j = 7:10
        temp = imread(fullfile('..','data','ORL',"s"+int2str(i),d(j).name));
        temp = reshape(temp,[],1);
        X_test(:,te_i) = temp;
        Y_test(:,te_i) = i;
        te_i = te_i+1;
    end
end

for i = 33:40
     d = dir(fullfile('..','data','ORL',"s"+int2str(i),'*.pgm'));
    for j = 1:10
        temp = imread(fullfile('..','data','ORL',"s"+int2str(i),d(j).name));
        temp = reshape(temp,[],1);
        X_test_unseen(:,tn_i) = temp;
        Y_test_unseen(:,tn_i) = i;
        tn_i = tn_i+1;
    end 
end

X_mean = mean(X_train,2);
X = X_train - X_mean;
Y = X_test - X_mean;
X_unseen = X_test_unseen - X_mean;
L = (X.')*X;
[V,D] = eigs(L,32*6);
eig_f = X*V;
eig_f = normc(eig_f);

false_pos = 0;
false_neg = 0;
K = 50;
th = 0.02;
max_list = [];
max_list_n = [];
temp = eig_f(:,1:K);
alpha_train = (temp.')*X;
alpha_test = (temp.')*Y;
alpha_test_unseen = (temp.')*X_unseen;

    for j = 1:32*4
        test = alpha_test(:,j);
        dif = alpha_train - test;
        dif = dif.^2;
        dif = sum(dif,1);
        prob = 1./dif;
        prob = prob/sum(prob);
        [M,Ind] = max(prob);
        max_list =[max_list,M];
        if Y_test(:,j) == Y_train(:,Ind)
                if M < th
                    false_neg = false_neg + 1;
                end
        end
    end  
    for j = 1:8*10
        test_n = alpha_test_unseen(:,j);
        dif1 = alpha_train - test_n;
        dif1 = dif1.^2;
        dif1 = sum(dif1,1);
        prob = 1./dif1;
        prob = prob/sum(prob);
        [M1,Ind1] = max(prob);
        max_list_n =[max_list_n,M1];
        if M1 > th
            false_pos = false_pos + 1;
        end
    end    
% false_neg
disp(false_neg);

% false_pos
disp(false_pos);
toc;
