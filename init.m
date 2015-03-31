
%%
%run this when loading on a new computer

X1te = load('kaggle/kaggle.X1.test.txt');
X1tr = load('kaggle/kaggle.X1.train.txt');
X2te = load('kaggle/kaggle.X2.test.txt');
X2tr = load('kaggle/kaggle.X2.train.txt');
Ytr = load('kaggle/kaggle.Y.train.txt');
save('kaggleData.mat','X1te','Ytr','X1tr','X2tr','X2te');

%%
%run this if above was already run on this computer
load('kaggleData.mat');

%%

%generates random images
%{
numCompareImages = 30000;
numImages = size(X2tr,1);
imgNums = randperm(numImages);
imageNumsToCompare = imgNums(1:numCompareImages);
randImgNum = imgNums(numCompareImages+1);
baseImage = reshape(X2tr(randImgNum,:),[21 21]);
imgsToCompare = reshape(X2tr(imageNumsToCompare,:),[numCompareImages 21 21]);
%}

%use random image for base and all images for ones to compare
numImages = size(X2tr,1);
randImgNum = ceil(rand(1,1)*numImages);
baseImage = reshape(X2tr(randImgNum,:),[21 21]);
imgsToCompare = reshape(X2tr,[numImages 21 21]);

%%

[sortedImgs,~,~] = makeSortedImages(baseImage,imgsToCompare);

figure
subplot(4,4,1);
imagesc(baseImage);
for i = 1:15
   imgToShow = reshape(sortedImgs(i,:,:),[height width]); 
   subplot(4,4,i+1);
   imagesc(imgToShow);
end