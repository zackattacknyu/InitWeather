function [] = displayBestPatches( patches,bestIndices,maxPixel,numRows,numCol )
%DISPLAYBESTPATCHES Summary of this function goes here
%   Detailed explanation goes here

numPatches = numRows*numCol;

figure
colormap jet;
colorbar;
for k = 1:numPatches
   subplot(numRows,numCol,k);
   imagesc(patches{bestIndices(k)}, [0 maxPixel])
   axis off
end

end

