load('rejectionSamplingPatches2.mat');

%%

%display random images from our set

patchSize = 10;
numImages = size(newPatches,1);

numHoriz = 4;
numVert = 6;
binNum = 3;

numPatches = 12;
patches = cell(1,numPatches);
imgIndex = 1;

for tryNum = 1:numHoriz*numVert
    imageNumbers = imagesInEachBin{binNum};         
   binNum = binNum+1;
   if(~isempty(imageNumbers))
       curImageNum = floor(rand(1,1)*length(imageNumbers))+1;
       imgToShow = reshape(newPatches(imageNumbers(curImageNum),:,:),[patchSize patchSize]); 
       patches{imgIndex} = imgToShow;
       imgIndex = imgIndex + 1;
   end

   if(imgIndex > numPatches)
      break; 
   end
end


%%
basePatchNum = floor(rand(1,1)*numPatches) + 1;
basePatch = patches{basePatchNum};

figure
imagesc(basePatch);

%%


mseVals = zeros(1,numPatches);
for k = 1:numPatches
    curPatch = patches{k};
    mseVals(k) = mean((curPatch(:)-basePatch(:)).^2);
end
[orderedMSE,indices] = sort(mseVals);

patchSize = 10;
[baseWeight,basePixelLocs] = getFeatureWeight(basePatch);

nImages = length(patches);
emdDists = zeros(1,nImages);
emdDistsWithPenalty = zeros(1,nImages);
emdDistsWithPenSquared = zeros(1,nImages);
curMaxPixel = 0;
%alpha1 = 1e-4;
alpha1 = 1;
%alpha2 = 1e-8;
alpha2 = 1;
for i = 1:nImages
    curPatch = patches{i};
    curMaxPixel = max(max(max(curPatch)),curMaxPixel);
    [weight,pixelLocs] = getFeatureWeight(curPatch);
    [xVals,f] = emd(pixelLocs,basePixelLocs,weight,baseWeight,@getPixelDist);
    
    %approach where we add alpha(x - x^)
    f1 = f + (alpha1/sum(xVals))*abs(sum(sum(curPatch)) - sum(sum(basePatch)));
    
    %approach where ad add alpha*(x-x^)^2
    f2 = f + (alpha2/sum(xVals))*(sum(sum(curPatch)) - sum(sum(basePatch)))^2;
    f
    emdDists(i) = f;
    emdDistsWithPenSquared(i) = f2;
    emdDistsWithPenalty(i) = f1;
end

[~,bestIndices] = sort(emdDists);
[~,bestIndicesPen] = sort(emdDistsWithPenalty);
[~,bestIndicesPenSqu] = sort(emdDistsWithPenSquared);

%%

%got good results with 10 by 10 patches
save('goodEMDResults2.mat','indices','distsFromCenter',...
    'patches','basePatch','bestIndices','emdDists','-v7.3');

%%
load('goodEMDResults.mat');
%%
load('goodEMDResults2.mat');
%%

numPatches = length(patches);

maxPixel = 0;
for k = 1:length(patches)
   maxPixel = max( max(max(patches{k})) , maxPixel); 
end

%%
figure
colormap bone;
colorbar;
imagesc(basePatch, [0 maxPixel])

%%
figure
colormap bone;
colorbar;
for k = 1:numPatches
   subplot(3,4,k);
   imagesc(patches{indices(k)}, [0 maxPixel])
end

figure
colormap bone;
colorbar;
for k = 1:numPatches
   subplot(3,4,k);
   imagesc(patches{bestIndices(k)}, [0 maxPixel])
end

figure
colormap bone;
colorbar;
for k = 1:numPatches
   subplot(3,4,k);
   imagesc(patches{bestIndicesPen(k)}, [0 maxPixel])
end

figure
colormap bone;
colorbar;
for k = 1:numPatches
   subplot(3,4,k);
   imagesc(patches{bestIndicesPenSqu(k)}, [0 maxPixel])
end