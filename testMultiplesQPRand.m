%%
%save('qpTestPatches.mat','patches');
%%
%load('qpTestPatches.mat');
%%

size = 20;
maxNum = 9000;
basePatch = floor(rand(size)*maxNum);
numPatch = 20;

xQP = cell(1,numPatch);
fvalQP = cell(1,numPatch);

for i = 1:numPatch
   
    i
    curPatch = floor(rand(size)*maxNum);
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

hold on
plot(emdDistsQP)
legend('h1(f1star) + r0','h2(f2star)')
%}