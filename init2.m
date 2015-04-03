trnImgDir = 'train/';
imgIds = getImgIds(trnImgDir);

% select training window

imgIds = imgIds(1:end);
nImgs = length(imgIds);
    
%%

imgId = imgIds{1};   
ST4 = load([trnImgDir 'ST4/' imgId(1:end-2) '.mat']);
gt1 = ST4.I;

%%
allImgs = zeros([nImgs size(gt1)]);

%%

for i = 1:nImgs
%for i = 1:3
    
    % Get image id: YYMMDDHHmm
    imgId = imgIds{i};
    
    ST4 = load([trnImgDir 'ST4/' imgId(1:end-2) '.mat']);
    gt = ST4.I;
    
    allImgs(i,:,:) = gt;
    
    if(mod(i,10)==0)
       i 
    end
    
  
    
end

%%

save('allGTimages.mat','allImgs','-v7.3');

%%

randImgIds = randperm(nImgs);
numPatches = 100;
patchSize = 21;
randPatches = zeros(numPatches,patchSize,patchSize);

for j=1:numPatches
   randStartInd = ceil(rand(1,2).*(size(gt1) - [patchSize patchSize]));
   randStartRow = randStartInd(1);
   randStartCol = randStartInd(2);
   
   curImage = reshape(allImgs(randImgIds(j),:,:),size(gt1));
   randPatch = curImage(...
       randStartRow:(randStartRow+patchSize-1),...
       randStartCol:(randStartCol+patchSize-1));
   
   randPatches(j,:,:) = randPatch;
end

%%
numImages = size(randPatches,1);
randImgNum = ceil(rand(1,1)*numImages);
baseImage = reshape(randPatches(randImgNum,:,:),[patchSize patchSize]);

[sortedImgs,~,~] = makeSortedImages(baseImage,randPatches);

figure
subplot(4,4,1);
imagesc(baseImage);
for i = 1:15
   imgToShow = reshape(sortedImgs(i,:,:),[patchSize patchSize]); 
   subplot(4,4,i+1);
   imagesc(imgToShow);
end


