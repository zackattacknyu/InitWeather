patchSize = 15;
patch1 = zeros(patchSize,patchSize);

center = size(patch1)./2;
radius = 5;
for i = 1:patchSize
   for j = 1:patchSize
       dist = norm([i j] - center);
      if( dist < radius)
         patch1(i,j) = dist/radius; 
      end
   end
end

imagesc(patch1);
colormap bone;
colorbar;