load('rejectionSamplingPatches.mat');

%%

patchSize = 30;

%obtain earth-mover distance

%{
Image 360 and 342 gave us EMD of 3.8089
Image 361 and 342 gave us EMD of 3.5532

Image 991 and 998 give us 3.3001 and those seem like good ones 
    to compare

Image 990 and 502 gives us EMD of 3.2038
Image 990 seems like 991 and 998

image 992 and 993 seem like good ones
%}
imgNums = floor(rand(1,2)*size(newPatches,1) + 1);
img1Num = imgNums(1); img2Num = imgNums(2);
%%
img1Num = 991;
img2Num = 998;
patch1 = reshape(newPatches(img1Num,:,:),[patchSize patchSize]);
patch2 = reshape(newPatches(img2Num,:,:),[patchSize patchSize]);

patch1Resized = imresize(patch1,0.5);
patch2Resized = imresize(patch2,0.5);
patch1Resized2 = imresize(patch1,0.1);
patch2Resized2 = imresize(patch2,0.1);

figure
subplot(3,2,1)
imagesc(patch1)
axis image
subplot(3,2,2)
imagesc(patch2)
axis image
subplot(3,2,3)
imagesc(patch1Resized)
axis image
subplot(3,2,4)
imagesc(patch2Resized)
axis image
subplot(3,2,5)
imagesc(patch1Resized2)
axis image
subplot(3,2,6)
imagesc(patch2Resized2)
axis image

%%
[weight1, pixelLocs1] = getFeatureWeight(patch1Resized2);
[weight2, pixelLocs2] = getFeatureWeight(patch2Resized2);

[x,f] = emd(pixelLocs1,pixelLocs2,weight1,weight2,@getPixelDist);






