function [ weight, feature ] = getFeatureWeight( patch )
%GETFEATUREWEIGHT Summary of this function goes here
%   Detailed explanation goes here

[numRows, numCol] = size(patch);
weightT = patch';
weight = weightT(:);
feature = ones(size(weight,1),2);
index = 1;
for i = 1:numRows
   for j = 1:numCol
      feature(index,:) = [i j];
      index = index + 1;
   end
end

end

