function [ error ] = classMseErrorImage( baseImage,compareImage )
%MSEIMAGE Summary of this function goes here
%   Detailed explanation goes here

allVals = [baseImage(:);compareImage(:)];
minVal = min(allVals);
maxVal = max(allVals);

baseImageNorm = (baseImage-minVal)./(maxVal-minVal);
compareImageNorm = (baseImage-minVal)./(maxVal-minVal);

numBins = 256;

baseImageBinned = floor(baseImageNorm*numBins);
compareImageBinned = floor(compareImageNorm*numBins);

diffMatrix = (baseImageBinned-compareImageBinned).^2;
error = mean(diffMatrix(:));

end

