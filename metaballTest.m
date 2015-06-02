%patch = zeros(50,50);
patch = zeros(20,20);
points = [5 5;15 10];
pointFactors = [.8; .2];
pNorm = 2;
for i = 1:size(patch,1)
   for j = 1:size(patch,2)
      curPoint = repmat([i j],2,1); 
      diff = abs(curPoint-points).^pNorm;
      dists = sum(diff,2);
      patch(i,j) =  min(sum(pointFactors./(dists.^(1/pNorm))),.8);
      if(patch(i,j) < 0.15)
         patch(i,j) = 0; 
      end
   end
end
imagesc(patch);
colormap jet;
colorbar;