
% location of ground truth
trnImgDir = 'train/';
imgIds=dir([trnImgDir 'GOES/*.mat']); imgIds={imgIds.name};
nImgs=length(imgIds); for i=1:nImgs, imgIds{i}=imgIds{i}(1:end-4); end
% imgIds are in YYMMDDHHmm format

% to limit temporal training window, remove unwanted imgIds here

% quick fix because of missing data
keep = true(nImgs,1);
isGood = true;
for i = 1:nImgs
    if strcmp(imgIds{i}(1:end),'1208062315')
        isGood = false;
    end
    if strcmp(imgIds{i}(1:end),'1208082315')
        isGood = true;
    end
    if strcmp(imgIds{i}(1:end),'1208312315')
        isGood = false;
    end
    if strcmp(imgIds{i}(1:end),'1212010015')
        isGood = true;
    end
    keep(i) = isGood;
end

% Summer only (for now)
for i = 1:nImgs
    if strcmp(imgIds{i}(1:4), '1212')
        keep(i) =false;
    end
    if strcmp(imgIds{i}(1:4), '1301')
        keep(i) =false;
    end
    if strcmp(imgIds{i}(1:4), '1302')
        keep(i) =false;
    end
end

imgIds = imgIds(keep);

% select training window

imgIds = imgIds(1:end);
nImgs = length(imgIds);
    
%%

%for i = 1:nImgs
for i = 1:3
    
    % Get image id: YYMMDDHHmm
    imgId = imgIds{i};
    
    ST4 = load([trnImgDir 'ST4/' imgId(1:end-2) '.mat']);
    gt = ST4.I;
    siz = size(gt);
         
    figure(1); 
    clf;
    imagesc(gt);
    caxis([0 500]);
    colorbar;
    axis image;
  
    
end




