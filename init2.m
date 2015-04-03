trnImgDir = 'train/';
imgIds = getImgIds(trnImgDir);

% select training window

imgIds = imgIds(1:end);
nImgs = length(imgIds);
    
%%

imgId = imgIds{1};   
ST4 = load([trnImgDir 'ST4/' imgId(1:end-2) '.mat']);
gt1 = ST4.I;

%%
allImgs = zeros([nImgs size(gt1)]);

%%

for i = 1:nImgs
%for i = 1:3
    
    % Get image id: YYMMDDHHmm
    imgId = imgIds{i};
    
    ST4 = load([trnImgDir 'ST4/' imgId(1:end-2) '.mat']);
    gt = ST4.I;
    
    allImgs(i,:,:) = gt;
    
    if(mod(i,10)==0)
       i 
    end
    
  
    
end

%%

save('allGTimages.mat','allImgs','-v7.3');




