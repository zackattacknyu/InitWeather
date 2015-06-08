%{
basePatch = patches{98};
curPatch = patches{8};

curN = 10;
basePatch = basePatch(1:curN,1:curN);
curPatch = curPatch(1:curN,1:curN);
%}

[baseWeight,basePixelLocs] = getFeatureWeight(basePatch);
[weight,pixelLocs] = getFeatureWeight(curPatch);

if(sum(weight) < sum(baseWeight))
    F2 = pixelLocs;
    F1 = basePixelLocs;
    W2 = weight;
    W1 = baseWeight;
else
    F1 = pixelLocs;
    F2 = basePixelLocs;
    W1 = weight;
    W2 = baseWeight;
end

Func = @getPixelDist;

f = gdm(F1, F2, Func);

% number of feature vectors
[m a] = size(F1);
[n a] = size(F2);

fVec = [f;zeros(m,1)];

% equality constraints
A1 = zeros(m, m * n + m);
A2 = zeros(n, m * n + m);
for i = 1:m
    for j = 1:n
        k = j + (i - 1) * n;
        A1(i, k) = 1;
        A2(j, k) = 1;
    end
    A1(i, m*n + i) = 1; %slack variable
end
Aeq = [A1; A2; zeros(m, m * n + m)];
beq = [W1; W2; zeros(m,1)];

% lower bound
lb = zeros(1, m * n + m);

%H matrix which jusct has identity around slack vars
H = [sparse(m*n,m*n) sparse(m*n,m);sparse(m,m*n) speye(m,m)];


% quadratic programming
myOpt = optimset('Algorithm','interior-point-convex');
[x, fval] = quadprog(H,fVec, [], [], Aeq, beq, lb,[],[],myOpt);
fval = fval / sum(x);