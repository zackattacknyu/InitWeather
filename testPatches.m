patchSize = 10;
numRows = 3;
numCol = 4;
numPatches = numRows*numCol;
maxRadius = 3;
minRadius = 1;
centerVariation = 4;

patches = cell(1,numPatches);
center = floor([patchSize/2 patchSize/2]);
centerVariants = floor(centerVariation*rand(numPatches,2));
centers = repmat(center,numPatches,1) + centerVariants;

%makes the first one the baseline
centers(1,:) = center;
centerVariants(1,:) = [0 0];


for k = 1:numPatches
   newPatch = zeros(patchSize,patchSize);
   curRadius = maxRadius*rand(1,1) + minRadius;
   for i = 1:patchSize
       for j = 1:patchSize
           dist = norm([i j] - centers(k,:));
           newPatch(i,j) = (dist/curRadius)^(1/2);
       end
   end
    patches{k} = newPatch;
end


figure
colormap bone;
colorbar;
for k = 1:numPatches
   subplot(3,4,k);
   imagesc(patches{k})
end


%%
basePatch = patches{1};

mseVals = zeros(1,numPatches);
for k = 1:numPatches
    curPatch = patches{k};
    mseVals(k) = mean((curPatch(:)-basePatch(:)).^2);
end
[orderedMSE,indices] = sort(mseVals);

%{
figure
colormap bone;
colorbar;
for k = 1:numPatches
   subplot(2,3,k);
   imagesc(patches{indices(k)})
end
%}
%%
distsFromCenter = sqrt(centerVariants(:,1).^2 + centerVariants(:,2).^2);
distsFromCenter(indices)

%%

%these are the ones for the 500x500 patches
save('goodMSEpatches.mat','patches','basePatch','-v7.3');
%%

%these are the ones for the 500x500 patches
load('goodMSEpatches.mat');

%%

%these are the ones for the 20x20 patches
save('goodMSEpatches2.mat','patches','basePatch','-v7.3');
%%

%these are the ones for the 20x20 patches
load('goodMSEpatches2.mat');

%%

%these are the ones for the 10x10 patches
save('goodMSEpatches3.mat','patches','basePatch','-v7.3');
%%

%these are the ones for the 10x10 patches
load('goodMSEpatches3.mat');

%%

patchSize = 10;
basePatch = patches{1};
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