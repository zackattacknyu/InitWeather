function [ sumSquError ] = getSquaredError( xVec,W1,W2 )
%GETSQUAREDERROR Summary of this function goes here
%   Detailed explanation goes here

n = floor(sqrt(length(xVec)));
xMat = reshape(xVec,n,n);
w1guess = sum(xMat,1); 
w1guess = w1guess';
w2guess = sum(xMat,2);

sumSquError = sum((w1guess-W1).^2) + sum((w2guess-W2).^2);


end

