function [ patchesInOrder ] = displayBestPatchesInStack( patches,bestIndices,maxPixel )
%DISPLAYBESTPATCHESINSTACK Summary of this function goes here
%   Detailed explanation goes here

%display patches in 3D stack
patchesInOrder = zeros([size(patches{1}) length(bestIndices)]);
for k = 1:length(bestIndices)
   patchesInOrder(:,:,k) = patches{bestIndices(k)}; 
end
fig1 = figure;
imtool3D(patchesInOrder,[0 0 1 1],fig1,[0 maxPixel]);

end

