function [ outPatch ] = fractionPatch( inputPatch,denom )
%HALFPATCH Summary of this function goes here
%   inputPatch - patch to resize
%   denom - will be resized by 1/denom

outPatch = zeros(size(inputPatch)./denom);

for i = 1:size(outPatch,1)
   for j = 1:size(outPatch,2)
       indexRow = denom*(i-1) + 1;
       indexCol = denom*(j-1) + 1;
       patchToAvg = inputPatch(indexRow:indexRow+1,indexCol:indexCol+1);
       outPatch(i,j) = mean(patchToAvg(:));
   end
end


end

