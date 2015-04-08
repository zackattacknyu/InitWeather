function [ error ] = yesNoErrorImage( baseImage,compareImage,minThreshold )
%MSEIMAGE Summary of this function goes here
%   Detailed explanation goes here

baseImageBinned = baseImage>minThreshold;
compareImageBinned = compareImage>minThreshold;

equMatrix = (baseImageBinned~=compareImageBinned);
numEntries = size(equMatrix,1)*size(equMatrix,2);
error = sum(equMatrix(:))/numEntries;

end

