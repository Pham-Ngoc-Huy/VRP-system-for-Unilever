%% random the position of the parent in the population
function parent = selection(pmax,population)
check = 0;
while check == 0
    r1 = round(random("Uniform",round(3*pmax/4),pmax+1)-0.5);
    r2 = round(random("Uniform",1,pmax+1)-0.5);
    if r1 == r2
        check = 0;
    else
        check = 1;
    end
end
%% parent take out
parent = cell(2,1);
parent{1} = population{r1};
parent{2} = population{r2};
end