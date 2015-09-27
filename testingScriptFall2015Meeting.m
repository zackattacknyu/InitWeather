numRows = 1;
numCol = 11;
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
    
    %displays target
    figure
    colormap jet
    imagesc(basePatch,[0 maxPixel]);
    colorbar;
    axis off
    
    displayBestPatches( patches,inds,maxPixel,numRows,numCol );
    displayBestPatches( patches,inds2,maxPixel,numRows,numCol );
end