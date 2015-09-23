%%


%testing the mean idea
var=200;
numT=150;
numRC = 4;

curPatch1 = floor(rand(numRC,numRC)*var) + 1;
curPatch2 = floor(rand(numRC,numRC)*var) + 1;

patches = zeros(numRC,numRC,2);
patches(:,:,1) = curPatch1;
patches(:,:,2) = curPatch2;
initBasePatch = mean(patches,3);



diffFromMean = zeros(numRC,numRC);
totalEMD = zeros(1,numT);

meanRange = 200;

for i = 1:numT
    
    curBase = initBasePatch+diffFromMean;
    
    [~,rawF,~,~,totalFlow] = ...
        getQuadProgResult(curBase,curPatch1,alphaVal);
    emd1 = rawF/totalFlow;
    
    [quadX,rawF,rawEmdDist,rawQuadError,totalFlow] = ...
        getQuadProgResult(curBase,curPatch2,alphaVal);
    emd2 = rawF/totalFlow;
    
    totalEMD(i) = emd1+emd2;
    
    diffFromMean = abs(floor(rand(numRC,numRC)*meanRange - meanRange/2));
end