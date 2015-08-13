%{
numPoints = [10 20 100 100 200];
for i = 1:5
    data = rand(numPoints(i),2);
    [bandwidth,density,X,Y] = kde2d(data,16);

    figure
    imagesc(density);
    colorbar;
end
%}

numPatches = 500;
patches = cell(1,numPatches);
patchesData = cell(1,numPatches);
patchesNumPoints = zeros(1,numPatches);
multiplier = 10e6;
for i = 1:numPatches
    numPoints = floor(rand(1,1)*i + 10);
    data = rand(numPoints,2);
    [bandwidth,density,X,Y] = kde2d(data,16);
    
    patchesNumPoints(i) = numPoints;
    patchesData{i} = data;
    patches{i} = density.*multiplier;
    i
end

patchesPointCloudDist = zeros(length(patchNums),numPatches);
for i = 1:length(patchNums)
   for j = 1:numPatches
       ii = patchNums(i);
       patchesPointCloudDist(i,j) = getPointCloudDistance(patchesData{ii},patchesData{j});
   end
   i
end

testingMultipleScript