function [ mseVec ] = getMSEarray( target,predictionsArray )
%GETMSEARRAY Summary of this function goes here
%   Detailed explanation goes here

mseVec = zeros(1,length(predictionsArray));

for i = 1:length(predictionsArray)
    diffArray = target-predictionsArray{i};
    diffVec = diffArray(:);
    mseVec(i) = mean(diffVec.^2);
end

end

