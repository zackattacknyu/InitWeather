basePatch = [[100 200 300];[200 300 100]; [300 100 200]];
curPatch = repmat([100 200 300],3,1);
%%

basePatch = patches{9};
curPatch = patches{3};

%%
totalFlow = min(sum(sum(basePatch)),sum(sum(curPatch)));
[baseWeight,basePixelLocs] = getFeatureWeight(basePatch);
[weight,pixelLocs] = getFeatureWeight(curPatch);

F1 = basePixelLocs;
W1 = baseWeight;

F2 = pixelLocs;
W2 = weight;
%Func = @getPixelSquaredDist;
Func = @getPixelDist;

% number and length of feature vectors
[m a] = size(F1);
[n a] = size(F2);

% gets ground distance matrix
f = zeros(m,n);
for i = 1:m
    for j = 1:n
        f(i, j) = Func(F1(i, 1:a), F2(j, 1:a));
    end
end
%%

%{
Graph has the following description:
    Edges from source to nodes with baseWeight
    Edges between baseWeight and curWeight
    Edges from curWeight to sink

Let N be number of pixels in basePatch
Cost Matrix and Capacity Matrix for the graph will have the following:
    First N rows/columns are nodes for basePatch
    Next N rows/columns are nodes for curPatch
    Node 2N+1 is the source
    Node 2N+1 is the sink
%}
%%
N1 = length(W1); N2 = length(W2);
matrixN = N1+N2+2;

%makes cost matrix
costMatrix = ones(matrixN,matrixN)*totalFlow;

%makes capacity matrix. all edges not in graph have capacity 0
capMatrix = zeros(matrixN,matrixN);

%makes edges from source to base
sourceIndex = N1+N2+1;
for i = 1:N1
   costMatrix(sourceIndex,i) = 0;
   capMatrix(sourceIndex,i) = W1(i);
end

%makes edge from current to sink
sinkIndex = sourceIndex+1;
for i = 1:N2
   index = N1 + i;
   costMatrix(index,sinkIndex)=0;
   capMatrix(index,sinkIndex)=W2(i);
end

%makes edges from base to current
costMatrix(1:N1,(N1+1):(N2+N1)) = f;
capMatrix(1:N1,(N1+1):(N2+N1)) = ones(N1,N2).*totalFlow;

%%
save('costMatrix.txt','costMatrix','-ascii');
save('capMatrix.txt','capMatrix','-ascii');
%%
% number of feature vectors
[m a] = size(F1);
[n a] = size(F2);

%gets weight matrix
wMat = zeros(m,n);
for i = 1:m
    for j = 1:n
        wMat(i, j) = -2*(W1(i)+W2(j));
    end
end
wMat = wMat';
wVec = wMat(:);
fVec = f+wVec;

% inequality constraints
A1 = zeros(m, m * n);
A2 = zeros(n, m * n);
for i = 1:m
    for j = 1:n
        k = j + (i - 1) * n;
        A1(i, k) = 1;
        A2(j, k) = 1;
    end
end
A = [A1; A2];
b = [W1; W2];

% equality constraints
Aeq = ones(m + n, m * n);
beq = ones(m + n, 1) * min(sum(W1), sum(W2));

% lower bound
lb = zeros(1, m * n);

Hmat = getHmatrix(n);
Hmat = Hmat.*2;

% quadratic programming
[x, fval] = quadprog(Hmat,fVec, A, b, Aeq, beq, lb);
fval = fval / sum(x);

%%
wVal = fval + sum(W1.^2) + sum(W2.^2);