function [tabulist] = updatetabulist(tabusize,tabulist,t1,t2)
for n = tabusize : -1 : 2
    tabulist(n,1) = tabulist((n-1),1);
    tabulist(n,2) = tabulist((n-1),2);
end
tabulist(1,1) = t1;
tabulist(1,2) = t2;
end