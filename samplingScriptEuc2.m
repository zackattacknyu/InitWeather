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
slotDist=minDist/2;
slots = zeros([floor(nImgs/slotDist)+1 floor(size(img1)/slotDist)]+1);

%
numPatchesPerImage = 50;
patchSize = 40;
numTotalPatches = numPatchesPerImage*nImgs;
patchSum = zeros(1,numTotalPatches);
randPatches2 = cell(1,numTotalPatches);
randPatchesResize2 = cell(1,numTotalPatches);
randPatchesCornerCoord2 = cell(1,numTotalPatches);
randIndices = randperm(nImgs);
imgIndex = 1;

for j=1:nImgs
    
    if(mod(j,50)==0)
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
       
       slotT = floor(curIndex/slotDist)+1;
       slotX = floor(randStartRow/slotDist)+1;
       slotY = floor(randStartCol/slotDist)+1;
       
       if(slots(slotT,slotX,slotY) > 0)
          continue; 
       end
       
       slots(slotT,slotX,slotY)=1;
       
       randPatch = curImage(...
           (randStartRow-patchSize/2):(randStartRow+patchSize/2-1),...
           (randStartCol-patchSize/2):(randStartCol+patchSize/2-1));
       
       curLocation = [randStartRow randStartCol j];
       
       ourPatch = halfPatch(randPatch);
       curPatchSum = sum(ourPatch(:));
       %if(curPatchSum > 1000)
       if(curPatchSum > 0)
            patchSum(imgIndex) = curPatchSum;
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

patchSum = patchSum(1:(imgIndex-1));
randPatches = randPatches2(1:(imgIndex-1));
randPatchesResize = randPatchesResize2(1:(imgIndex-1));
randPatchesCornerCoord = randPatchesCornerCoord2(1:(imgIndex-1));

save('patchSetGood10_7.mat','randPatches','randPatchesResize',...
    'randPatchesCornerCoord','patchSum','-v7.3');

save('patchSet10_7_allData.mat','-v7.3');

%%

minDist = 20;
maxNum = length(randPatches);
newRandPatches2 = cell(1,maxNum);
newRandPatchesLoc2 = cell(1,maxNum);
curIndex=1;

%closest ones
for i = 1:maxNum
    patchLoc = randPatchesCornerCoord{i};
    numBad=0;
    for j=1:(curIndex-1)
        curLoc = newRandPatchesLoc2{j};
        if(norm(patchLoc-curLoc)<minDist)
           numBad = numBad+1; 
        end
    end
    if(numBad<1)
        newRandPatches2{curIndex} = randPatches{i};
        newRandPatchesLoc2{curIndex} = patchLoc;
        curIndex = curIndex + 1;
    end
    if(mod(i,100)==0)
       i 
    end
end
newRandPatches = newRandPatches2(1:(curIndex-1));
newRandPatchesLoc = newRandPatchesLoc2(1:(curIndex-1));

save('patchSet_10_7_revised.mat','newRandPatches','newRandPatchesLoc','-v7.3');

%%
%display random images from our set
%   no binning
patchSize = 20;
numImages = length(newPatches);

numHoriz = 5;
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

%%
imgToShow = reshape(newPatches(imageNumbers(1),:,:),[patchSize patchSize]); 
imagesc(imgToShow,[0 8000]);
colormap jet;
colorbar;
axis image;






