function [ image1Zoom ] = magnifyImage( image1,magFactor )
%MAGNIFYIMAGE Summary of this function goes here
%   Detailed explanation goes here

image1Zoom = zeros(size(image1).*magFactor);
for i = 1:size(image1,1)
   for j = 1:size(image1,2)
       startRow = (i-1)*magFactor + 1;
       endRow = i*magFactor;
       startCol = (j-1)*magFactor + 1;
       endCol = j*magFactor;
       image1Zoom(startRow:endRow,startCol:endCol) = ones(magFactor,magFactor).*image1(i,j);
   end
end

end

