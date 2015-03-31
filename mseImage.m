function [ mse ] = mseImage( baseImage,compareImage )
%MSEIMAGE Summary of this function goes here
%   Detailed explanation goes here

diffImage = (baseImage-compareImage).^2;
mse = mean(diffImage(:));

end

