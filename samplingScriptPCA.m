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
%nImgs = 100;
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
img1 = allImgs{1};
nImgs = length(allImgs);

%make octree for all the slots where sample
%   could come from in (x,y,t) space
minDist = 20;
slots = zeros([floor(nImgs/minDist)+1 floor(size(img1)/minDist)]+1);

%
numPatchesPerImage = 50;
patchSize = 40;
maxAttempts = 50;
numTotalPatches = numPatchesPerImage*nImgs;
patchSum = zeros(1,numTotalPatches);
randPatches2 = cell(1,numTotalPatches);
randPatchesResize2 = cell(1,numTotalPatches);
randPatchesCornerCoord2 = cell(1,numTotalPatches);
patchIndex = cell(1,numTotalPatches);
randIndices = randperm(nImgs);
imgIndex = 1;

for j=1:nImgs
    
    curIndex = randIndices(j);
    
    curImage = allImgs{curIndex};
    
    [Gmag,Gdir] = imgradient(curImage);
    %inds = (Gmag<100)&(curImage>100);
    inds = (curImage>100);
    randGoods = find(inds);
    goodInds = randGoods(randperm(length(randGoods)));
    [indsR,indsC] = ind2sub(size(curImage),goodInds);
    numTries = min(length(randGoods),60);
    
    for k = 1:numTries
        
       randStartRow = indsR(k);
       randStartCol = indsC(k);
       if(randStartRow-patchSize/2 < 1 || randStartRow+patchSize/2 > size(curImage,1))
          continue; 
       end
       if(randStartCol-patchSize/2 < 1 || randStartCol+patchSize/2 > size(curImage,2))
          continue; 
       end
       randPatch = curImage(...
           (randStartRow-patchSize/2):(randStartRow+patchSize/2-1),...
           (randStartCol-patchSize/2):(randStartCol+patchSize/2-1));
       
       ourPatch = halfPatch(randPatch);
       curPatchSum = sum(ourPatch(:));
       %if(curPatchSum > 1000)
       if(curPatchSum > 0)
            patchSum(imgIndex) = sum(ourPatch(:));
            patchIndex{imgIndex} = [curIndex;randStartRow;randStartCol];
            randPatches2{imgIndex} = ourPatch;
            shrunkPatch = imresize(ourPatch,0.2);
            randPatchesResize2{imgIndex} = shrunkPatch(:);
            randPatchesCornerCoord2{imgIndex} = [randStartRow randStartCol j];
            imgIndex = imgIndex+1;

            if(mod(imgIndex,100) == 0)
              imgIndex 
            end
       end
       

    end
end

patchSum = patchSum(1:(imgIndex-1));
randPatches = randPatches2(1:(imgIndex-1));
randPatchesResize = randPatchesResize2(1:(imgIndex-1));
randPatchesCornerCoord = randPatchesCornerCoord2(1:(imgIndex-1));
patchIndex = patchIndex(1:(imgIndex-1));

%%

save('pcaPatchSet_9-15.mat','randPatches','patchSum','randPatchesResize','-v7.3');
%%

resizePatch1 = randPatchesResize{1};
resizeData = zeros(length(randPatchesResize),length(resizePatch1));
for i = 1:length(randPatchesResize)
    curResizedPatch = randPatchesResize{i};
    resizeData(i,:) = curResizedPatch'; 
end

[coeff,score,latent] = pca(resizeData);

%%
numRows = 10;
numCol = 10;
basePatchNum = 65155;
basePatch = patches{basePatchNum};
basePatch = floor(abs(basePatch));
maxPixel = max(basePatch(:));
%%
scoreCol = score(:,1);
scoreDiff = abs(scoreCol-scoreCol(basePatchNum));
[~,inds] = sort(scoreDiff);
%%
distDiff = resizeData-repmat(resizeData(basePatchNum,:),size(resizeData,1),1);
eucDists = sum(distDiff.^2,2);
[~,inds2] = sort(eucDists);

%mseArr = getMSEarray(basePatch,patches);
%[~,inds2] = sort(mseArr);
%%
displayBestPatches( patches,inds,maxPixel,numRows,numCol );
displayBestPatches( patches,inds2,maxPixel,numRows,numCol );

%%

minDist = 20;
maxNum = 600;
newRandPatches = cell(1,maxNum);
targetLoc = randPatchesCornerCoord{basePatchNum};
curIndex = 1;

%closest ones
for i = 1:length(inds2)
    curPatchInd = inds2(i);
    patchLoc = randPatchesCornerCoord{curPatchInd};
    if(norm(patchLoc-targetLoc)>minDist)
        newRandPatches{curIndex} = randPatches{i};
        curIndex = curIndex + 1;
    end
    if(curIndex > maxNum/3)
       break
    end
end

%middle ones
for i = (floor(length(inds2)/2)):length(inds2)
    curPatchInd = inds2(i);
    patchLoc = randPatchesCornerCoord{curPatchInd};
    if(norm(patchLoc-targetLoc)>minDist)
        newRandPatches{curIndex} = randPatches{i};
        curIndex = curIndex + 1;
    end
    if(curIndex > 2*(maxNum/3))
       break
    end
end

%worst ones
for i = length(inds2):-1:1
    curPatchInd = inds2(i);
    patchLoc = randPatchesCornerCoord{curPatchInd};
    if(norm(patchLoc-targetLoc)>minDist)
        newRandPatches{curIndex} = randPatches{i};
        curIndex = curIndex + 1;
    end
    if(curIndex > maxNum)
       break
    end
end

newRandPatches{maxNum+1} = basePatch;

%%
%displayBestPatches( newRandPatches,1:400,maxPixel,numRows,numCol );
displayBestPatches( patches,vv,maxPixel,numRows,numCol );

%%
%display random images from our set
%   no binning
patchSize = 20;
numImages = length(newPatches);

numHoriz = 10;
numVert = 10;
index = 1;
patchNums = randperm(numImages);

maxPixel = 0;
for i = 1:(numHoriz*numVert)
   curImage = newPatches{i};
   maxCurImage = max(curImage(:));
   maxPixel = max(maxPixel,maxCurImage);
end

figure
for h = 1:numHoriz
    for v = 1:numVert
        curImageNum = patchNums(index);
       imgToShow = newPatches{curImageNum};
       subplot(numHoriz,numVert,index);
       index = index + 1;
       imagesc(imgToShow);
       %imagesc(imgToShow,[0 maxPixel]);
       colormap jet;
       axis image;
       axis off;
    end
end







