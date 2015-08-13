centerPtInVol = [58 54 23];
curRadius = 30;

%tempImage = currentThermalMap(:,:,centerPtInVol(3));
centR = centerPtInVol(1); centC = centerPtInVol(2);
numR = size(tempImage,2);
numC = size(tempImage,1);
[rr, cc] = meshgrid(1:numR,1:numC);

distanceMat = (rr-centR).^2 + (cc-centC).^2;
distances = distanceMat(:);
tempsInRegion = tempImage(:); 

indices1 = find(distances<curRadius^2);
indices2 = find(cc==floor(centC));
indices3 = find(rr<floor(centR));
indicesInclude = intersect(intersect(indices1,indices2),indices3);
%%
distancesToInclude = distances(indicesInclude);
tempsToInclude = tempsInRegion(indicesInclude);

tempsNormalized = (tempsToInclude-min(tempsToInclude));

fitAttempt = fit(distancesToInclude,tempsNormalized,'exp1');

xx = 1:900;
yy = fitAttempt(xx);


figure
hold on
plot(distancesToInclude,tempsNormalized,'b.');
plot(xx,yy,'r-','LineWidth',3);
hold off
%%

yVals = tempsNormalized;
yHat = fitAttempt(distancesToInclude);
yresid = yVals-yHat;

SSresid = sum(yresid.^2);
SStotal = (length(yVals)-1) * var(yVals);
rsq = 1 - SSresid/SStotal;