javaaddpath('java/GeneratePatches/build/classes')
%%
ints = [6 5 4 3 2 1];
numPasses = [2 2 1 1 1 1];
%ints = [8 6];
%numPasses = [2 2];
intsArray = javaArray('java.lang.Integer',length(ints));
numPassesArray = javaArray('java.lang.Integer',length(numPasses));
for i = 1:length(ints)
    intsArray(i) = java.lang.Integer(ints(i));
    numPassesArray(i) = java.lang.Integer(numPasses(i));
end

size = java.lang.Integer(20);
centerVariance = java.lang.Integer(5);

%%
numHoriz = 10;
numVert = 6;
numDispTotal = numHoriz*numVert;
numPatchesTotal = 700;
patches = cell(1,numPatchesTotal);
for i = 1:length(patches)
   patches{i} = javaMethod('generatePatch','generatepatches.GeneratePatches'...
    ,size,centerVariance,intsArray,numPassesArray);
end

indices = randperm(numPatchesTotal);
figure
for i = 1:numDispTotal
   imgToShow = patches{indices(i)};
   subplot(numVert,numHoriz,i);
   imagesc(imgToShow);
   colormap jet;
   axis image;
   axis off;
end