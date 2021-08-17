%% MyMainScript

%% ORL dataset
% part a
tic;
X_train = zeros(112*92,32*6);
X_test = zeros(112*92,32*4);
Y_train = zeros(1,32*6);
Y_test = zeros(1,32*6);
tr_i=1;
te_i=1;
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

k = [2, 10, 20, 50, 75, 100, 125, 150, 175];
X_mean = mean(X_train,2);
X = X_train - X_mean;
Y = X_test - X_mean;
L = (X.')*X;
[V,D] = eigs(L,32*6);
eig_f = X*V;
eig_f = normc(eig_f);
Image = X(:,1);
figure; title("Reconstruction of face using top k eigen faces where k =")
for i = 1:9
    temp = eig_f(:,1:k(i));
    alpha_image = (temp.')*Image;
    recon = X_mean + (temp*alpha_image);
    recon = uint8(reshape(recon,[112,92]));
    
    subplot(3,3,i);imshow(recon);title("Reconstructed k = "+int2str(k(i)));   
end
figure; title("Plot of top 25 eigenfaces")
for i = 1:25
    a = reshape(eig_f(:,i),[112,92]);
    a = a +(-1*min(min(a)));
    subplot(5,5,i);imagesc(a);colormap('gray');title("Eigenface: "+int2str(i));     
end
toc;
