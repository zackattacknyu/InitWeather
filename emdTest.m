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

Image 994 and 995 got an optimal. It terminated. 
%}
imgNums = floor(rand(1,2)*size(newPatches,1) + 1);
img1Num = imgNums(1); img2Num = imgNums(2);
%%
resizeFactor = 0.2;

baseImageNum = 995;
basePatch = reshape(newPatches(baseImageNum,:,:),[patchSize patchSize]);
basePatchResized = imresize(basePatch,resizeFactor);
[baseWeight,basePixelLocs] = getFeatureWeight(basePatchResized);

imageNums = [342 502 991 992 993 994 995 998];
nImages = length(imageNums);
patches = cell(1,nImages);
patchesResized = cell(1,nImages);
emdDists = zeros(1,nImages);
curMaxPixel = 0;
for i = 1:nImages
    curPatch = reshape(newPatches(imageNums(i),:,:),[patchSize patchSize]);
    patches{i} = curPatch;
    curMaxPixel = max(max(max(curPatch)),curMaxPixel);
    curPatchResized = imresize(curPatch,resizeFactor);
    patchesResized{i} = curPatchResized;
    [weight,pixelLocs] = getFeatureWeight(curPatchResized);
    [~,f] = emd(pixelLocs,basePixelLocs,weight,baseWeight,@getPixelDist);
    emdDists(i) = f;
end

[~,bestIndices] = sort(emdDists);
%{
patch1Resized = imresize(patch1,0.5);
patch2Resized = imresize(patch2,0.5);
patch1Resized2 = imresize(patch1,0.1);
patch2Resized2 = imresize(patch2,0.1);
%}

figure
for j=1:nImages
   subplot(2,nImages,j);
   imagesc(patches{bestIndices(j)},[0 curMaxPixel]);
   axis image
end
for j=1:nImages
   subplot(2,nImages,nImages + j);
   imagesc(patchesResized{bestIndices(j)},[0 curMaxPixel]);
   axis image
end

%%
[weight1, pixelLocs1] = getFeatureWeight(patch1Resized2);
[weight2, pixelLocs2] = getFeatureWeight(patch2Resized2);

[x,f] = emd(pixelLocs1,pixelLocs2,weight1,weight2,@getPixelDist);
%%

%Will frame this as assignment problem
patchSize=30;
thresholdFactor=100;
baseImageNum = 995;
otherImageNum = 992;
basePatch = reshape(newPatches(baseImageNum,:,:),[patchSize patchSize]);
basePatchResized = imresize(basePatch, [10 10]);
basePatchbinarized = basePatchResized>thresholdFactor;
[baseWeight,basePixelLocs] = getFeatureWeight(basePatchbinarized);

%imageNums = [342 502 991 992 993 994 995 998];
curPatch = reshape(newPatches(otherImageNum,:,:),[patchSize patchSize]);
curPatchResize = imresize(curPatch, [10 10]);
curPatchbinarized = curPatchResize>thresholdFactor;
[weight,pixelLocs] = getFeatureWeight(curPatchbinarized);

distMatrix = gdm(basePixelLocs,pixelLocs,@getPixelDist);
distMatrix = reshape(distMatrix,[100 100]);
binMatrix = zeros(length(baseWeight),length(weight));
for i = 1:length(baseWeight)
   for j = 1:length(weight)
      if(baseWeight(i)~=weight(j))
         binMatrix(i,j) = 1; 
      end
   end
end
costMatrix = distMatrix.*binMatrix;

[Matching,Cost] = Hungarian(costMatrix);

%{
figure
subplot(1,2,1);
imagesc(basePatchbinarized);
subplot(1,2,2);
imagesc(curPatchbinarized);
%}
%%
[~,f] = emd(pixelLocs,basePixelLocs,weight,baseWeight,@getPixelDist);
emdDists(i) = f;

[~,bestIndices] = sort(emdDists);
%{
patch1Resized = imresize(patch1,0.5);
patch2Resized = imresize(patch2,0.5);
patch1Resized2 = imresize(patch1,0.1);
patch2Resized2 = imresize(patch2,0.1);
%}

figure
for j=1:nImages
   subplot(2,nImages,j);
   imagesc(patches{bestIndices(j)},[0 curMaxPixel]);
   axis image
end
for j=1:nImages
   subplot(2,nImages,nImages + j);
   imagesc(patchesbinarized{bestIndices(j)},[0 1]);
   axis image
end


%%

patchSize=30;
thresholdFactor=100;
baseImageNum = 995;
basePatch = reshape(newPatches(baseImageNum,:,:),[patchSize patchSize]);
basePatchResized = imresize(basePatch, [10 10]);
basePatchbinarized = basePatchResized>thresholdFactor;
[baseWeight,basePixelLocs] = getFeatureWeight(basePatchbinarized);

imageNums = [342 502 991 992 993 994 995 998];
nImages = length(imageNums);
patches = cell(1,nImages);
patchesbinarized = cell(1,nImages);
emdDists = zeros(1,nImages);
curMaxPixel = 0;
for i = 1:nImages
    curPatch = reshape(newPatches(imageNums(i),:,:),[patchSize patchSize]);
    patches{i} = curPatch;
    curMaxPixel = max(max(max(curPatch)),curMaxPixel);
    curPatchResize = imresize(curPatch, [10 10]);
    curPatchbinarized = curPatchResize>thresholdFactor;
    patchesbinarized{i} = curPatchbinarized;
    [weight,pixelLocs] = getFeatureWeight(curPatchbinarized);
    [~,f] = emd(pixelLocs,basePixelLocs,weight,baseWeight,@getPixelDist);
    emdDists(i) = f;
end

[~,bestIndices] = sort(emdDists);
%{
patch1Resized = imresize(patch1,0.5);
patch2Resized = imresize(patch2,0.5);
patch1Resized2 = imresize(patch1,0.1);
patch2Resized2 = imresize(patch2,0.1);
%}

figure
for j=1:nImages
   subplot(2,nImages,j);
   imagesc(patches{bestIndices(j)},[0 curMaxPixel]);
   axis image
end
for j=1:nImages
   subplot(2,nImages,nImages + j);
   imagesc(patchesbinarized{bestIndices(j)},[0 1]);
   axis image
end




