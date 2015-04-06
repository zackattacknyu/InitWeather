load('goodPatches.mat');

imgNum1 = 142;
imgNum2 = 196;
baseImage = reshape(randPatches(imgNum1,:,:),[patchSize patchSize]);
compareImage = reshape(randPatches(imgNum2,:,:),[patchSize patchSize]);

[baseImageBinned,compareImageBinned] = getBinnedImages(baseImage,compareImage);

equMatrix = (baseImageBinned~=compareImageBinned);
numEntries = size(equMatrix,1)*size(equMatrix,2);
error = sum(equMatrix(:))/numEntries;

%%
figure
imagesc(baseImage);
figure
imagesc(compareImage);