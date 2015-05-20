%H = (Hmat+Hmat')/2;
%quadError = 0.5*xInit'*H*xInit + dot(xInit,fVec) + sum(W1.^2) + sum(W2.^2);
%error = getTotalError(f,W1,W2,xInit);

oldSquaredError = getSquaredError(xInit,W1,W2);
func = @(x) getTotalError(f,W1,W2,x);
[best,fvals] = fmincon(func,xInit,A,b,Aeq,beq,lb,[]);
newSquError = getSquaredError(best,W1,W2);

%%
maxSquaredError = (sum(W1) - sum(W2))^2;
minSquaredError = maxSquaredError/length(W1);

xVec = best;
n = floor(sqrt(length(xVec)));
xMat = reshape(xVec,n,n);
w1guess = sum(xMat,1); 
w1guess = w1guess';
w2guess = sum(xMat,2);

sumSquError = sum((w1guess-W1).^2) + sum((w2guess-W2).^2);