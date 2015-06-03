%%
%save('qpTestPatches.mat','patches');
%%
%load('qpTestPatches.mat');
%%

basePatch = patches{4};

xQP = cell(1,length(patches));
fvalQP = cell(1,length(patches));

for i = 1:length(patches)
   
    i
    curPatch = patches{i};
    
    [xx,ff] = getQuadProgResult(basePatch,curPatch);
    
    xQP{i} = xx;
    fvalQP{i} = ff;
    
end