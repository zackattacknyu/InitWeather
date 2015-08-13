function [ weight, feature ] = getFeatureWeight( patch )
%GETFEATUREWEIGHT Summary of this function goes here
%   Detailed explanation goes here

[numRows, numCol, numSlices] = size(patch);
numEntries = numel(patch);
feature = ones(numEntries,3);
weight = zeros(numEntries,1);
index = 1;
for i = 1:numRows
   for j = 1:numCol
       for k =1:numSlices
           weight(index) = patch(i,j,k);
          feature(index,:) = [i j k];
          index = index + 1;
       end
   end
end

end

