%%
%save('qpTestPatches.mat','patches');
%%
%load('qpTestPatches.mat');
%%

basePatch = patches{44};
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
    [xx,ff] = getQuadProgResult(basePatch,curPatch,0.1);
    
    
    xQP{i} = xx;
    fvalQP{i} = ff;
    
    xGraphAlg{i} = xx2;
    fvalGraphAlg{i} = ff2;
end

%%

emdDistsQP = zeros(1,length(xQP));
emdDistsGraph = zeros(1,length(xGraphAlg));
emdDistsGraphQuad = zeros(1,length(xGraphAlg));
quadErrorsQP = zeros(1,length(xQP));
quadErrorsGraph = zeros(1,length(xGraphAlg));
quadErrorsConst = zeros(1,length(patches));
numFlowVals = patchSize^4;
weight1 = basePatch';
weight1 = weight1(:);
for i = 1:length(xQP)
    
    curPatch = patches{i};
    flowValsGraph = xGraphAlg{i};
    
    quadErrorsConst(i) = (sum(basePatch(:)) - sum(curPatch(:)))^2;
    
    weight2 = curPatch';
    weight2 = weight2(:);
    quadErrorGraph = sum((weight1-sum(flowValsGraph,2)).^2) + ...
        sum((weight2-sum(flowValsGraph,1)').^2);
    quadErrorsGraph(i) = quadErrorGraph;
    
    totalFlow = sum(flowValsGraph(:));
    
    %NEEDS TO BE FIXED
    flowValsQP = xQP{i};
    flowValsQP = flowValsQP(1:numFlowVals);
    flowValsQP = reshape(flowValsQP,[patchSize^2 patchSize^2]);
    flowValsQP = flowValsQP';
    quadErrorQP = sum((weight1-sum(flowValsQP,2)).^2) + ...
        sum((weight2-sum(flowValsQP,1)').^2);
    quadErrorsQP(i) = quadErrorQP;
    
    %THIS GIVES US H2 FOR BOTH
    emdDistsQP(i) = fvalQP{i}/totalFlow;
    %emdDistsQP(i) = (fvalQP{i}-quadErrorQP)/totalFlow;
    emdDistsGraph(i) = (fvalGraphAlg{i})/totalFlow;
    emdDistsGraphQuad(i) = (fvalGraphAlg{i} + quadErrorGraph)/totalFlow;
end

%%
[vals,inds] = sort(quadErrorsGraph);
%inds = inds(5:end);
%%
semilogy(quadErrorsConst(inds)./quadErrorsGraph(inds));
%%
figure
semilogy(quadErrorsConst(inds));
hold on
semilogy(quadErrorsGraph(inds));
semilogy(quadErrorsQP(inds));
legend('r0','r1(f1star)','r1(f2star)')
%%
figure
semilogy(quadErrorsConst2(inds));
hold on
semilogy(emdDistsGraphQuad2(inds));
semilogy(emdDistsQP2(inds));
legend('r0','h2(f1star)','h2(f2star)','Location','SouthEast')
xlabel('Patch Number sorted by r0');
ylabel('Value');
%%
figure
semilogy(emdDistsGraph2)
hold on
semilogy(emdDistsGraphQuad2)
legend('h1(f1star)','h2(f1star)')
%%
emdDistsGraph2 = zeros(1,length(emdDistsGraph));
emdDistsGraphQuad2 = zeros(1,length(emdDistsGraph));
emdDistsQP2 = zeros(1,length(emdDistsQP));
quadErrorsConst2 = zeros(1,length(quadErrorsConst));
index = 0;
for i = 1:length(emdDistsQP)
   if(emdDistsGraph(i) >= 0 && emdDistsQP(i) >= 0 && emdDistsGraphQuad2(i) >= 0)
       index = index + 1;
       quadErrorsConst2(index) = quadErrorsConst(i);
       emdDistsGraph2(index) = emdDistsGraph(i);
       emdDistsQP2(index) = emdDistsQP(i);
       emdDistsGraphQuad2(index) = emdDistsGraphQuad(i);
   end
end
emdDistsQP2 = emdDistsQP2(1:index);
emdDistsGraph2 = emdDistsGraph2(1:index);
emdDistsGraphQuad2 = emdDistsGraphQuad2(1:index);
quadErrorsConst2 = quadErrorsConst2(1:index);

%%
[dists,inds] = sort(emdDistsGraphQuad2);
%%
figure
%plot(emdDistsGraph2(inds))
semilogy(emdDistsGraph2(inds))
hold on
%plot(emdDistsQP2(inds))
semilogy(emdDistsGraphQuad2(inds))
legend('h1(f1star)/sum(f)','h2(f1star)/sum(f)','location','Northwest')
xlabel('Patch Number sorted by h2(f1star)/sum(f)');
ylabel('EMD Value');