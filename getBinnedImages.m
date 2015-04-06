function [ baseImageBinned,compareImageBinned ] = getBinnedImages( baseImage,compareImage,numBins )
%GETBINNEDIMAGES Summary of this function goes here
%   Detailed explanation goes here

%{
allVals = [baseImage(:);compareImage(:)];
minVal = min(allVals);
maxVal = max(allVals);
%}

maxVal = 9100; %the global maximum
minVal = 0; %the global minimum;

baseImageNorm = (baseImage-minVal)./(maxVal-minVal);
compareImageNorm = (compareImage-minVal)./(maxVal-minVal);

baseImageBinned = floor(baseImageNorm*numBins);
compareImageBinned = floor(compareImageNorm*numBins);

end

