%patchNums=[1];
%alphaVal = 0.1;
%patches=patchesTest1;
%call_7_29;
%save('matlabRun_Patches9-17_resultData2_1.mat','emdQPArrays');

patchNums=[1];
alphaVal = 0.1;
patches=patchesTest2;
call_7_29;
save('matlabRun_Patches9-17_resultData2_2.mat','emdQPArrays');

patches=patchesTest3;
call_7_29;
save('matlabRun_Patches9-17_resultData2_3.mat','emdQPArrays');

patchNums=[151];
patches=patchesTest4;
call_7_29;
save('matlabRun_Patches9-17_resultData2_4.mat','emdQPArrays');

patchNums=[836 2873];
alphaVal = 0.1;
patches=origPatches;
call_7_29;
save('matlabRun_Patches9-16_resultData4.mat','emdQPArrays','patches');