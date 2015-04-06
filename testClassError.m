load('goodPatches.mat');

numImages = size(randPatches,1);
imgNum1 = ceil(rand(1,1)*numImages);
imgNum2 = ceil(rand(1,1)*numImages);
baseImage = reshape(randPatches(imgNum1,:,:),[patchSize patchSize]);
compareImage = reshape(randPatches(imgNum2,:,:),[patchSize patchSize]);
%%

minVal = min(min(min(randPatches)));
maxVal = max(max(max(randPatches)));

%%

baseImageNorm = (baseImage-minVal)./(maxVal-minVal);
compareImageNorm = (compareImage-minVal)./(maxVal-minVal);
%%
baseImageBinned = floor(baseImageNorm*numBins);
compareImageBinned = floor(compareImageNorm*numBins);

equMatrix = (baseImageBinned~=compareImageBinned);
numEntries = size(equMatrix,1)*size(equMatrix,2);
error = sum(equMatrix(:))/numEntries;

%%
figure
imagesc(baseImage);
figure
imagesc(compareImage);