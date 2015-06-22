%TO BE RUN AFTER SAMPLINGSCRIPT.M
%   DOES THE SAMPLING

%THIS SHOWS MULTIPLE PATCHES IN A WINDOW
numToShow = 20;
startInd = 56;
patchSize = 40;
index = startInd;
figure
for i = 1:numToShow
    %patchCoord = patchIndex{patchesToShow(i)};
    patchCoord = patchIndex{index};
    subplot(4,5,i);
    patchCoord(1)
    imagesc(allImgs{patchCoord(1)});
    currentInd = patchCoord(1);
    hold on
    while currentInd==patchCoord(1)
        rectangle('Position',[patchCoord(3) patchCoord(2) patchSize patchSize],'EdgeColor','white');
        index = index + 1;
        patchCoord = patchIndex{index};
    end
    
    hold off
end

%%

%THIS SHOWS MORE RANDOM PATCHES
patchesToShow = randperm(length(patchIndex));
numToShow = 20;
patchSize = 40;
index = 1;
figure
for i = 1:numToShow
    patchCoord = patchIndex{patchesToShow(i)};
    subplot(4,5,i);
    patchCoord(1)
    imagesc(allImgs{patchCoord(1)});
    hold on
    rectangle('Position',[patchCoord(3) patchCoord(2) patchSize patchSize],'EdgeColor','white');
    
    hold off
end