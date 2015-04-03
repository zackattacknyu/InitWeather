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
load('allGTimages.mat');

%%

nImgs = size(allImgs,1);
imgSize = [size(allImgs,2) size(allImgs,3)];
randImgIds = randperm(nImgs);
numPatches = 200;
patchSize = 30;
maxAttempts = 50;
randPatches = zeros(numPatches,patchSize,patchSize);
imgIndex = 1;

%the min that the sum of the patch must be to use the patch
%   this helps ensure there is a discrenable structure in the patch
patchSumThreshold = 100000;

for j=1:nImgs
    
    curImage = reshape(allImgs(randImgIds(j),:,:),imgSize);
    
    %makes sure threshold is met for 
    %   whole image before trying to select a patch
    if(sum(curImage(:)) > patchSumThreshold)
        done = false;
        attemptNo = 0;
        while(~done)
            attemptNo = attemptNo + 1;
            randStartInd = ceil(rand(1,2).*(imgSize - [patchSize patchSize]));
           randStartRow = randStartInd(1);
           randStartCol = randStartInd(2);
           randPatch = curImage(...
               randStartRow:(randStartRow+patchSize-1),...
               randStartCol:(randStartCol+patchSize-1));

           %makes sure threshold is met
           if(sum(randPatch(:)) > patchSumThreshold)
              done = true;
              randPatches(imgIndex,:,:) = randPatch;
              imgIndex = imgIndex + 1;
           end
           
           %give up on this patch if too many attempts
           if(attemptNo > maxAttempts)
              done = true; 
           end
        end


       
    end
    
    if(imgIndex > numPatches)
       break; 
    end
    
end

%%
numImages = size(randPatches,1);
randImgNum = ceil(rand(1,1)*numImages);
baseImage = reshape(randPatches(randImgNum,:,:),[patchSize patchSize]);

[sortedImgs,~,~] = makeSortedImages(baseImage,randPatches);

figure
subplot(4,4,1);
imagesc(baseImage);
axis image;
for i = 1:15
   imgToShow = reshape(sortedImgs(i,:,:),[patchSize patchSize]); 
   subplot(4,4,i+1);
   imagesc(imgToShow);
   axis image;
end


