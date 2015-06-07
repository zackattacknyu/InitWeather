
javaaddpath('java/MinCostMaxFlowImp/build/classes')

[baseWeight,basePixelLocs] = getFeatureWeight(basePatch);
F1 = basePixelLocs;
W1 = baseWeight;
%Func = @getPixelSquaredDist;
Func = @getPixelDist;
[m a] = size(F1);

numPatches = 100;
W2vectors = cell(1,numPatches);

emdDistsWithPenalty = zeros(1,numPatches);
emdDistsWithPenSquared = zeros(1,numPatches);
emdDists = zeros(1,numPatches);
%alpha1 = 1e-4;
alpha1 = 1;
%alpha2 = 1e-8;
alpha2 = 1;
basePatchTotal = sum(sum(basePatch));

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
    
    numEdges = size(costMatrix,1);
    
    file1 = strcat('matricesToCompute/costMatrix',num2str(patchNum),'.txt');
    file2 = strcat('matricesToCompute/capMatrix',num2str(patchNum),'.txt');
    save(file1,'costMatrix','-ascii');
    save(file2,'capMatrix','-ascii');
    
    file1String = java.lang.String(strcat(pwd,'/',file1));
    file2String = java.lang.String(strcat(pwd,'/',file2));
    
    clear result;
    result = javaMethod('obtainEmdResults','mincostmaxflowimp.EmdResults',file1String,file2String);

    sourceFlow = javaMethod('getSourceFlowVector',result);
    sinkFlow = javaMethod('getSinkFlowVector',result);
    totalFlow = min( sum(sourceFlow), sum(sinkFlow) );
    
    fVal = javaMethod('getEmd',result);
    curPatchTotal = sum(sum(curPatch));
    
    %approach where we add alpha(x - x^)
    f1 = fVal + (alpha1/totalFlow)*abs(curPatchTotal - basePatchTotal);
    
    %approach where ad add alpha*(x-x^)^2
    f2 = fVal + (alpha2/totalFlow)*(curPatchTotal - basePatchTotal)^2;

    emdDists(i) = fVal;
    emdDistsWithPenSquared(i) = f2;
    emdDistsWithPenalty(i) = f1;
    
    if(mod(patchNum,5) == 0)
       patchNum 
    end
    
end


[~,bestIndices] = sort(emdDists);
[~,bestIndicesPen] = sort(emdDistsWithPenalty);
[~,bestIndicesPenSqu] = sort(emdDistsWithPenSquared);
