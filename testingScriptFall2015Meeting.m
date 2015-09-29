
%new set of patch numbers
patchNums = [2746 239 1015 3944 4175];
%2476 is the low precip one

%%
numRows = 1;
numCol = 11;
pp = 1;
for pp = 1:1
    
    basePatchNum = patchNums(pp);
    basePatch = patches{basePatchNum};
    basePatch = floor(abs(basePatch));
    maxPixel = max(basePatch(:));
    emdQP = emdQPArrays{pp};
    mseArr = getMSEarray(basePatch,patches);
    [~,inds] = sort(emdQP);
    [~,inds2] = sort(mseArr);
    
    %displays target
    figure
    colormap jet
    imagesc(basePatch,[0 maxPixel]);
    colorbar;
    axis off
    
    displayBestPatches( patches,inds,maxPixel,numRows,numCol );
    displayBestPatches( patches,inds2,maxPixel,numRows,numCol );
end

%%
patchSum = zeros(1,length(patches));
for i = 1:length(patches)
    curPatch = patches{i};
   patchSum(i) = sum(curPatch(:));
end

[~,leastPrecip] = sort(patchSum);
mostPrecip = fliplr(leastPrecip);
%%

%display images from our set

%parameters
patchNums=mostPrecip;
%patchNums = randperm(numImages);

patchSize = 20;
numImages = length(patches);

numHoriz = 20;
numVert = 10;
index = 1;


maxPixel = 0;
for i = 1:(numHoriz*numVert)
   curImage = patches{i};
   maxCurImage = max(curImage(:));
   maxPixel = max(maxPixel,maxCurImage);
end

figure
for h = 1:numHoriz
    for v = 1:numVert
        curImageNum = patchNums(index);
       imgToShow = patches{curImageNum};
       subplot(numHoriz,numVert,index);
       index = index + 1;
       imagesc(imgToShow);
       %imagesc(imgToShow,[0 maxPixel]);
       colormap jet;
       axis image;
       axis off;
    end
end