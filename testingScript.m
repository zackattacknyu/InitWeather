%basePatchNum = floor(rand(1,1)*length(patches)) + 1;
basePatchNum=432;
basePatch = patches{basePatchNum};

%figure
%imagesc(basePatch);

basePatch = floor(abs(basePatch));

numPatches = length(patches);

%EMD calculated with x values from quadratic programming
emdDistsQP = zeros(1,numPatches);

%EMD with squared error calculated with x values from quadratic programming
emdDistsQPQuad = zeros(1,numPatches);

%EMD calculated with x values from min cost max flow algorithm
emdDistsGraph = zeros(1,numPatches);

%EMD with squared error calculated with x vals from min cost max flow
emdDistsGraphQuad = zeros(1,numPatches);

%squared error term after doing quad programming
quadErrorsQP = zeros(1,numPatches);

%squared error term after doing min cost max flow
quadErrorsGraph = zeros(1,numPatches);

%constant squared error from target and prediction patches
quadErrorsConst = zeros(1,numPatches);

%value in front of sqared error term
alphaVal = 0.1;

for i = 1:numPatches
    
    i
    curPatch = patches{i};
    curPatch = floor(abs(curPatch));
    
    quadErrorsConst(i) = (sum(basePatch(:)) - sum(curPatch(:)))^2;
    
    %THIS IS SOLID
    [flowMatrix,emdGraph,quadError,totalFlow] = getGraphAlgResult(basePatch,curPatch);
    emdDistsGraph(i) = emdGraph;
    quadErrorsGraph(i) = alphaVal*quadError;
    emdDistsGraphQuad(i) = emdGraph + alphaVal*(quadError/totalFlow);
    
    %THIS IS SOLID
    [quadX,rawF,rawEmdDist,rawQuadError,totalFlow] = getQuadProgResult(basePatch,curPatch,alphaVal);
    emdDistsQP(i) = rawEmdDist/totalFlow;
    emdDistsQPQuad(i) = rawF/totalFlow;
    quadErrorsQP(i) = rawQuadError; %NOTE: alpha is accounted for
end

[vals,inds] = sort(quadErrorsConst);

figure
semilogy(quadErrorsConst(inds));
hold on
semilogy(quadErrorsGraph(inds));
semilogy(quadErrorsQP(inds));
legend('r0','r1(f1star)','r1(f2star)')
xlabel('Patch Number sorted by r0');
ylabel('Value');

figure
semilogy(quadErrorsConst(inds));
hold on
semilogy(emdDistsGraphQuad(inds));
semilogy(emdDistsQPQuad(inds));
legend('r0','h2(f1star)','h2(f2star)','Location','SouthEast')
xlabel('Patch Number sorted by r0');
ylabel('Value');

[vals,inds2] = sort(emdDistsGraph);
figure
semilogy(emdDistsGraph(inds2))
hold on
semilogy(emdDistsGraphQuad(inds2))
legend('h1(f1star)','h2(f1star)')
xlabel('Patch Number sorted by h1(f1star)');


numRows = 6;
numCol = 8;
maxPixel = max(basePatch(:));

[~,bestIndicesGraph] = sort(emdDistsGraphQuad);
[~,bestIndicesQP] = sort(emdDistsQPQuad);

displayBestPatches( patches,bestIndicesGraph,maxPixel,numRows,numCol );
displayBestPatches( patches,bestIndicesQP,maxPixel,numRows,numCol );

%%
displayBestPatchesInStack(patches,bestIndicesGraph,maxPixel);
displayBestPatchesInStack(patches,bestIndicesQP,maxPixel);