%%
%save('qpTestPatches.mat','patches');
%%
load('qpTestPatches.mat');
%%

basePatch = patches{4};
basePatch = floor(abs(basePatch));

xQP = cell(1,length(patches));
fvalQP = cell(1,length(patches));

for i = 1:20
   
    i
    curPatch = patches{i};
    curPatch = floor(abs(curPatch));
    [xx,ff] = getQuadProgResult(basePatch,curPatch);
    
    xQP{i} = xx;
    fvalQP{i} = ff;
    
end

%%
%{
emdDistsQP = zeros(1,length(xQP));
for i = 1:length(xQP)
    flowVals = xQP{i};
    flowVals = flowVals(1:10000);
    emdDistsQP(i) = fvalQP{i}/sum(flowVals);
end

%%
figure
plot(sort(emdDistsWithPenSquared))
hold on
plot(sort(emdDistsQP))
legend('h1(f1star) + r0','h2(f2star)')
%%
figure
plot(emdDistsWithPenSquared)
%}
hold on
plot(emdDistsQP)
legend('h1(f1star) + r0','h2(f2star)')