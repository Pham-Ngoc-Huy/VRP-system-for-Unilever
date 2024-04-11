Num_population = 5;
Max_Iterations = 100;
inertia_weight = 0.5; % Inertia weight
c1 = 1.5; % Cognitive coefficient
c2 = 1.5; % Social coefficient
p = [10, 10, 13, 4];
d = [4, 2, 1, 12];
w = [14, 12, 1, 12];
Numb_Jobs = 4;

% Initialize swarm positions
population = zeros(Num_population,Numb_Jobs);

% Initialize velocities
velocity = zeros(Num_population, Numb_Jobs);

% Initialize personal best positions and fitness values
pbest = population;
pbest_fitness = zeros(Num_population, 1);

velocity_matrix =  zeros(Num_population, Numb_Jobs);

fitness_values = zeros(Num_population, 1);

gbest = [];
gbest_fitness = Inf;


%% initialization population create
i = 1;
feasible = 0;
for iter = 1 : Max_Iterations
while i <= Num_population
    population(i,:) = randperm(Numb_Jobs);
    if i >= 2   
        if population(i,:) == population(i - 1,:)
            feasible = 1;
        else 
            feasible = 0;
        end
    end
    if feasible == 1
       population(i,:) = randperm(Numb_Jobs);
    else
       x_now = population(i,:);
       fitness_values(i) = fitnessfunction(Numb_Jobs, p,x_now,w,d);
       if fitness_values(i) < pbest_fitness(i)
            pbest(i, :) = population(i, :);
            pbest_fitness(i) = fitness_values(i);
       end
       % Update global best
       if fitness_values(i) < gbest_fitness
            gbest = population(i, :);
            gbest_fitness = fitness_values(i);
       end
       i = i + 1;
    end
end
    % Update velocities and positions
   for i = 1:Num_population
       r1 = rand();
       r2 = rand();
       velocity(i, :) = inertia_weight * velocity(i, :) + c1 * r1 * (pbest(i, :) - population(i, :)) + c2 * r2 * (gbest - population(i, :));
       population(i, :) = population(i, :) + round(velocity(i, :));
   end
end   
best_tardiness = gbest_fitness;

%% fitness funtion
function [Tardiness,bestsolution] = fitnessfunction(Numb_Jobs, p,bestsolution,w,d)
Ptime = 0;
Tardiness = 0;
for j = 1:Numb_Jobs
    Ptime = Ptime + p(bestsolution(j));
    Tardiness = Tardiness + w(bestsolution(j))*max(Ptime-d(bestsolution(j)),0);
end
end