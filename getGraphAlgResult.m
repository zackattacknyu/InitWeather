function [ xvals,fval,quadError,totalFlow ] = getGraphAlgResult( basePatch,curPatch )
%GETGRAPHALGRESULT Summary of this function goes here
%   Detailed explanation goes here

javaaddpath('java/MinCostMaxFlowImp/build/classes')

[baseWeight,basePixelLocs] = getFeatureWeight(basePatch);
F1 = basePixelLocs;
W1 = baseWeight;
Func = @getPixelDist;
[m a] = size(F1);
   
totalFlow = min(sum(sum(basePatch)),sum(sum(curPatch)));
[weight,pixelLocs] = getFeatureWeight(curPatch);

F2 = pixelLocs;
W2 = weight;

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

file1 = 'matricesToCompute/costMatrixTemp.txt';
file2 = 'matricesToCompute/capMatrixTemp.txt';
save(file1,'costMatrix','-ascii');
save(file2,'capMatrix','-ascii');

file1String = java.lang.String(strcat(pwd,'/',file1));
file2String = java.lang.String(strcat(pwd,'/',file2));

clear result;
result = javaMethod('obtainEmdResults','mincostmaxflowimp.EmdResults',file1String,file2String);

xvals = javaMethod('getPixelFlowMatrix',result);
fval = javaMethod('getEmd',result);

quadError = sum((W1-sum(xvals,2)).^2) + ...
        sum((W2-sum(xvals,1)').^2);

end

