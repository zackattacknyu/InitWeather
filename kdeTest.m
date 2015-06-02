x = rand(2,8); w = ones(1,8); sig = rand(1,8)*.05+.05;
p = kde(x,sig,w);
imagesc(hist(p,200,[1 2],[0 1; 0 1]))