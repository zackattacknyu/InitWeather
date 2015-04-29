trnImgDir = 'train/';
imgIds = getImgIds(trnImgDir);

% select training window

imgIds = imgIds(1:end);
nImgs = length(imgIds);
    
%%

imgId = imgIds{1};   
ST4 = load([trnImgDir 'ST4/' imgId(1:end-2) '.mat']);
gt1 = ST4.I;

%%
allImgs = zeros([nImgs size(gt1)]);

%%

for i = 1:nImgs
%for i = 1:3
    
    % Get image id: YYMMDDHHmm
    imgId = imgIds{i};
    
    ST4 = load([trnImgDir 'ST4/' imgId(1:end-2) '.mat']);
    gt = ST4.I;
    
    allImgs(i,:,:) = gt;
    
    if(mod(i,10)==0)
       i 
    end
    
  
    
end

%%

save('allGTimages.mat','allImgs','-v7.3');

%%
load('allGTimages.mat');

%%

%obtains a very large sample of patches
nImgs = size(allImgs,1);
imgSize = [size(allImgs,2) size(allImgs,3)];
numPatchesPerImage = 50;
patchSize = 30;
maxAttempts = 50;
numTotalPatches = numPatchesPerImage*nImgs;
patchSum = zeros(1,numTotalPatches);
randPatches = zeros(numTotalPatches,patchSize,patchSize);
randIndices = randperm(nImgs);
imgIndex = 1;

for j=1:nImgs
    
    curImage = reshape(allImgs(randIndices(j),:,:),imgSize);
    
    for k = 1:numPatchesPerImage
        
       randStartInd = ceil(rand(1,2).*(imgSize - [patchSize patchSize]));
       randStartRow = randStartInd(1);
       randStartCol = randStartInd(2);
       randPatch = curImage(...
           randStartRow:(randStartRow+patchSize-1),...
           randStartCol:(randStartCol+patchSize-1));
       
       patchSum(imgIndex) = sum(randPatch(:));
       randPatches(imgIndex,:,:) = randPatch;
       imgIndex = imgIndex+1;
       
       if(mod(imgIndex,1000) == 0)
         imgIndex 
       end

    end
end

%%

save('largePatchSet.mat','randPatches','patchSum','-v7.3');

%%

load('largePatchSet.mat');

%%
numBins = 30;
[N,data] = hist(patchSum,numBins);
%semilogy(N);

%obtains a very large sample of patches
nImgs = size(randPatches,1);
patchSize = 30;
numTotal = 2000;
newPatches = zeros(numTotal,patchSize,patchSize);
numPickedInBin = zeros(1,numBins);
numPerBinMax = 50;
imgIndex = 1;
imagesInEachBin = cell(1,numBins);

for j=1:nImgs
    
    curImage = reshape(randPatches(j,:,:),[patchSize patchSize]);
    patchSum = sum(curImage(:));
    [~,binNum] = min(abs(data-patchSum));
    
    if(numPickedInBin(binNum) < numPerBinMax)
        numPickedInBin(binNum) = numPickedInBin(binNum) + 1;
        newPatches(imgIndex,:,:) = randPatches(j,:,:);
        imagesInEachBin{binNum} = [imagesInEachBin{binNum} imgIndex];
        imgIndex = imgIndex + 1;
    end
    
    if(imgIndex > numTotal)
       break; 
    end

   if(mod(j,1000) == 0)
     imgIndex 
   end
end

newPatches = newPatches(1:(imgIndex-1),:,:);

%%

save('rejectionSamplingPatches.mat','newPatches','-v7.3');

%%

load('rejectionSamplingPatches.mat');

%%

patchSize = 30;

%obtain earth-mover distance

%{
Image 360 and 342 gave us EMD of 3.8089
Image 361 and 342 gave us EMD of 3.5532
%}
img1Num = 361; img2Num = 342;
patch1 = reshape(newPatches(img1Num,:,:),[patchSize patchSize]);
patch2 = reshape(newPatches(img2Num,:,:),[patchSize patchSize]);

patch1Resized = imresize(patch1,0.5);
patch2Resized = imresize(patch2,0.5);
patch1Resized2 = imresize(patch1,0.25);
patch2Resized2 = imresize(patch2,0.25);

figure
subplot(3,2,1)
imagesc(patch1)
axis image
subplot(3,2,2)
imagesc(patch2)
axis image
subplot(3,2,3)
imagesc(patch1Resized)
axis image
subplot(3,2,4)
imagesc(patch2Resized)
axis image
subplot(3,2,5)
imagesc(patch1Resized2)
axis image
subplot(3,2,6)
imagesc(patch2Resized2)
axis image

%%
[weight1, pixelLocs1] = getFeatureWeight(patch1Resized2);
[weight2, pixelLocs2] = getFeatureWeight(patch2Resized2);

[x,f] = emd(pixelLocs1,pixelLocs2,weight1,weight2,@getPixelDist);

%%

%display random images from our set

patchSize = 30;
numImages = size(newPatches,1);

numHoriz = 5;
numVert = 6;
binNum = 1;

figure
for h = 1:numHoriz
    for v = 1:numVert
       imageNumbers = imagesInEachBin{binNum};         
       binNum = binNum+1;
       if(~isempty(imageNumbers))
           curImageNum = floor(rand(1,1)*length(imageNumbers))+1;
           imgToShow = reshape(newPatches(imageNumbers(curImageNum),:,:),[patchSize patchSize]); 
           subplot(numHoriz,numVert,binNum-1);
           imagesc(imgToShow,[0 max(max(max(newPatches)))]);
           colormap jet;
           axis image;
       end
       
    end
end

%%
imgToShow = reshape(newPatches(imageNumbers(1),:,:),[patchSize patchSize]); 
imagesc(imgToShow,[0 8000]);
colormap jet;
colorbar;
axis image;

%%


patchSize = 30;
numImages = size(randPatches,1);

baseImage = reshape(randPatches(randImgNum,:,:),[patchSize patchSize]);

%{
figure
imagesc(baseImage);
colormap jet;
colorbar;
%}

numMethods = 7;
numPlots = 8;

figure
for method = 1:numMethods
    [sortedImgs,~,~] = makeSortedImages(baseImage,randPatches,method);
    for i = 1:numPlots
       imgToShow = reshape(sortedImgs(i,:,:),[patchSize patchSize]); 
       subplot(numMethods,numPlots,(method-1)*numPlots + i);
       imagesc(imgToShow);
       colormap jet;
       axis image;
    end
end






