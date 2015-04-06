function [ error ] = classMseErrorImage( baseImage,compareImage )
%MSEIMAGE Summary of this function goes here
%   Detailed explanation goes here

[baseImageBinned,compareImageBinned] = getBinnedImages(baseImage,compareImage);

diffMatrix = (baseImageBinned-compareImageBinned).^2;
error = mean(diffMatrix(:));

end

