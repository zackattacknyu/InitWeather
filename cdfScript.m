numBins = 30;
bins = floor(rand(1,n)*1000);
bins(5) = 0;

%get normalization constant
normFactor = 0;
binSum = sum(bins);
for i=1:n
    if(bins(i) > 0)
        normFactor = normFactor + binSum/(bins(i)*numBins);
    end
   
end

%get probabilities
probs = zeros(1,numBins);
for j = 1:n
    if(bins(j) > 0)
        probs(j) = binSum/(bins(j)*numBins*normFactor); 
    end
end