javaaddpath('java/GeneratePatches/build/classes')
%%
intsArray = javaArray('java.lang.Integer',3);
intsArray(1) = java.lang.Integer(8);
intsArray(2) = java.lang.Integer(6);
intsArray(3) = java.lang.Integer(4);

numPassesArray = javaArray('java.lang.Integer',3);
numPassesArray(1) = java.lang.Integer(3);
numPassesArray(2) = java.lang.Integer(3);
numPassesArray(3) = java.lang.Integer(2);

size = java.lang.Integer(20);
centerVariance = java.lang.Integer(5);

%%
numHoriz = 10;
numVert = 6;
total = numHoriz*numVert;
arrays = cell(1,total);
for i = 1:length(arrays)
   arrays{i} = javaMethod('generatePatch','generatepatches.GeneratePatches'...
    ,size,centerVariance,intsArray,numPassesArray);
end

figure
for i = 1:length(arrays)
   imgToShow = arrays{i};
   subplot(numVert,numHoriz,i);
   imagesc(imgToShow);
   colormap jet;
   axis image;
   axis off;
end