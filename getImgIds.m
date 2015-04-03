function [ imgIds ] = getImgIds(trnImgDir)
%GETIMGDS Summary of this function goes here
%   Detailed explanation goes here

% location of ground truth
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
%{
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
%}

imgIds = imgIds(keep);

end

