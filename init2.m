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
numPatches = 300;
patchSize = 30;
maxAttempts = 50;
randPatches = zeros(numPatches,patchSize,patchSize);
imgIndex = 1;

%the min that the sum of the patch must be to use the patch
%   this helps ensure there is a discrenable structure in the patch
patchSumThreshold = 300000;

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
              
              if(mod(imgIndex,20) == 0)
                 imgIndex 
              end
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
    
    if(mod(j,20) == 0)
       j 
    end
    
    
end

%%
save('goodPatches4.mat','randPatches');

%%
load('goodPatches1.mat');
goodPatches1 = randPatches;
load('goodPatches2.mat');
goodPatches2 = randPatches;
load('goodPatches3.mat');
goodPatches3 = randPatches;
randPatches = cat(1,goodPatches1,goodPatches2,goodPatches3);

%%
save('goodPatches.mat','randPatches');

%%
load('goodPatches.mat');
%%

patchSize = 30;
numImages = size(randPatches,1);

%randImgNum = ceil(rand(1,1)*numImages);
%image 142 in good patches produced some good results
%   also image 196 is good
%randImgNum = 142;
randImgNum = 196;
%randImgNum = 396;

baseImage = reshape(randPatches(randImgNum,:,:),[patchSize patchSize]);

%{
figure
imagesc(baseImage);
colormap jet;
colorbar;
%}

numMethods = 6;
numPlots = 8;

figure
for method = 1:numMethods
    [sortedImgs,~,~] = makeSortedImages(baseImage,randPatches,method);
    for i = 1:numPlots
       imgToShow = reshape(sortedImgs(i,:,:),[patchSize patchSize]); 
       subplot(numMethods,numPlots,(method-1)*numPlots + i);
       imagesc(imgToShow);
       colormap jet;
       axis image;
    end
end






