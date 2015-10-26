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
%patchNums = [292 940 689];

%for 9-15 patch set
%patchNums = [198 802 413 678];

%for the second 9-15 patch set
%patchNums = [270 323 888 367 997 419 502 514 840 834 798 332 876 724];
%patchNums = [270 419 840 724];

%for the 9-16 pca set
%patchNums = [1];

%for the second 9-16 pca set
%patchNums=[1];

%for the second 9-16 pca set, run 2
%patchNums=[50 836 2873];

%for the 9-23 patch set
%patchNums=[828 585 1483];

%for the 9-26 patch set
%patchNums=[239 1015 325 3656 584 3944 4175 2746];

%for the 10-7 patch set
%patchNums=[4221 6279 1493];

%for the 10-26 patch set
patchNums=[420 5376 5277 4024];

save('matlabRun_Patches10-26_setupData.mat','patches','patchNums');
%%
alphaVal = 0.1;
call_7_29;
save('matlabRun_Patches10-26_resultData4.mat','emdQPArrays','patches');
%save('matlabRun_alpha0.1_pcaSet9-15.mat','-v7.3');
%%
save('matlabRun_alpha0.1_gradientPatches9-14.mat','-v7.3');
%%
alphaVal = 0.05;
call_7_29;
save('matlabRun_alpha0.05_kdePatches8-12.mat');

%%
%numRows = 5;
%numCol = 10;
numRows = 2;
numCol = 5;
pp = 1;
for pp = 1:1
    
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


