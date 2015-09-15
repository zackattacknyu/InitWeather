%basePatchNum = floor(rand(1,1)*length(patches)) + 1;
%%
%{
With 7-22 patch set:
low: 305, value = 1140.3
medium: 61, value = 27708
high: 546, value = 54200
patchNums = [305 61 546];
%}

%{
With 7-29 kde set, some sample nums:
99, 82, 626, 762
%}
%patchNums = [99 82 626 762];

%{
With the 8-5 kde set, some sample nums:
339, 29, 19, 184, 899
%}
%patchNums = [339 29 19 184 899];

%with the 8-12 kde set
%patchNums=[4 299 686 236];
%patchNums=[256];

%Numbers with second patch set
%basePatchNum=280; %low patch, total = 2997
%basePatchNum=422; %high patch, total = 169640
%basePatchNum=579; %medium patch, total = 54954
%patchNums = [280 579 422];

%basePatchNum=106; %scatterd patch, total = 4160
%basePatchNum=500; %medium patch, total = 8982
%basePatchNum = 432; %high patch, total=43156
%basePatchNum = 607; %high patch 2, total = 47825
%basePatchNum = 601; %highest patch, total=230520
%basePatchNum = 124; %low patch, total = 1314
%basePatchNum = 59; %lowest patch, total = 1008
%patchNums = [106 500 432 607 601 124 59];

%for the 9-14 patch set
patchNums = [292 940 689];

alphaVal = 0.1;
call_7_29;
%%
save('matlabRun_alpha0.1_gradientPatches9-14.mat','-v7.3');
%%
alphaVal = 0.05;
call_7_29;
save('matlabRun_alpha0.05_kdePatches8-12.mat');

%%
numRows = 2;
numCol = 5;
pp = 1;
for pp = 1:4
    
    basePatchNum = patchNums(pp);
    basePatch = patches{basePatchNum};
    basePatch = floor(abs(basePatch));
    maxPixel = max(basePatch(:));
    emdQP = emdQPArrays{pp};
    mseArr = getMSEarray(basePatch,patches);
    [~,inds] = sort(emdQP);
    [~,inds2] = sort(mseArr);
    displayBestPatches( patches,inds,maxPixel,numRows,numCol );
    displayBestPatches( patches,inds2,maxPixel,numRows,numCol );
end


