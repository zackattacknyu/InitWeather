patchSize = 20;
%%
numRows = 6;
numCol = 8;
%%
numPatches = numRows*numCol;
maxRadius = 3;
minRadius = 2;
centerVariation = 3;

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
           dist = norm([i j] - centers(k,:),2);
           newPatch(i,j) = (dist<curRadius)*1;
       end
   end
    patches{k} = newPatch;
end


figure
colormap bone;
colorbar;
for k = 1:numPatches
   subplot(numRows,numCol,k);
   imagesc(patches{k})
   axis off
end


%%
basePatch = patches{1};

mseVals = zeros(1,numPatches);
for k = 1:numPatches
    curPatch = patches{k};
    mseVals(k) = mean((curPatch(:)-basePatch(:)).^2);
end
[orderedMSE,indices] = sort(mseVals);

%%
numPatches = 50;
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

%these are the ones for the revised 20x20 patches with L_Inf norm
save('goodMSEpatches4.mat','patches','basePatch','-v7.3');
%%

%these are the ones for the revised 20x20 patches with L_Inf norm
load('goodMSEpatches4.mat');
%%
%these are the ones for the revised 20x20 patches with L_1 norm
save('goodMSEpatches5.mat','patches','basePatch','-v7.3');
%%

%these are the ones for the revised 20x20 patches with L_1 norm
load('goodMSEpatches5.mat');

%%

%goes with Java Program
emdDists = load('emdResults/allEMDvalues.txt');
%nImages = length(patches);
nImages = 100;
emdDistsWithPenalty = zeros(1,nImages);
emdDistsWithPenSquared = zeros(1,nImages);
%alpha1 = 1e-4;
alpha1 = 1;
%alpha2 = 1e-8;
alpha2 = 1;
basePatchTotal = sum(sum(basePatch));
for i = 1:nImages
    
    sourceFile = strcat('emdResults/sourceFlow',num2str(i),'.txt');
    sinkFile = strcat('emdResults/sinkFlow',num2str(i),'.txt');
    sourceFlow = load(sourceFile);
    sinkFlow = load(sinkFile);
    totalFlow = min( sum(sourceFlow), sum(sinkFlow) );
    
    f = emdDists(i);
    curPatch = patches{i};
    curPatchTotal = sum(sum(curPatch));
    
    %approach where we add alpha(x - x^)
    f1 = f + (alpha1/totalFlow)*abs(curPatchTotal - basePatchTotal);
    
    %approach where ad add alpha*(x-x^)^2
    f2 = f + (alpha2/totalFlow)*(curPatchTotal - basePatchTotal)^2;

    emdDistsWithPenSquared(i) = f2;
    emdDistsWithPenalty(i) = f1;
end

[~,bestIndices] = sort(emdDists);
[~,bestIndicesPen] = sort(emdDistsWithPenalty);
[~,bestIndicesPenSqu] = sort(emdDistsWithPenSquared);

%%

%older one
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

%got good results with 20 by 20 patches from simulated data
save('goodEMDResults6.mat','indices',...
    'patches','basePatch','bestIndices','bestIndicesPen','bestIndicesPenSqu'...
    ,'emdDists','emdDistsWithPenalty','emdDistsWithPenSquared','-v7.3');

%%
load('goodEMDResults.mat');
%%
load('goodEMDResults5.mat');
%%

%numPatches = length(patches);
numPatches = numRows*numCol;

maxPixel = max(basePatch(:));

%{
maxPixel = 0;
for k = 1:length(patches)
   maxPixel = max( max(max(patches{k})) , maxPixel); 
end

maxPixel2 = 0;
for k = 1:numPatches
   maxPixel2 = max( max(max(patches{indices(k)})) , maxPixel2); 
end
%}
figure
colormap jet;
colorbar;
for k = 1:numPatches
   subplot(numRows,numCol,k);
   imagesc(patches{indices(k)}, [0 maxPixel])
   axis off
end

%{
maxPixel3 = 0;
for k = 1:numPatches
   maxPixel3 = max( max(max(patches{bestIndices(k)})) , maxPixel3); 
end
%}
figure
colormap jet;
colorbar;
for k = 1:numPatches
   subplot(numRows,numCol,k);
   imagesc(patches{bestIndices(k)}, [0 maxPixel])
   axis off
end

%{
maxPixel4 = 0;
for k = 1:numPatches
   maxPixel4 = max( max(max(patches{bestIndicesPen(k)})) , maxPixel4); 
end
%}
figure
colormap jet;
colorbar;
for k = 1:numPatches
   subplot(numRows,numCol,k);
   imagesc(patches{bestIndicesPen(k)}, [0 maxPixel])
   axis off
end

%{
maxPixel5 = 0;
for k = 1:numPatches
   maxPixel5 = max( max(max(patches{bestIndicesPenSqu(k)})) , maxPixel5); 
end
%}
figure
colormap jet;
colorbar;
for k = 1:numPatches
   subplot(numRows,numCol,k);
   imagesc(patches{bestIndicesPenSqu(k)}, [0 maxPixel])
   axis off
end