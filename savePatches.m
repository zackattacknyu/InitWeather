save('patches.txt','basePatch','-ascii');
%%
load('patches.txt');
%%
fMatrix = reshape(f,[100 100]);

%%
save('fMat.txt','fMatrix','-ascii');