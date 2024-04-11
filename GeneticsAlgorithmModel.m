run("initializationforGA.m");
tic
%% sort fitness population in descend
[sort_pop_fitness_matrix,location_sort] = sort(pop_fitness_matrix,"ascend");
sort_population = pop_cal(location_sort,:);
sort_pop_truck = pop_truck(location_sort);
sort_pop_route = pop_route(location_sort);

%% selection
figure;
yyaxis left;
ax1 = gca;
lineObj1 = animatedline('Color', 'b', 'Marker', 'o', 'LineStyle', '-');
xlabel('X1: Iteration Count');
ylabel('Y1: Profit Values');

iter_GA = 1;
while iter_GA <= Number_of_GA_Iteration
    disp(['Iteration-GA: ' num2str(iter_GA)]);
    disp(sort_pop_route);
    cell_in = population;
    disp(cell_in)
    %% init
    chil = zeros(child_set,size(cell2mat(population),2));
    truck = cell(child_set,1);
    solu = zeros(child_set,1);
    rou = cell(child_set,1);
    for c = 1:child_set % case that want to adjust the child_set / but in this case just create one child only so child_set = 1
        %disp(['Iteration-chil-set: ' num2str(c)]);
        parent = selection(pmax,cell_in);
        %% split route - separator - delayed matrix
        [route_cell,delayed_cell,separator_cell] = split_component(parent,Num_route,Num_truck,numBits_sep);
        %% cross-over
        % cross over routing
        rand_pos_par = round(random("Uniform",1,size(cell2mat(route_cell), 2)-2+1)-0.5); 
        rand_parent = round(random("Uniform",1,size(parent,1)+1)-0.5);
        if isequal(parent{1},parent{2})
                route_remain = route_cell{1}(rand_pos_par + 1:end);
                route_permuitation = route_remain(randperm(length(route_remain)));
                child_route = [route_cell{1}(1:rand_pos_par),route_permuitation];
        else
            if rand_parent == 1
                route_remain = route_cell{1,1}(rand_pos_par + 1:end);
                route_permuitation = route_remain(randperm(length(route_remain)));
                child_route = [route_cell{1}(1:rand_pos_par),route_permuitation];
            else
                route_remain = route_cell{2,1}(rand_pos_par + 1:end);
                route_permuitation = route_remain(randperm(length(route_remain)));
                child_route = [route_cell{2}(1:rand_pos_par),route_permuitation];
            end
        end
        % cross over separator
        rand_pos_sep = round(size(cell2mat(separator_cell),2)/2); %round(random("Uniform",1,size(cell2mat(separator_cell),2)+1)-0.5); 
        child_sep = [separator_cell{1}(1:rand_pos_sep),separator_cell{2}(1:length(separator_cell{1}(rand_pos_sep+1:end)))];
        % cross over delayed_order
        rand_pos_delayed = round(size(cell2mat(delayed_cell),2)/2);  %round(random("Uniform",1,size(cell2mat(delayed_cell),2)+1)-0.5); 
        child_del = [delayed_cell{1}(1:rand_pos_delayed),delayed_cell{2}(1:length(delayed_cell{1}(rand_pos_delayed+1:end)))];
        
        %% muitation for full array - tabu applying - and calculate the fitnessfunction
        array_child = [child_route,child_sep,child_del];
        [init_profit,route_used_init,sep_decode_init,truck_decode_init] = calculateFitness(array_child, Num_route,Num_truck, numBits_sep, Capacity_truck_max, Capacity_truck_min,Order_route_quantity, Num_product, price_product, employ_cost, distance, travelling_cost, earliest_time, latest_time, travel_time, BigM, size_delayed, delayed_yesterday,1,1);
        %record solution
        global_fitness = init_profit;
        init_route = route_used_init;
        init_truck = truck_decode_init;
        global_route = route_used_init;
        global_truck = truck_decode_init;
        global_routing = array_child;
        
        % initial define
        tabulist = zeros(tabusize,tabusize);
        solutionrecord = zeros(Number_outer_loop_muitation,1);
        solutionrecord_inner = zeros(Number_outer_loop_muitation,Number_inner_loop);
        solutionmatrix_inner = zeros(Number_outer_loop_muitation,Number_inner_loop);
        
        iter_outer = 1;
        % start outer loop
        while iter_outer <= Number_outer_loop_muitation
            array_sample = array_child;
            %disp(['Iteration-outer-muitation: ' num2str(iter_outer)]);
            rand_part = round(random('Uniform',1,3+1)-0.5);
            % start inner loop
            for inner = 1:Number_inner_loop
                % init for swap
                array_inner = array_sample;
                routing_order = array_inner(1,1:Num_route);
                truck_encode = mat2cell(array_inner(1,Num_route + 1: Num_route + numBits_sep*Num_truck),1);
                delayed_today_encode = mat2cell(array_inner(1, Num_route + numBits_sep*Num_truck + 1:end),1);
                %disp(['Iteration-inner-muitation: ' num2str(inner)]);
                [tabu_record, step_record, array_record] = swaprandom(array_inner, rand_part, routing_order, truck_encode, delayed_today_encode, tabulist, tabusize);           
                % remove tabu and full zeros rows
                is_tabu_location = find(tabu_record == 1);
                array_record(is_tabu_location,:) = [];
                step_record(is_tabu_location,:) = [];
                rows_to_remove_step = all(step_record == 0,2);
                rows_to_remove_array = all(array_record == 0,2);
                array_record = array_record(~rows_to_remove_array, :);
                if isempty(array_record)
                    %array_record = array_inner; 
                    % or increase outer loop one more time
                    array_child = array_inner;
                    break
                end
                step_record = step_record(~rows_to_remove_step, :);
                profit_matrix = zeros(size(array_record,1),1);
                % transform and calculate fitness function
                % init for array_modified
                array_modified = zeros(size(array_record,1),length(array_inner));
                % init for matrix route_used_decode
                array_route_decode = cell(size(array_record,1),1);
                % processing the neighbor 
                for i = 1:size(array_record,1)
                    % other init
                    routing_order_1 = array_record(i,1:Num_route);
                    truck_encode_1 = array_record(i,Num_route + 1: Num_route + numBits_sep*Num_truck);
                    delayed_encode_today_1 = array_record(i,Num_route + numBits_sep*Num_truck + 1:end);
                    %turn into cell for truck_encode and delayed_encode and processing
                         % Num_cell = size(routing_order(i),2)/numBits_sep;
                         % Cellsize = repmat(numBits_sep, 1, Num_cell);
                    truck_sep_used = mat2cell(truck_encode_1, size(truck_encode_1,1), repmat(numBits_sep,1,size(truck_encode_1,2)/numBits_sep));
                    [sep_decode,truck_decode,sep_decode_org] = truckselect(Num_truck,truck_sep_used,Num_route);
                    % the same with the truck_encode
                    delayed_used = mat2cell(delayed_encode_today_1,size(delayed_encode_today_1,1), repmat(numBits_sep,1,size(delayed_encode_today_1,2)/numBits_sep));
                    if isempty(delayed_used) 
                        delayed_decode_feasible = 0;
                    else
                        [delayed_decode,delayed_decode_feasible] = delayed(Num_route,delayed_yesterday, delayed_used,size_delayed);
                    end
                    % routediv
                    [route_divide,route_used,truck_decode] = div(sep_decode,routing_order_1,delayed_decode_feasible,truck_decode);
                    % check element in route_used
                    feasible_route = feasibleroute(delayed_yesterday, route_used);    
                    % Capacity Check
                    [capacity_check,total_capacity_truck,total_capacity_routing,route_check] = checking(route_used,Capacity_truck_max, Order_route_quantity,truck_decode,Num_product);
                    [route_capacity,lengths,div_route_check,total_quantity] = capacitycheck(truck_decode,route_used, Order_route_quantity, Capacity_truck_min, Capacity_truck_max,Num_product);
                    % Time Check
                    [upper,lower,earliest,latest,time_check_feasible,route_used] = arrivaltime(lengths,route_used,earliest_time,latest_time,travel_time, distance);
                    routing_mat = cell2mat(route_used);
                    % collect array after modified in time_check
                    % collect route_used matrix to define global_route
                    array_route_decode{i} = route_used;
                    array_modified(i,:) = [routing_mat,delayed_decode_feasible,cell2mat(truck_sep_used),cell2mat(delayed_used)];
                    [revenue, employee_cost,distance_travel,travel_cost,profit] = fitnessfunction(routing_mat,Num_product,price_product,Order_route_quantity,truck_decode,employ_cost,route_used,distance,lengths,travelling_cost,sep_decode);
                    % feasible check 
                    if feasible_route == 0 && capacity_check == 0 && div_route_check == 0 && time_check_feasible == 0
                        profit_matrix(i) = profit;
                    else
                        profit_matrix(i) = profit - BigM;
                    end
                end
                [location_new,t1,t2,x_best,x_result,x_route] = localoptimization(profit_matrix,step_record,array_modified,array_route_decode);
                % after calculate the fitness function => if > globalfitness/update into the global
                if x_result >= global_fitness
                    global_fitness = x_result;
                    global_route = x_route;
                    global_routing = x_best;
                    global_truck = truck_decode;
                end
                %update tabulist
                [tabulist] = updatetabulist(tabusize,tabulist,t1,t2);
                %update new result and truck and route array
                solutionrecord_inner(iter_outer,inner) = x_result;
                array_sample = x_best;
            end
            array_child = global_routing;
            % solutionroute{iter_outer} = route_used;
            solutionrecord(iter_outer) = global_fitness;
            iter_outer = iter_outer + 1;
        end
        % record the solution 
        chil(c,:) = global_routing;
        truck{c} = global_truck;
        solu(c,1) = global_fitness;
        rou{c} = global_route;
    end
    %% collect and sorting  
    [sort_solu,elitism_loca] = sort(solu,"descend");
    sort_chil = chil(elitism_loca,:);
    sort_truck = truck(elitism_loca);
    sort_route = rou(elitism_loca);
    %% elitism and replacement
    [sort_pop_fitness_matrix,sort_pop_route,sort_population,sort_pop_truck] = elitism(sort_pop_fitness_matrix,sort_pop_route,sort_pop_truck,sort_population,sort_solu,sort_chil,sort_truck,sort_route,child_set);
    %update the pop_cal
    pop_cal = sort_population;
    fix = cell(pmax,1);
    for i = 1:size(pop_cal,1)
        fix{i} = pop_cal(i,:);
    end
    disp(sort_pop_fitness_matrix)
    disp(sort_pop_truck);
    % attach to the new population var for the next loop using
    population = fix;
    best_solution = sort_pop_fitness_matrix(pmax,1);
    %% plot
    addpoints(lineObj1, iter_GA, best_solution);
    drawnow;
    iter_GA = iter_GA + 1;
end
toc





