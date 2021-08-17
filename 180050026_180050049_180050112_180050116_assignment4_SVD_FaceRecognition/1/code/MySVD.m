function [U,S,V] = MySVD(A)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    [m,n] = size(A);
    A_L = A*(A.');
    A_R = (A.')*A;
    [U,~] = eigs(A_L);
    [V,~] = eigs(A_R);
    S = (U.')*A*(V);
    for i = 1:min(m,n)
         if S(i,i) <0
             U(:,i) = -1*U(:,i);   
         end
    end
    S = abs(S);
end