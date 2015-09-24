%%


%testing the mean idea
var=60;
minVal = 100;
numT=500;
numRC = 2;
alphaVal=0.1;
numTestPatches = 3;

testPatches = cell(1,numTestPatches);
patches = zeros(numRC,numRC,numTestPatches);

indices = randperm(length(testPatchesAll));

for i = 1:numTestPatches
    %curPatch = floor(rand(numRC,numRC)*var) + minVal;
    curPatch = imresize(testPatchesAll{indices(i)},[numRC numRC]);
    testPatches{i} =  curPatch;
    patches(:,:,i) = curPatch;
end
initBasePatch = mean(patches,3);
%initBasePatch = geomean(patches,3);

diffFromMean = zeros(numRC,numRC);
totalEMD = zeros(1,numT);

diffsFromMean = cell(1,numT);

meanRange = 16;

vals = (-meanRange/2):meanRange/2;

[xx,yy,zz] = meshgrid(vals,vals,vals);
slot1 = xx(:);
slot2 = yy(:);
slot3 = zz(:);

for i = 1:size(slot1)
    
    diffsFromMean{i} = diffFromMean;
    
    curBase = abs(initBasePatch+diffFromMean);
    
    emdCur = 0;
    
    for j = 1:numTestPatches
       curPatch = abs(testPatches{j}); 
        [~,rawF,~,~,totalFlow] = ...
            getQuadProgResult(curBase,curPatch,alphaVal);
        emdCur = emdCur + rawF/totalFlow;
    end
    
    totalEMD(i) = emdCur;
    
    diffFromMean = [slot1(i) slot2(i);slot3(i) 0];
    
    %diffFromMean = abs(floor(rand(numRC,numRC)*meanRange - meanRange/2));
end