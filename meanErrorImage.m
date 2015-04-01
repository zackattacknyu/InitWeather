function [ mse ] = meanErrorImage( baseImage,compareImage )
%MSEIMAGE Summary of this function goes here
%   Detailed explanation goes here

diffImage = abs(baseImage-compareImage);
mse = mean(diffImage(:));

end

