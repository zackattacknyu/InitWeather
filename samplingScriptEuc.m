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
%imgBlock = zeros(200,200,7147);

%%

for i = 1:nImgs
%for i = 1:3
    
    % Get image id: YYMMDDHHmm
    imgId = imgIds{i};
    
    ST4 = load([trnImgDir 'ST4/' imgId(1:end-2) '.mat']);
    gt = ST4.I;
    
    allImgs{i} = gt;
    %imgBlock(:,:,i) = gt;
    
    if(mod(i,10)==0)
       i 
    end
    
  
    
end

%%

save('gtImages.mat','allImgs','-v7.3');

%%
load('gtImages.mat');
%%

imgBlock = zeros(200,200,7147);
for i = 1:7147
   imgBlock(:,:,i) = allImgs{i}; 
end

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
    
    if(mod(j,100) == 0)
      j 
    end
    
    curIndex = randIndices(j);
    
    curImage = allImgs{curIndex};
    
    %[Gmag,Gdir] = imgradient(curImage);
    %inds = (Gmag<100)&(curImage>100);
    inds = (curImage>100);
    randGoods = find(inds);
    goodInds = randGoods(randperm(length(randGoods)));
    [indsR,indsC] = ind2sub(size(curImage),goodInds);
    
    for k = 1:length(randGoods)
        
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
       
       curLocation = [randStartRow randStartCol j];
       numBad=0;
       
       %{
       for ii = 1:(imgIndex-1)
           otherLoc = randPatchesCornerCoord2{ii};
            if(norm(curLocation-otherLoc)<minDist)
               numBad = numBad+1; 
            end
       end
       if(numBad>0)
          continue; 
       end
       %}
       
       %if(curPatchSum > 1000)
       if(curPatchSum > 500)
            patchSum(imgIndex) = sum(ourPatch(:));
            patchIndex{imgIndex} = [curIndex;randStartRow;randStartCol];
            randPatches2{imgIndex} = ourPatch;
            shrunkPatch = imresize(ourPatch,0.2);
            randPatchesResize2{imgIndex} = shrunkPatch(:);
            randPatchesCornerCoord2{imgIndex} = curLocation;
            imgIndex = imgIndex+1;

            if(mod(imgIndex,100) == 0)
              imgIndex 
            end
       end
       

    end
end
%%
patchSum = patchSum(1:(imgIndex-1));
randPatches = randPatches2(1:(imgIndex-1));
randPatchesResize = randPatchesResize2(1:(imgIndex-1));
randPatchesCornerCoord = randPatchesCornerCoord2(1:(imgIndex-1));
patchIndex = patchIndex(1:(imgIndex-1));


%%

save('eucPatchSet_9-22.mat','randPatches','patchSum','randPatchesResize','randPatchesCornerCoord','-v7.3');
%%

resizePatch1 = randPatchesResize{1};
resizeData = zeros(length(randPatchesResize),length(resizePatch1));
for i = 1:length(randPatchesResize)
    curResizedPatch = randPatchesResize{i};
    resizeData(i,:) = curResizedPatch'; 
end

%%
numRows = 10;
numCol = 10;

%from pca 9-16 set
%basePatchNum = 65155;

%from pca 9-17 set
%basePatchNum = 118690;
%basePatchNum = 87792;
basePatchNum=17598;

basePatch = patches{basePatchNum};
basePatch = floor(abs(basePatch));
maxPixel = max(basePatch(:));

%%
distDiff = resizeData-repmat(resizeData(basePatchNum,:),size(resizeData,1),1);
eucDists = sum(distDiff.^2,2);
[~,inds2] = sort(eucDists);
%%
eucDists = sum(resizeData.^2,2);
[~,inds2] = sort(eucDists);
%mseArr = getMSEarray(basePatch,patches);
%[~,inds2] = sort(mseArr);
%%
%displayBestPatches( patches,inds,maxPixel,numRows,numCol );
displayBestPatches( patches,1:150,maxPixel,numRows,numCol );



%%

minDist = 20;
maxNum = 150;
newRandPatches = cell(1,maxNum);
newRandPatchesLoc = cell(1,maxNum);
curIndex = 2;

newRandPatches{1} = basePatch;
newRandPatchesLoc{1} = randPatchesCornerCoord{basePatchNum};

%closest ones
for i = 1:length(inds2)
    curPatchInd = inds2(i);
    patchLoc = randPatchesCornerCoord{curPatchInd};
    numBad=0;
    for j=1:(curIndex-1)
        curLoc = newRandPatchesLoc{j};
        if(norm(patchLoc-curLoc)<minDist)
           numBad = numBad+1; 
        end
    end
    if(numBad<1)
        newRandPatches{curIndex} = randPatches{curPatchInd};
        newRandPatchesLoc{curIndex} = patchLoc;
        curIndex = curIndex + 1;
    end
    if(curIndex > maxNum)
       break
    end
end


%%
%displayBestPatches( newRandPatches,1:400,maxPixel,numRows,numCol );
displayBestPatches( patches,randperm(3000),maxPixel,numRows,numCol );

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







