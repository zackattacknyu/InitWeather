function [ error ] = classErrorImage( baseImage,compareImage )
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

equMatrix = (baseImageBinned~=compareImageBinned);
numEntries = size(equMatrix,1)*size(equMatrix,2);
error = sum(equMatrix(:))/numEntries;

end

