function [ error ] = getTotalError( distMatrix, W1, W2, xVec )
%GETTOTALERROR Summary of this function goes here
%   Detailed explanation goes here

distPenalty = dot(distMatrix,xVec);

sumSquError = getSquaredError(xVec,W1,W2);

error = distPenalty + sumSquError;

end

