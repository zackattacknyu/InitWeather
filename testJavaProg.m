load('rejectionSamplingPatches3.mat');
%%

load('goodPatches3.mat');
newPatches = randPatches;
%%

patchSize=20;
patches = cell(1,size(newPatches,1));
for i = 1:size(newPatches,1)
    imgToShow = reshape(newPatches(i,1:patchSize,1:patchSize),[patchSize patchSize]); 
    patches{i} = imgToShow;
end

%%

%to select a number of random patches from the newPatches batch
patchSize=20;
randInds = randperm(size(newPatches,1));
numPatches =100;
patches = cell(1,numPatches);
for i = 1:numPatches
    ind = randInds(i);
    imgToShow = reshape(newPatches(ind,1:patchSize,1:patchSize),[patchSize patchSize]); 
    patches{i} = imgToShow;
end

%%

%to select a number of random patches from the newPatches batch
patchSize=20;
randInds = randperm(length(newPatches));
numPatches = 100;
patches = cell(1,numPatches);
for i = 1:numPatches
    ind = randInds(i);
    %imgToShow = reshape(newPatches(ind,1:patchSize,1:patchSize),[patchSize patchSize]); 
    patches{i} = newPatches{ind};
end

%%
%basePatchNum = floor(rand(1,1)*length(patches)) + 1;
basePatchNum=271;
basePatch = patches{basePatchNum};

figure
imagesc(basePatch);
%%
basePatch = patches{basePatchNum};
%%
[baseWeight,basePixelLocs] = getFeatureWeight(basePatch);
F1 = basePixelLocs;
W1 = baseWeight;
%Func = @getPixelSquaredDist;
Func = @getPixelDist;
[m a] = size(F1);

errorFunc = @(x) getTotalError(f,W1,W2,x);
numPatches = 100;
W2vectors = cell(1,numPatches);

for patchNum = 1:numPatches
    curPatch = patches{patchNum};
    
    totalFlow = min(sum(sum(basePatch)),sum(sum(curPatch)));
    [weight,pixelLocs] = getFeatureWeight(curPatch);
    
    F2 = pixelLocs;
    W2 = weight;
    W2vectors{patchNum} = W2;
    
    % number and length of feature vectors    
    [n a] = size(F2);

    % gets ground distance matrix
    f = zeros(m,n);
    capF = zeros(m,n); %capacity of link. set to zero.
    %maxDist = 5;
    for i = 1:m
        for j = 1:n
            f(i, j) = Func(F1(i, 1:a), F2(j, 1:a));
            capF(i,j)=1;
            %if( norm(F1(i, 1:a)-F2(j, 1:a),Inf) <= maxDist)
            %   capF(i,j)=1; 
            %end
        end
    end

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
    capMatrix(1:N1,(N1+1):(N2+N1)) = capF.*totalFlow;

    file1 = strcat('matricesToCompute/costMatrix',num2str(patchNum),'.txt');
    file2 = strcat('matricesToCompute/capMatrix',num2str(patchNum),'.txt');
    save(file1,'costMatrix','-ascii');
    save(file2,'capMatrix','-ascii');
    
    if(mod(patchNum,10) == 0)
       patchNum 
    end
    
end

%%

% inequality constraints
NN = length(W1);
A1 = zeros(NN, NN * NN);
A2 = zeros(NN, NN * NN);
for i = 1:NN
    for j = 1:NN
        k = j + (i - 1) * NN;
        A1(i, k) = 1;
        A2(j, k) = 1;
    end
end
A = [A1; A2];
Aeq = ones(NN + NN, NN * NN);
lb = zeros(1, NN * NN);
f = f';
f = f(:);

percentToMax=zeros(1,numPatches);
percentToMaxOther=zeros(1,numPatches);
%percentOverMin = zeros(1,numPatches);
sumW1 = sum(W1);
for i = 1:numPatches
    
    sourceFile = strcat('emdResults/sourceFlow',num2str(i),'.txt');
    sinkFile = strcat('emdResults/sinkFlow',num2str(i),'.txt');
    
    flowMatrixFile = strcat('emdResults/pixelFlowMatrix',num2str(i),'.txt');
    xInit = load(flowMatrixFile);
    xInit = xInit';
    xInit = xInit(:);
    
    sourceFlow = load(sourceFile);
    sinkFlow = load(sinkFile);
    currentW2 = W2vectors{i};
    sumSquError = sum((sourceFlow-W1).^2) + sum((sinkFlow-currentW2).^2);
    
    b = [W1; currentW2];
    beq = ones(NN + NN, 1) * min(sum(W1), sum(currentW2));
    
    errorFunc = @(x) getTotalError(f,W1,currentW2,x);
    [newX,fvals] = fmincon(errorFunc,xInit,A,b,Aeq,beq,lb,[]);
    sumSquErrorOther = getSquaredError(newX,W1,currentW2);

    %{
    This part calculates the min
        and max of the quadratic error
        part of the quadratic program
        to see how close we are

    Details are in Weather Project folder
        under MinMaxQuadraticPart.JPG
    %}
    maxSquaredError = (sumW1 - sum(currentW2))^2;
    minSquaredError = maxSquaredError/length(W1);
    
    percentToMax(i) = (sumSquError-minSquaredError)/(maxSquaredError-minSquaredError);
    percentToMaxOther(i) = (sumSquErrorOther-minSquaredError)/(maxSquaredError-minSquaredError);
    %percentOverMin(i) = (sumSquError-minSquaredError)/minSquaredError;
end

%%

figure
%[P1, I] = sort(percentToMax(percentToMax<1));
P1 = percentToMax; P1(P1 > 0.09)=0;
plot(P1,'g-');
hold on
%[P2, I] = sort(percentToMaxOther(percentToMaxOther<0.2));
P2 = percentToMaxOther; P2(P2>0.09)=0;
plot(P2,'r-')
xlabel('Image Patch');
ylabel('Error on 0-1 scale with 0 as min, 1 as max');
legend('Max Flow Algorithm','Non-Linear Optimization','Location','Northwest');
%%
save('algorithmRunResults.mat','percentToMax','percentToMaxOther','-v7.3');

%{
figure
[P2, I] = sort(percentOverMin(percentOverMin<100));
plot(P2)
xlabel('Image Patch');
ylabel('Ratio of Error to Min Error');
%}

%%

load('emdResults.txt');
[emdVals bestIndices] = sort(emdResults);
