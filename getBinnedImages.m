function [ baseImageBinned,compareImageBinned ] = getBinnedImages( baseImage,compareImage )
%GETBINNEDIMAGES Summary of this function goes here
%   Detailed explanation goes here

allVals = [baseImage(:);compareImage(:)];
minVal = min(allVals);
maxVal = max(allVals);

baseImageNorm = (baseImage-minVal)./(maxVal-minVal);
compareImageNorm = (compareImage-minVal)./(maxVal-minVal);

numBins = 256;

baseImageBinned = floor(baseImageNorm*numBins);
compareImageBinned = floor(compareImageNorm*numBins);

end

