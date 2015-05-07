%number of prediction/target values
N = 3;

numFvals = N^2;
Hmat = zeros(numFvals,numFvals);
for i = 0:N-1
   Hmat( (N*i+1):(N*i+N) , (N*i+1): (N*i+N) ) = ones(N,N); 
end

Hmat2 = zeros(numFvals,numFvals);
colIndex = 1;
for j = 0:N-1
   for i = 0:N-1
       otherNum = N*i + j+1;
       curCol = Hmat(:,otherNum);
       Hmat2(:,colIndex) = curCol;
       colIndex = colIndex + 1;
   end
end

finalH = Hmat+Hmat2;
