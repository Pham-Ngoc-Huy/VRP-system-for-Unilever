Numb_Jobs = 4;
p = [10,10,13,4];
d = [4,2,1,12];  
w = [14,12,1,12]; 
tempmax = 5000;
inittemp = 100;
maxtime = 50;
termination_factor = 0.0001;
temperature_reduce = 0.05;
min_rand = 0;
max_rand = 1;

% iteration 1:
% create a random array to be an initial solution

vt = randperm(Numb_Jobs);
[Tardiness,vt] = fitnessfunction(Numb_Jobs,p,vt,w,d);
Initsolu = Tardiness;
bestsolution = vt;
besttime = Tardiness;
bestTardiness = zeros(tempmax,1);
Tempt = inittemp;

% iteration 2->n
for iter = 1:tempmax
    for iter2 = 1:maxtime        
        % create a neighbor
        lg=GenerateNeighbor(bestsolution);
        % fitness function
        [Tardiness,lg] = fitnessfunction(Numb_Jobs, p,lg,w,d);
        Neighborsolu = Tardiness;
        % calculate delta E
        deltaE = changing(besttime, Neighborsolu);
        proba = exp(-deltaE/Tempt);
        acceptance = probability(min_rand, max_rand);
        if deltaE < 0
            none = lg;
        elseif acceptance < proba
            none = lg;
        end
        if Neighborsolu < besttime 
            bestsolution = none;
            besttime = Neighborsolu;
        end
    end
        bestTardiness(iter) = besttime;
        Tempt = Tempt*temperature_reduce;
        it;
end
plot(bestTardiness,'LineWidth',3);
xlabel('Iteration');
ylabel('Best cost');
grid on;
%% generate neighbor solution
function lg=GenerateNeighbor(bestsolution)
    r=randi([1 2]);
        if r ==1
            lg = swap(bestsolution);
        else
            lg = insert(bestsolution);
        end
end
%% swapping
function lg=swap(bestsolution)
    n= numel(bestsolution);
    i=randperm(n,2);    
    lg=bestsolution;
    lg([i(1) i(2)]) = bestsolution([i(2) i(1)]);
end
%% insertion
function lg = insert(bestsolution)
    n= numel(bestsolution);
    i=randperm(n,2);
    if i(1)<i(2)
        lg= [bestsolution(1:i(1)-1) bestsolution(i(1)+1:i(2)) bestsolution(i(1)) bestsolution(i(2)+1:end)];
    else
        lg=[bestsolution(1:i(2)) bestsolution(i(1)) bestsolution(i(2)+1:i(1)-1) bestsolution(i(1)+1:end)];
    end
end
%% fitness funtion
function [Tardiness,bestsolution] = fitnessfunction(Numb_Jobs, p,bestsolution,w,d)
Ptime = 0;
Tardiness = 0;
for j = 1:Numb_Jobs
    Ptime = Ptime + p(bestsolution(j));
    Tardiness = Tardiness + w(bestsolution(j))*max(Ptime-d(bestsolution(j)),0);
end
end
%% calculate the deltaE
function deltaE = changing(besttime, Neighborsolu)
    deltaE = Neighborsolu - besttime;
end
%% probability check
function acceptance = probability(min_rand, max_rand)
         acceptance = random('Uniform',min_rand,max_rand);
end