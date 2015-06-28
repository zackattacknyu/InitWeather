emdDistsGraphH3 = zeros(1,numPatches);
emdDistsQPH3 = zeros(1,numPatches);

%MUST BE RUN AFTER TESTING SCRIPT
alphaVal = 0.001;
for i = 1:numPatches
    
    i
    curPatch = patches{i};
    curPatch = floor(abs(curPatch));
    totalFlow = min(sum(sum(basePatch)),sum(sum(curPatch)));
    
    emdDistsGraphH3(i) = emdDistsGraph(i) + (alphaVal*quadErrorsConst(i))/totalFlow;
    emdDistsQPH3(i) = emdDistsQP(i) + (alphaVal*quadErrorsConst(i))/totalFlow;
end