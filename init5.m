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

%obtains a very large sample of patches
nImgs = size(allImgs,1);
imgSize = [size(allImgs,2) size(allImgs,3)];
numPatchesPerImage = 40;
patchSize = 30;
maxAttempts = 50;
numTotalPatches = numPatchesPerImage*nImgs;
patchSum = zeros(1,numTotalPatches);
randPatches = zeros(numTotalPatches,patchSize,patchSize);
imgIndex = 1;

for j=1:nImgs
    
    curImage = reshape(allImgs(j,:,:),imgSize);
    
    for k = 1:numPatchesPerImage
        
       randStartInd = ceil(rand(1,2).*(imgSize - [patchSize patchSize]));
       randStartRow = randStartInd(1);
       randStartCol = randStartInd(2);
       randPatch = curImage(...
           randStartRow:(randStartRow+patchSize-1),...
           randStartCol:(randStartCol+patchSize-1));
       
       patchSum(imgIndex) = sum(randPatch(:));
       randPatches(imgIndex,:,:) = randPatch;
       imgIndex = imgIndex+1;
       
       if(mod(imgIndex,1000) == 0)
         imgIndex 
       end

    end
end

%%

nPatches = size(randPatches,1);
patchSum = zeros(1,nPatches);
for i=1:nPatches
    curPatch = randPatches(i,:,:);
    patchSum(i) = sum(curPatch(:));
end

%%

numBins = 30;
[N,data] = hist(patchSum,numBins);
semilogy(data,N);

%%

%tried fitting it to exponential
f = fit(data(4:30)',N(4:30)','exp1');
x = 0:2:max(data);
aVal = f.a; bVal = f.b;
y = aVal*exp(bVal.*x);
figure
semilogy(x,y);
hold on
semilogy(data,N);
legend('Best Fit Line','Original Data');
hold off
%plot(f,data,N)
%%

%gets the min/max patchSum
minSum = min(patchSum);
maxSum = max(patchSum);
%%

%does a test of the prob function
aVal = f.a; bVal=f.b;
totalProb = 0;
probs = zeros(1,maxSum);
otherFactor = 10*(exp(bVal*maxSum)-1)/bVal;
for i = 1:maxSum
    probs(i)=(bVal*otherFactor)/(exp(bVal*i)*(1-exp(-bVal*maxSum)));
end
%%
%obtains a very large sample of patches
minSum = min(patchSum);
maxSum = max(patchSum);
aVal = f.a; bVal=f.b;

nImgs = size(randPatches,1);
patchSize = 30;
numTotal = 2000;
newPatches = zeros(numTotal,patchSize,patchSize);

randomPicks = rand(1,nImgs);
imgIndex = 1;
probPicking = zeros(1,nImgs);
probabilityFactor = 2*(exp(bVal*maxSum)-1)/(1-exp(-bVal*maxSum));
for j=1:nImgs
    
    curImage = reshape(randPatches(j,:,:),[patchSize patchSize]);
    
    %tries using exponential for probability
    curSumImage = sum(curImage(:));
    probPicking(j) = probabilityFactor/(exp(bVal*curSumImage));
    
    %ensures it is picked with a certain probability
    if(randomPicks(j) < probPicking(j))
        newPatches(imgIndex,:,:) = randPatches(j,:,:);
        imgIndex = imgIndex + 1;
    end
    
    if(imgIndex > numTotal)
       break; 
    end

   if(mod(j,1000) == 0)
     imgIndex 
   end
end

newPatches = newPatches(1:(imgIndex-1),:,:);

%%

patchSize = 30;
numImages = size(newPatches,1);

numHoriz = 5;
numVert = 6;
imageNum = 1;

figure
for h = 1:numHoriz
    for v = 1:numVert
       
       curImageNum = floor(rand(1,1)*length(numImages))+1;
       imgToShow = reshape(newPatches(curImageNum,:,:),[patchSize patchSize]); 
       subplot(numHoriz,numVert,imageNum);
       imageNum = imageNum + 1;
       imagesc(imgToShow,[0 8000]);
       colormap jet;
       axis image;
       
    end
end






