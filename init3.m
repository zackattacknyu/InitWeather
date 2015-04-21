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
numPatchesPerImage = 40;
patchSize = 30;
maxAttempts = 50;
numTotalPatches = numPatchesPerImage*nImgs;
patchSum = zeros(1,numTotalPatches);
randPatches = zeros(numPatchesPerImage*nImgs,patchSize,patchSize);
imgIndex = 1;

for j=1:nImgs
    
    curImage = reshape(allImgs(j,:,:),imgSize);
    
    for k = 1:numPatchesPerImage
        
       randStartInd = ceil(rand(1,2).*(imgSize - [patchSize patchSize]));
       randStartRow = randStartInd(1);
       randStartCol = randStartInd(2);
       randPatch = curImage(...
           randStartRow:(randStartRow+patchSize-1),...
           randStartCol:(randStartCol+patchSize-1));
       
       patchSum(imgIndex) = sum(randPatch(:));
       imgIndex = imgIndex+1;
       
       if(mod(imgIndex,1000) == 0)
         imgIndex 
       end

    end
end
%%

total = 0;
numBins = 30;
for binNum=1:30
    total = total + sum(N)/(numBins*N(binNum));
end



%%

numBins = 30;
[N,data] = hist(patchSum,numBins);
%semilogy(N);

%obtains a very large sample of patches
nImgs = size(randPatches,1);
patchSize = 30;
patchSum = zeros(1,numTotalPatches);
numTotal = 2000;
newPatches = zeros(numTotal,patchSize,patchSize);
imgIndex = 1;

for j=1:nImgs
    
    curImage = reshape(randPatches(j,:,:),[patchSize patchSize]);
    patchSum = sum(curImage(:));
    [~,binNum] = min(abs(data-patchSum));
    
    probPicking = sum(N)/(numBins*N(binNum));
    %CONTINUE THIS LOOP LATER

   if(mod(j,1000) == 0)
     imgIndex 
   end
end

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






