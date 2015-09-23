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

for i = 1:numTestPatches
    curPatch = floor(rand(numRC,numRC)*var) + minVal;
    testPatches{i} =  curPatch;
    patches(:,:,i) = curPatch;
end
initBasePatch = mean(patches,3);
%initBasePatch = geomean(patches,3);

diffFromMean = zeros(numRC,numRC);
totalEMD = zeros(1,numT);

diffsFromMean = cell(1,numT);

meanRange = 20;

for i = 1:numT
    
    diffsFromMean{i} = diffFromMean;
    
    curBase = initBasePatch+diffFromMean;
    
    emdCur = 0;
    
    for j = 1:numTestPatches
       curPatch = testPatches{j}; 
        [~,rawF,~,~,totalFlow] = ...
            getQuadProgResult(curBase,curPatch,alphaVal);
        emdCur = emdCur + rawF/totalFlow;
    end
    
    totalEMD(i) = emdCur;
    
    diffFromMean = abs(floor(rand(numRC,numRC)*meanRange - meanRange/2));
end