% quadratic programming
[x, fval] = quadprog(Hmat,fVec, A, b, Aeq, beq, lb,[],xInit);
fval = fval / sum(x);