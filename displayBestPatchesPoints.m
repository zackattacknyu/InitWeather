function [] = displayBestPatchesPoints( patchesPoints,bestIndices,~,numRows,numCol )
%DISPLAYBESTPATCHES Summary of this function goes here
%   Detailed explanation goes here

numPatches = numRows*numCol;

figure
colormap jet;
colorbar;
for k = 1:numPatches
   subplot(numRows,numCol,k);
   pointsDisplay = patchesPoints{bestIndices(k)};
   plot(pointsDisplay(:,1),pointsDisplay(:,2),'b.');
   %axis off
end

end

