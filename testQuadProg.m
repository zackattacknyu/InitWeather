basePatch = patches{9};
curPatch = patches{8};
%%
curPatchNum = 3;
flowMatrixFile = strcat('emdResults/pixelFlowMatrix',num2str(curPatchNum),'.txt');
xInit = load(flowMatrixFile);
curPatches = patches{curPatchNum};
xInit = xInit';
xInit = xInit(:);
%%
[baseWeight,basePixelLocs] = getFeatureWeight(basePatch);
[weight,pixelLocs] = getFeatureWeight(curPatch);

F1 = pixelLocs;
F2 = basePixelLocs;
W1 = weight;
W2 = baseWeight;
Func = @getPixelDist;

f = gdm(F1, F2, Func);

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
%%
% quadratic programming
[x, fval] = quadprog(Hmat,fVec, A, b, Aeq, beq, lb,[],xInit);
fval = fval / sum(x);

%%
wVal = fval + sum(W1.^2) + sum(W2.^2);