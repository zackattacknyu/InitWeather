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
origImage = allImgs{150};
image = origImage>100;
s = regionprops(image,'Centroid');
centroids = cat(1, s.Centroid);

figure
imagesc(origImage)

figure
imagesc(image)
hold on
plot(centroids(:,1),centroids(:,2), 'r*')
hold off

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
    binImage = curImage>100;
    s = regionprops(binImage,'Centroid');
    centroids = cat(1, s.Centroid);
    centroidInds = randperm(size(centroids,1));
    numTries = min(maxAttempts,size(centroids,1));
    
    for k = 1:numTries
        
        %INSERT CODE HERE TO FIND THE CENTROIDS
        %   AND THEN CHOOSE AMONG THEM
       randStartRow = floor(centroids(centroidInds(k),1));
       randStartCol = floor(centroids(centroidInds(k),2));
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
           if(curPatchSum > 1000)
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
%%
patchSum = patchSum(1:(imgIndex-1));
randPatches = randPatches2(1:(imgIndex-1));
patchIndex = patchIndex(1:(imgIndex-1));

%%

save('centroidPatchSet.mat','randPatches','patchSum','-v7.3');

%%

load('largePatchSet4.mat');

%%
patchSum(patchSum<0) = [];
%%
numBins = 30;
[N,data] = hist(patchSum,numBins);
semilogy(N);
%%
%obtains a very large sample of patches
nImgs = length(randPatches);
numTotal = 2000;
newPatches = cell(1,numTotal);
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
        newPatches{imgIndex} = randPatches{j};
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

newPatches = newPatches(1:(imgIndex-1));

%%

save('rejectionSamplingPatches4.mat','newPatches','imagesInEachBin','numPickedInBin','-v7.3');

%%

load('rejectionSamplingPatches4.mat');

%%

%display random images from our set

patchSize = 20;
numImages = size(newPatches,1);

numHoriz = 5;
numVert = 6;
binNum = 2;

figure
for h = 1:numHoriz
    for v = 1:numVert
       imageNumbers = imagesInEachBin{binNum};         
       binNum = binNum+1;
       if(~isempty(imageNumbers))
           curImageNum = floor(rand(1,1)*length(imageNumbers))+1;
           imgToShow = newPatches{imageNumbers(curImageNum)};
           subplot(numHoriz,numVert,binNum-1);
           imagesc(imgToShow,[0 5000]);
           colormap jet;
           axis image;
       end
       
    end
end
%%
%display random images from our set
%   no binning
patchSize = 20;
numImages = size(newPatches,1);

numHoriz = 5;
numVert = 6;
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
       
    end
end

%%
imgToShow = reshape(newPatches(imageNumbers(1),:,:),[patchSize patchSize]); 
imagesc(imgToShow,[0 8000]);
colormap jet;
colorbar;
axis image;






