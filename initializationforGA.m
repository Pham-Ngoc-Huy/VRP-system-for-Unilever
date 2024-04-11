%% initialization
tic
run("datasource.m");
run("input_parameter.m");
p = 1;
population = cell(pmax,1);
pop_fitness_matrix = zeros(pmax,1);
pop_truck = cell(pmax,1);
pop_route = cell(pmax,1);

while p <= pmax
    if p <= percentage_of_infeasible
       run("Heuristics.m")
       [revenue_init, employee_cost_init,distance_travel_init,travel_cost_init,profit_init] = fitnessfunction(routing_mat,Num_product,price_product,Order_route_quantity,truck_decode,employ_cost,route_used,distance,lengths,travelling_cost,sep_decode);
       population{p} = [routing_order,cell2mat(truck_encode),cell2mat(delayed_today_encode)];  
       pop_fitness_matrix(p) = profit_init;
       pop_truck{p} = truck_decode;
       pop_route{p} = route_used;
    else
       population{p} = [randperm(Num_route), randi([0,1],1,numBits_sep*(Num_truck)), randi([0,1],1,numBits_sep*size_delayed)];
    end
    p = p + 1;
end
%% calculate the fitness function of initialization for which random
% check feasibility
pop_cal = cell2mat(population);
%calculation the fitness function 
pop_modified = zeros(size(pop_cal,1),size(pop_cal,2));
route_pop_decode = cell(size(pop_cal,1),1);
for i = percentage_of_infeasible +1:pmax
    %other init
    routing_pop = pop_cal(i,1:Num_route);
    sep_pop = pop_cal(i,Num_route + 1: Num_route + numBits_sep*Num_truck);
    del_pop = pop_cal(i,Num_route + numBits_sep*Num_truck + 1:end);
    %turn into cell for truck_encode and delayed_encode and processing
%          Num_cell = size(routing_order(i),2)/numBits_sep;
%          Cellsize = repmat(numBits_sep, 1, Num_cell);
    sep_pop_used = mat2cell(sep_pop, size(sep_pop,1), repmat(numBits_sep,1,size(sep_pop,2)/numBits_sep));
    [sep_decode_pop,truck_decode_pop,sep_decode_org_pop] = truckselect(Num_truck,sep_pop_used,Num_route);
    %the same with the truck_encode
    del_pop_used = mat2cell(del_pop,size(del_pop,1), repmat(numBits_sep,1,size(del_pop,2)/numBits_sep));
    [delayed_decode_pop,delayed_decode_feasible_pop] = delayed(Num_route,delayed_yesterday, del_pop_used,size_delayed);
    %routediv
    [route_divide_pop,route_used_pop,truck_decode_pop] = div(sep_decode_pop,routing_pop,delayed_decode_feasible_pop,truck_decode_pop);
    %record truck
    pop_truck{i} = truck_decode_pop;
    %check element in route_used
    feasible_route = feasibleroute(delayed_yesterday, route_used); 
    %Capacity Check
    [capacity_check_pop,~,~,~] = checking(route_used_pop,Capacity_truck_max, Order_route_quantity,truck_decode_pop,Num_product);
    [~,lengths,div_route_check_pop,~] = capacitycheck(truck_decode_pop,route_used_pop, Order_route_quantity, Capacity_truck_min, Capacity_truck_max,Num_product);
    %Time Check
    [~,~,~,~,time_check_feasible_pop,~] = time_check_without_repair(lengths,route_used_pop,earliest_time,latest_time,travel_time);
    pop_route{i} = route_used_pop;
    routing_mat_pop = cell2mat(route_used_pop);
    if capacity_check_pop == 0 && div_route_check_pop == 0 && time_check_feasible_pop == 0 && feasible_route == 0
        feasible_full_pop = 1;
    else
        feasible_full_pop = 0;
    end
    %processing after feasible check - if feasible => calculate profit 
    %profit/infeasible => profit = profit - BigM
    [revenue_pop, employee_cost_pop,distance_travel_pop,travel_cost_pop,profit_pop] = fitnessfunction(routing_mat_pop,Num_product,price_product,Order_route_quantity,truck_decode_pop,employ_cost,route_used_pop,distance,lengths,travelling_cost,sep_decode_pop);
    if feasible_full_pop == 1
        pop_fitness_matrix(i) = profit_pop;
    else 
        pop_fitness_matrix(i) = profit_pop - BigM;
    end
end
toc