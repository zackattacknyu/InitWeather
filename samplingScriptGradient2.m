
figure
imagesc(img1); colorbar;

[Gmag,Gdir] = imgradient(img1);
%%
inds = (Gmag<100)&(img1>100);
randGoods = find(inds);
%%
[I,J] = ind2sub(size(img1),randGoods);
%%
figure
plot(J,I,'rx');
hold on
image(img1);
hold off