alphaVal = 0.1;
patchNums = [444];
call_7_29;
save('matlabRun_Patches9-23_resultData.mat','emdQPArrays','patches');
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

patchSum = patchSum(1:(imgIndex-1));
randPatches = randPatches2(1:(imgIndex-1));
randPatchesResize = randPatchesResize2(1:(imgIndex-1));
randPatchesCornerCoord = randPatchesCornerCoord2(1:(imgIndex-1));
patchIndex = patchIndex(1:(imgIndex-1));