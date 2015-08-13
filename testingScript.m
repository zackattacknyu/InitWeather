basePatchNum = floor(rand(1,1)*length(patches)) + 1;

%Numbers with second patch set
%basePatchNum=280; %low patch, total = 2997
%basePatchNum=422; %high patch, total = 169640
%basePatchNum=579; %medium patch, total = 54954

%Numbers with first centroid patch set
%basePatchNum=106; %scatterd patch, total = 4160
%basePatchNum=500; %medium patch, total = 8982
%basePatchNum = 432; %high patch, total=43156
%basePatchNum = 607; %high patch 2, total = 47825
%basePatchNum = 601; %highest patch, total=230520
%basePatchNum = 124; %low patch, total = 1314
%basePatchNum = 59; %lowest patch, total = 1008
basePatch = patches{basePatchNum};
sum(basePatch(:))
imagesc(basePatch);
%%

minPrecip = 100000;
maxInd = 1;
numPatches = length(patches);
for k =1:numPatches
    curPatch = patches{k};
    currentSum = sum(curPatch(:));
    if(currentSum < minPrecip)
       minPrecip = currentSum;
       maxInd = k;
    end
end

%%
figure
imagesc(basePatch);
%%
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

qpCalcTime = cell(1,numPatches);

%value in front of sqared error term
alphaVal = 0.03;

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
    startTime = datetime('now');
    [quadX,rawF,rawEmdDist,rawQuadError,totalFlow] = getQuadProgResult(basePatch,curPatch,alphaVal);
    endTime = datetime('now');
    calcTime = endTime-startTime;
    calcTime
    qpCalcTime{i} = calcTime;
    emdDistsQP(i) = rawEmdDist/totalFlow;
    emdDistsQPQuad(i) = rawF/totalFlow;
    quadErrorsQP(i) = rawQuadError; %NOTE: alpha is accounted for
end
%%
%[vals,inds] = sort(quadErrorsConst);
%[vals,inds] = sort(quadErrorsGraph);
%[vals,inds] = sort(emdDistsGraphQuad);
[vals,inds] = sort(emdDistsQPQuad);
%[vals,inds] = sort(emdDistsGraphH3);

%%
figure
%semilogy(quadErrorsConst(inds(2:end)));
hold on
plot(quadErrorsGraph(inds(1:500)));
plot(quadErrorsQP(inds(1:500)));
legend('r1(f1star)','r1(f2star)')
%legend('r0','r1(f1star)','r1(f2star)')
xlabel('Patch Number sorted by r0');
ylabel('Value');
%%
figure
%semilogy(quadErrorsConst(inds));
hold on
%semilogy(quadErrorsGraph(inds(1:500)));
%semilogy(quadErrorsQP(inds(1:500)));
plot(emdDistsGraphQuad(inds(1:50)));
plot(emdDistsQPQuad(inds(1:50)));
legend('h2(f1star)','h2(f2star)','Location','SouthEast')
%legend('r0','h2(f1star)','h2(f2star)','Location','SouthEast')
%legend('r1(f1star)','r1(f2star)','h2(f1star)','h2(f2star)','Location','SouthEast')
xlabel('Patch Number sorted by h2(f2star)');
ylabel('Value');
%%
figure
%semilogy(quadErrorsConst(inds));
hold on
%semilogy(emdDistsQPH3(inds));
semilogy(emdDistsGraphH3(inds));
%semilogy(emdDistsQPQuad(inds));
semilogy(emdDistsGraphQuad(inds));
%legend('r0','h2(f1star)','h2(f2star)','Location','SouthEast')
legend('h3(f1star)','h2(f1star)','Location','SouthEast')
xlabel('Patch Number sorted by h2(f1star)');
ylabel('Value');
%%
figure
%semilogy(quadErrorsConst(inds));
hold on
semilogy(emdDistsGraphH3(inds(1:50)));
semilogy(emdDistsQPQuad(inds(1:50)));
%legend('r0','h2(f1star)','h2(f2star)','Location','SouthEast')
legend('h3(f1star)','h2(f2star)','Location','SouthEast')
xlabel('Patch Number sorted by h2(f2star)');
ylabel('Value');
%%
[vals,inds2] = sort(emdDistsGraphQuad);
figure
semilogy(emdDistsGraph(inds2))
hold on
semilogy(emdDistsGraphQuad(inds2))
legend('h1(f1star)','h2(f1star)')
xlabel('Patch Number sorted by h1(f1star)');

%%
[vals,inds2] = sort(emdDistsQPQuad);
figure
semilogy(emdDistsQP(inds2(3:end)))
hold on
semilogy(emdDistsQPQuad(inds2(3:end)))
legend('h1(f1star)','h2(f1star)')
xlabel('Patch Number sorted by h1(f1star)');

%%
numRows = 6;
numCol = 8;
maxPixel = max(basePatch(:));

[~,bestIndicesGraphQuad] = sort(emdDistsGraphQuad);
[~,bestIndicesQPQuad] = sort(emdDistsQPQuad);
[~,bestIndicesGraph] = sort(emdDistsGraph);
[~,bestIndicesQP] = sort(emdDistsQP);
%[~,bestIndicesQPH3] = sort(emdDistsQPH3);
%[~,bestIndicesGraphH3] = sort(emdDistsGraphH3);

%displayBestPatches( patches,bestIndicesGraphQuad,maxPixel,numRows,numCol );
displayBestPatches( patches,bestIndicesQPQuad,maxPixel,numRows,numCol );
%displayBestPatches( patches,bestIndicesGraph,maxPixel,numRows,numCol );
%displayBestPatches( patches,bestIndicesQP,maxPixel,numRows,numCol );
%displayBestPatches( patches,bestIndicesQPH3,maxPixel,numRows,numCol );
%displayBestPatches( patches,bestIndicesGraphH3,maxPixel,numRows,numCol );

%%
displayBestPatchesInStack(patches,bestIndicesGraph,maxPixel);
displayBestPatchesInStack(patches,bestIndicesQP,maxPixel);


%{
rescaledImg = basePatch./max(basePatch(:));
rescaledImg = rescaledImg*255;
resizedImg = imresize(rescaledImg,20,'Method','nearest');
myMap = colormap('jet'); 
%}
imwrite(resizedImg,myMap,'sampleSave.png');