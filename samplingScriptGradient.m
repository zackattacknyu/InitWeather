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
    numTries = min(length(randGoods),500);
    
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
       
       slotT = floor(curIndex/minDist)+1;
       slotX = floor(randStartRow/minDist)+1;
       slotY = floor(randStartCol/minDist)+1;
       
       if(slots(slotT,slotX,slotY) <= 0)
           for ii = -1:1
              for jj = -1:1
                 for kk = -1:1
                     slotTii = slotT + ii;
                     slotXjj = slotX + jj;
                     slotYkk = slotY + kk;
                     if(slotTii > 0 && slotTii <= size(slots,1) &&...
                             slotXjj > 0 && slotXjj <= size(slots,2) &&...
                             slotYkk > 0 && slotYkk <= size(slots,3))
                         slots(slotT+ii,slotX+jj,slotY+kk)=1;
                     end

                 end
              end
           end
           
           
           ourPatch = halfPatch(randPatch);
           curPatchSum = sum(ourPatch(:));
           %if(curPatchSum > 1000)
           if(curPatchSum > 0)
                patchSum(imgIndex) = sum(ourPatch(:));
                patchIndex{imgIndex} = [curIndex;randStartRow;randStartCol];
               randPatches2{imgIndex} = ourPatch;
               imgIndex = imgIndex+1;

               if(mod(imgIndex,100) == 0)
                 imgIndex 
               end
           end
           
       end
       

    end
end

patchSum = patchSum(1:(imgIndex-1));
randPatches = randPatches2(1:(imgIndex-1));
patchIndex = patchIndex(1:(imgIndex-1));

%%

save('gradientPatchSet_9-14.mat','randPatches','patchSum','-v7.3');

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

%%
imgToShow = reshape(newPatches(imageNumbers(1),:,:),[patchSize patchSize]); 
imagesc(imgToShow,[0 8000]);
colormap jet;
colorbar;
axis image;






