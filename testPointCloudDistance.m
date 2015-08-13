n = 10;
m = 6;
rangeVal=100;
minVal2 = 0;

target= rangeVal*rand(n,2);
pred = rangeVal*rand(m,2);

getPointCloudDistance(target,pred)

figure
hold on
plot(targetX,targetY,'k.');
plot(predX,predY,'rx');
hold off