function [ error ] = classDistErrorImage( baseImage,compareImage,numBins )
%MSEIMAGE Summary of this function goes here
%   Detailed explanation goes here

[baseImageBinned,compareImageBinned] = getBinnedImages(baseImage,compareImage,numBins);

diffMatrix = abs(baseImageBinned-compareImageBinned);
error = mean(diffMatrix(:));

end

