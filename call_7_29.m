numPatches = length(patches);
emdQPArrays = cell(1,length(patchNums));

for patchI = 1:length(patchNums)
    basePatchNum = patchNums(patchI);
    basePatch = patches{basePatchNum};
    basePatch = floor(abs(basePatch));
    
    %EMD with squared error calculated with x values from quadratic programming
    emdDistsQPQuad = zeros(1,numPatches);

    %qpCalcTime = cell(1,numPatches);

    %value in front of sqared error term
    

    for i = 1:numPatches

        i
        curPatch = patches{i};
        curPatch = floor(abs(curPatch));

        %THIS IS SOLID
        startTime = datetime('now');
        [quadX,rawF,rawEmdDist,rawQuadError,totalFlow] = getQuadProgResult(basePatch,curPatch,alphaVal);
        endTime = datetime('now');
        calcTime = endTime-startTime;
        calcTime
        emdDistsQPQuad(i) = rawF/totalFlow;
        
        if(mod(i,200)==0)
            save('matlabRun_Patches9-26_resultDataX4_temp.mat','emdDistsQPQuad');
        end
    end
    
    emdQPArrays{patchI} = emdDistsQPQuad;
    
    save('matlabRun_Patches9-26_resultDataX4.mat','emdQPArrays','patches');
end