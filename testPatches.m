patchSize = 20;
numRows = 3;
numCol = 4;
numPatches = numRows*numCol;
maxRadius = 7;
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
           newPatch(i,j) = dist/curRadius;
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

numPatches = 12;
for k = 1:numPatches
   sum(sum(patches{k})) 
end