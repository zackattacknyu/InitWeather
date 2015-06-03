function [ outPatch ] = halfPatch( inputPatch )
%HALFPATCH Summary of this function goes here
%   Detailed explanation goes here

outPatch = zeros(size(inputPatch)./2);

for i = 1:size(outPatch,1)
   for j = 1:size(outPatch,2)
       indexRow = 2*(i-1) + 1;
       indexCol = 2*(j-1) + 1;
       patchToAvg = inputPatch(indexRow:indexRow+1,indexCol:indexCol+1);
       outPatch(i,j) = mean(patchToAvg(:));
   end
end


end

