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

for i = 1:length(patches)
   
    i
    curPatch = patches{i};
    curPatch = floor(abs(curPatch));
    
    %THIS IS SOLID
    [xx2,ff2] = getGraphAlgResult(basePatch,curPatch); 
    
    %THIS CURRENTLY SEEMS SOLID
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
weight1 = basePatch';
weight1 = weight1(:);
for i = 1:length(xQP)
    
    curPatch = patches{i};
    flowValsGraph = xGraphAlg{i};
    
    weight2 = curPatch';
    weight2 = weight2(:);
    quadErrorGraph = sum((weight1-sum(flowValsGraph,2)).^2) + ...
        sum((weight2-sum(flowValsGraph,1)').^2);
    
    totalFlow = sum(flowValsGraph(:));
    
    %THIS GIVES US H2 FOR BOTH
    emdDistsQP(i) = fvalQP{i}/totalFlow;
    emdDistsGraph(i) = (fvalGraphAlg{i} + quadErrorGraph)/totalFlow;
end

%%
figure
plot(emdDistsGraph)
hold on
plot(emdDistsQP)
legend('h2(f1star)','h2(f2star)')

%%
emdDistsGraph2 = zeros(1,length(emdDistsGraph));
emdDistsQP2 = zeros(1,length(emdDistsQP));
index = 0;
for i = 1:length(emdDistsQP)
   if(emdDistsGraph(i) >= 0 && emdDistsQP(i) >= 0)
       index = index + 1;
       emdDistsGraph2(index) = emdDistsGraph(i);
       emdDistsQP2(index) = emdDistsQP(i);
   end
end
emdDistsQP2 = emdDistsQP2(1:index);

%%
[dists,inds] = sort(emdDistsQP2);
%%
figure
plot(emdDistsGraph2(inds))
hold on
plot(emdDistsQP2(inds))
legend('h2(f1star)/sum(f)','h2(f2star)/sum(f)','location','Northwest')
emdDistsGraph2 = emdDistsGraph2(1:index);
xlabel('Patch Number sorted by h2(f2star)/sum(f)');
ylabel('EMD Value');