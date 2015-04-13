function [ error ] = yesNoWeightedErrorImage( baseImage,compareImage,minThreshold )
%MSEIMAGE Summary of this function goes here
%   Detailed explanation goes here

baseImageBinned = baseImage>minThreshold;
compareImageBinned = compareImage>minThreshold;

weightForFalseNeg = 10;
weightForFalsePos = 1;
error = 0;

for i = 1:size(baseImage,1)
   for j = 1:size(baseImage,2)
      if(baseImageBinned(i,j) == 0 && compareImageBinned(i,j) == 1)
            error = error + weightForFalseNeg;
      end
      if(baseImageBinned(i,j) == 1 && compareImageBinned(i,j) == 0)
            error = error + weightForFalsePos;
      end
   end
end

end

