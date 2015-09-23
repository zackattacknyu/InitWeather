patches = patchesTest1;
numPatches = length(patches);

fracDenom = 4;

basePatchNum = 1;
basePatch = patches{basePatchNum};
basePatch = floor(abs(basePatch));
basePatchSmall = fractionPatch(basePatch,fracDenom);

%EMD with squared error calculated with x values from quadratic programming
emdDistsQPQuad = zeros(1,numPatches);

for i = 1:numPatches

    i
    curPatch = patches{i};
    curPatch = floor(abs(curPatch));
    curPatchSmall = fractionPatch(curPatch,fracDenom);

    try
        [quadX,rawF,rawEmdDist,rawQuadError,totalFlow] = ...
            getQuadProgResult(basePatchSmall,curPatchSmall,alphaVal);
    catch
    end
    emdDistsQPQuad(i) = rawF/totalFlow;
end


save('matlabRun_Patches9-22_resultDataX.mat','patches');
%%
[emdSorted,indsE] = sort(emdDistsQPQuad);
[emdSorted2,indsE2] = sort(emdDistsQPQuad2);
corr(indsE',indsE2','type','Spearman')

%%
plot(emdDistsQPQuad(indsE),'r-');
hold on
plot(emdDistsQPQuad2(indsE),'b-');
hold off





