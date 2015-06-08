%%
%save('qpTestPatches.mat','patches');
%%
%load('qpTestPatches.mat');
%%

basePatch = patches{4};
basePatch = floor(abs(basePatch));

xQP = cell(1,length(patches));
fvalQP = cell(1,length(patches));
xGraphAlg = cell(1,length(patches));
fvalGraphAlg = cell(1,length(patches));

for i = 1:1
   
    i
    curPatch = patches{i};
    curPatch = floor(abs(curPatch));
    
    %THIS IS SOLID
    [xx2,ff2] = getGraphAlgResult(basePatch,curPatch); 
    
    %THIS NEEDS TO CHANGE SOMEHOW
    [xx,ff] = getQuadProgResult(basePatch,curPatch);
    
    
    xQP{i} = xx;
    fvalQP{i} = ff;
    
    xGraphAlg{i} = xx2;
    fvalGraphAlg{i} = ff2;
end

%%

emdDistsQP = zeros(1,length(xQP));
emdDistsGraph = zeros(1,length(xGraphAlg));
numFlowVals = patchSize^4;
for i = 1:length(xQP)
    flowVals = xQP{i};
    flowVals = flowVals(1:numFlowVals);
    flowValsGraph = xGraphAlg{i};
    flowValsGraph = flowValsGraph(:);
    flowValsGraph = flowValsGraph(1:numFlowVals);
    emdDistsQP(i) = sum(flowVals);
    emdDistsGraph(i) = sum(flowValsGraph);
    %emdDistsQP(i) = fvalQP{i}/sum(flowVals);
    %emdDistsGraph(i) = fvalGraphAlg{i}/sum(flowValsGraph);
end

%%
figure
plot(sort(emdDistsGraph))
hold on
plot(sort(emdDistsQP))
legend('h1(f1star)','h1(f2star)')
%%
figure
plot(emdDistsWithPenSquared)

%hold on
%plot(emdDistsQP)
%legend('h1(f1star) + r0','h2(f2star)')