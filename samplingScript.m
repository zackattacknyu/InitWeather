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
%allImgs = zeros([nImgs size(gt1)]);
allImgs = cell(1,nImgs);

%%

for i = 1:nImgs
%for i = 1:3
    
    % Get image id: YYMMDDHHmm
    imgId = imgIds{i};
    
    ST4 = load([trnImgDir 'ST4/' imgId(1:end-2) '.mat']);
    gt = ST4.I;
    
    allImgs{i} = gt;
    
    if(mod(i,10)==0)
       i 
    end
    
  
    
end

%%

save('gtImages.mat','allImgs','-v7.3');

%%
load('gtImages.mat');

%%

%obtains a very large sample of patches
nImgs = length(allImgs);
numPatchesPerImage = 50;
patchSize = 20;
maxAttempts = 50;
numTotalPatches = numPatchesPerImage*nImgs;
patchSum = zeros(1,numTotalPatches);
randPatches = cell(1,numTotalPatches);
randIndices = randperm(nImgs);
imgIndex = 1;

for j=1:nImgs
    
    curImage = allImgs{randIndices(j)};
    
    for k = 1:numPatchesPerImage
        
       randStartInd = ceil(rand(1,2).*(size(curImage) - [patchSize patchSize]));
       randStartRow = randStartInd(1);
       randStartCol = randStartInd(2);
       randPatch = curImage(...
           randStartRow:(randStartRow+patchSize-1),...
           randStartCol:(randStartCol+patchSize-1));
       
       patchSum(imgIndex) = sum(randPatch(:));
       randPatches{imgIndex} = randPatch;
       imgIndex = imgIndex+1;
       
       if(mod(imgIndex,1000) == 0)
         imgIndex 
       end

    end
end

%%

save('largePatchSet3.mat','randPatches','patchSum','-v7.3');

%%

load('largePatchSet3.mat');

%%
patchSum(patchSum<0) = [];
%%
numBins = 30;
[N,data] = hist(patchSum,numBins);
semilogy(N);
%%
%obtains a very large sample of patches
nImgs = length(randPatches);
patchSize = 20;
numTotal = 2000;
newPatches = zeros(numTotal,patchSize,patchSize);
numPickedInBin = zeros(1,numBins);
numPerBinMax = 50;
imgIndex = 1;
imagesInEachBin = cell(1,numBins);

for j=1:nImgs
    
    curImage = randPatches{j};
    curPatchSum = sum(curImage(:));
    [~,binNum] = min(abs(data-curPatchSum));
    
    if(numPickedInBin(binNum) < numPerBinMax)
        numPickedInBin(binNum) = numPickedInBin(binNum) + 1;
        newPatches(imgIndex,:,:) = randPatches{j};
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

save('rejectionSamplingPatches3.mat','newPatches','imagesInEachBin','numPickedInBin','-v7.3');

%%

load('rejectionSamplingPatches3.mat');

%%

%display random images from our set

patchSize = 20;
numImages = size(newPatches,1);

numHoriz = 4;
numVert = 6;
binNum = 2;

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






