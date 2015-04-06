function [ baseImageBinned,compareImageBinned ] = getBinnedImages( baseImage,compareImage,numBins )
%GETBINNEDIMAGES Summary of this function goes here
%   Detailed explanation goes here

allVals = [baseImage(:);compareImage(:)];
minVal = min(allVals);
maxVal = max(allVals);

baseImageNorm = (baseImage-minVal)./(maxVal-minVal);
compareImageNorm = (compareImage-minVal)./(maxVal-minVal);

baseImageBinned = floor(baseImageNorm*numBins);
compareImageBinned = floor(compareImageNorm*numBins);

end

