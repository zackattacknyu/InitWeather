patchSize = 500;
numPatches = 6;
patches = cell(1,numPatches);
patch1 = zeros(patchSize,patchSize);
patch2 = zeros(patchSize,patchSize);

center = floor([patchSize/2 patchSize/2]);
centerVariation = 50;
centerVariants = floor(centerVariation*rand(numPatches,2));
centers = repmat(center,numPatches,1) + centerVariants;
centers(1,:) = center;
centerVariants(1,:) = [0 0];
radius = 100;

for k = 1:numPatches
   newPatch = zeros(patchSize,patchSize);
   for i = 1:patchSize
       for j = 1:patchSize
           dist = norm([i j] - centers(k,:));
          if( dist < radius)
             newPatch(i,j) = dist/radius;
          end
       end
   end
    patches{k} = newPatch;
end

figure
colormap bone;
colorbar;
for k = 1:numPatches
   subplot(2,3,k);
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

figure
colormap bone;
colorbar;
for k = 1:numPatches
   subplot(2,3,k);
   imagesc(patches{indices(k)})
end

%%
distsFromCenter = sqrt(centerVariants(:,1).^2 + centerVariants(:,2).^2);
