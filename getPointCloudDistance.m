function [ pointCloudDistance ] = getPointCloudDistance( target,pred )
%UNTITLED2 gets simple point cloud distance
%   Input:
%       target - N by 2 matrix of points in target patch
%       pred - M by 2 matrix of points in prediction patch
%   Output:
%       simple point cloud distance between points

targetX = target(:,1)'; targetY = target(:,2)';
predX = pred(:,1); predY = pred(:,2);

m = size(pred,1); n = size(target,1);
targetXmat = repmat(targetX,m,1);
targetYmat = repmat(targetY,m,1); 
predXMat=repmat(predX,1,n);
predYMat=repmat(predY,1,n);

distMat = sqrt( (targetXmat-predXMat).^2 + (targetYmat-predYMat).^2 );

targetDists = min(distMat,[],1);
predDists = min(distMat,[],2);

pointCloudDistance = sum(targetDists)+sum(predDists);

end

