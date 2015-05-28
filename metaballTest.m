patch = zeros(50,50);
points = [20 30; 20 40; 30 20];
for i = 1:size(patch,1)
   for j = 1:size(patch,2)
      curPoint = repmat([i j],3,1); 
      diff = (curPoint-points).^2;
      dists = sum(diff,2);
      patch(i,j) =  min(sum(1./(dists.^(0.7))),1.0);
   end
end
imagesc(patch);
colormap jet;