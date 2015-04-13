function [ sortedImgs,errorVals,bestImgs ] = makeSortedImages( ...
baseImage,imgsToCompare, errorMethod )
%MAKESORTEDIMAGES Summary of this function goes here
%   Detailed explanation goes here

%This does the comparison between a base image and a set of images
% Input is baseImage, which has dimensions Height x Width
%        imgsToCompare, which has dimensions NumImages x Height x Width

numCompareImages = size(imgsToCompare,1);
height = size(imgsToCompare,2);
width = size(imgsToCompare,3);
errors = zeros(1,numCompareImages);

numBins = 91;
minThreshold = 100;

for j = 1:numCompareImages
    
    currentCompareImg = reshape(imgsToCompare(j,:,:),[height width]);
    
    %error is computed here
    switch errorMethod
        case 1
            errors(j) = mseImage(baseImage,currentCompareImg);
        case 2
            errors(j) = meanErrorImage(baseImage,currentCompareImg);
        case 3
            errors(j) = classErrorImage(baseImage,currentCompareImg,numBins);
        case 4
            errors(j) = classDistErrorImage(baseImage,currentCompareImg,numBins);
        case 5
            errors(j) = classMseErrorImage(baseImage,currentCompareImg,numBins);
        case 6
            errors(j) = yesNoErrorImage(baseImage,currentCompareImg,minThreshold);
        case 7
            errors(j) = yesNoWeightedErrorImage(baseImage,currentCompareImg,minThreshold);
    end
end

[errorVals,bestImgs] = sort(errors);
sortedImgs = imgsToCompare(bestImgs,:,:);

end

