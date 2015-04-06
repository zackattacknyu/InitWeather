function [ error ] = classErrorImage( baseImage,compareImage )
%MSEIMAGE Summary of this function goes here
%   Detailed explanation goes here

[baseImageBinned,compareImageBinned] = getBinnedImages(baseImage,compareImage);

equMatrix = (baseImageBinned~=compareImageBinned);
numEntries = size(equMatrix,1)*size(equMatrix,2);
error = sum(equMatrix(:))/numEntries;

end

