
%{
[~,bestIndicesQPQuad] = sort(emdDistsQPQuad);
for k = 1:length(bestIndicesQPQuad)
   subplot(numRows,numCol,k);
   imagesc(patches{bestIndices(k)}, [0 maxPixel])
   axis off
end

image1 = patches{1};
image1 = image1./(maxPixel);
image1Zoom = magnifyImage(image1,magFactor);
imwrite(image1Zoom,'sampleImg.png');
%}

%%

imagesc(basePatch);
colormap gray;
colorbar;

%%
magFactor = 20;
writerObj = VideoWriter('sampleVideo.avi');
writerObj.FrameRate=8;
open(writerObj);

for k = 1:length(bestIndicesQPQuad)
    image1 = patches{bestIndicesQPQuad(k)};
    image1 = image1./maxPixel;
    image1(image1>1)=1;
    image1Zoom = magnifyImage(image1,magFactor);
    writeVideo(writerObj,image1Zoom);
end

close(writerObj)
