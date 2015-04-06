function [ error ] = classDistErrorImage( baseImage,compareImage )
%MSEIMAGE Summary of this function goes here
%   Detailed explanation goes here

[baseImageBinned,compareImageBinned] = getBinnedImages(baseImage,compareImage);

diffMatrix = abs(baseImageBinned-compareImageBinned);
error = mean(diffMatrix(:));

end

