tic
run('datasource.m')
run('input_parameter.m')
%run('InitializationforTabu.m')
run('Heuristics')
% truck_encode = {[0 0 0 0]   [1 1 0 0]    [1 0 1 1]    [1 0 1 1]    [1 0 1 1]    [1 1 1 0]};
% routing_order = [8  11  2  4  12  3  5  6  1  9  7  10];
% delayed_yesterday = [2 3 4];
% delayed_today_encode = {[0 1 0 1]    [0 0 0 1]    [1 0 1 0]    [0 1 1 1]    [0 1 0 0]};

figure;
yyaxis left;
ax1 = gca;
lineObj1 = animatedline('Color', 'b', 'Marker', 'o', 'LineStyle', '-');
xlabel('X1: Iteration Count');
ylabel('Y1: Profit Values');
iter = 1;

% initial fitnessfunction
[revenue_init, employee_cost_init,distance_travel_init,travel_cost_init,profit_init] = fitnessfunction(routing_mat,Num_product,price_product,Order_route_quantity,truck_decode,employ_cost,route_used,distance,lengths,travelling_cost,sep_decode);

% tabu_applying
array_1 = [routing_order, cell2mat(truck_encode), cell2mat(delayed_today_encode)];

%record solution
global_fitness = profit_init;
init_route = route_used;
init_truck = truck_decode;
global_route = route_used;
global_truck = truck_decode;
global_routing = array_1;

% initial define
tabulist = zeros(tabusize,tabusize);
solutionrecord = zeros(Number_Iteration,1);
solutionrecord_inner = zeros(Number_Iteration,Number_inner_loop);
solutionmatrix_inner = zeros(Number_Iteration,Number_inner_loop);


% start outer loop
while iter <= Number_Iteration
    array_sample = array_1;
    feasible_matrix = zeros(Number_inner_loop,1);
    disp(['Iteration-outer: ' num2str(iter)]);
    rand_part = round(random('Uniform',1,3+1)-0.5);
    disp("rand_part:")
    disp(rand_part)
    % start inner loop
    for inner = 1:Number_inner_loop
        array_inner = array_sample;
        % define lại cái routing_order,truck_encode, delayed_today_encode
        routing_order = array_inner(1,1:Num_route);
        truck_encode = mat2cell(array_inner(1,Num_route + 1: Num_route + numBits_sep*Num_truck),1);
        delyed_today_encode = mat2cell(array_inner(1, Num_route + numBits_sep*Num_truck + 1:end),1);
%         disp(['Iteration-inner: ' num2str(inner)]);
        [tabu_record, step_record, array_record] = swaprandom(array_inner, rand_part, routing_order, truck_encode, delayed_today_encode, tabulist, tabusize);
      
        % remove tabu and full zeros rows
        is_tabu_location = find(tabu_record == 1);
        array_record(is_tabu_location,:) = [];
        step_record(is_tabu_location,:) = [];
        rows_to_remove_step = all(step_record == 0,2);
        rows_to_remove_array = all(array_record == 0,2);
        array_record = array_record(~rows_to_remove_array, :);
        
        % handle the case that if the array_record is empty, this case
        % happen when the previous rand case  is equal to the following
        % rand case when the inner loop is cover all the tabu - step 
        % for example, inner loop 2 , and the rand-case = 2, and the
        % tabulist of the previous is [ 6,7 ; 7,8 ] and the following loop
        % is the same with previous , it will gain conflict, 
        % this may be gain local trap when it keep repeat
       
%         if isempty(array_record)
%             %array_record = array_inner; 
%             % or increase outer loop one more time
%             array_1 = array_inner;
%             break
%         end

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
            routing_order_1 = array_record(i,1:length(routing_order));
            truck_encode_1 = array_record(i,length(routing_order)+1: length(routing_order)+length(cell2mat(truck_encode)));
            delayed_encode_today_1 = array_record(i,length(routing_order) + length(cell2mat(truck_encode)) + 1: length(routing_order) + length(cell2mat(truck_encode)) + length(cell2mat(delayed_today_encode)));
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
            if feasible_route == 1
                feasible_full = 0;
            % Capacity Check
            else
              [capacity_check,total_capacity_truck,total_capacity_routing,route_check] = checking(route_used,Capacity_truck_max, Order_route_quantity,truck_decode,Num_product);
%             disp("Capcity_check_truck: 1/infeasible - 0/feasible")
%             disp(capacity_check)
                if capacity_check == 1
                    feasible_full = 0;
                else
                    [route_capacity,lengths,div_route_check,total_quantity] = capacitycheck(truck_decode,route_used, Order_route_quantity, Capacity_truck_min, Capacity_truck_max,Num_product);
    %                 disp("Capacity_check: 1/infeasible - 0/feasible")
    %                 disp(div_route_check)
                    if div_route_check == 1
                        feasible_full = 0;
                    else
                        % Time Check
                        [upper,lower,earliest,latest,time_check_feasible,route_used] = arrivaltime(lengths,route_used,earliest_time,latest_time,travel_time,distance);
    %                     disp("Time_check: 1/infeasible - 0/feasible")
    %                     disp(time_check_feasible)
                        if time_check_feasible == 1
                            feasible_full = 0;
                        else
                            feasible_full = 1;
                        end
                    end
                end
            end
            routing_mat = cell2mat(route_used);
            % collect array after modified in time_check
            array_modified(i,:) = [routing_mat,delayed_decode_feasible,cell2mat(truck_sep_used),cell2mat(delayed_used)];
            % collect route_used matrix to define global_route
            array_route_decode{i} = route_used;
            % feasible check 
%             if feasible_route == 0 && capacity_check == 0 && div_route_check == 0 && time_check_feasible == 0
%                 feasible_full = 1;
%             else
%                 feasible_full = 0;
%             end
            % processing after feasible check - if feasible => calculate profit/infeasible => profit = 0
            if feasible_full == 1
                [revenue, employee_cost,distance_travel,travel_cost,profit] = fitnessfunction(routing_mat,Num_product,price_product,Order_route_quantity,truck_decode,employ_cost,route_used,distance,lengths,travelling_cost,sep_decode);
                profit_matrix(i) = profit;
            else 
                profit_matrix(i) = 0;
            end
        end
        % condition for all the swap matrix is infeasible solution
        if all(profit_matrix == 0)
             r1 = round(random("Uniform",1,size(array_modified,1)+1)-0.5);
             array_sample = array_record(r1,:);
%             disp('No feasible found')
            % disp(r1)
            % disp(array_1)
        % if there is still 1 or more feasible solution
        else
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
            disp(tabulist)
            %update new result and truck and route array
            solutionrecord_inner(iter,inner) = x_result;
            array_sample = x_best;
            disp(x_best)
            disp(x_result)
        end
    end
%     escape = round(random("Uniform",1,2+1)-0.5);
%     if escape == 1
        array_1 = global_routing;
%     else
%         array_sample = x_best;
%     end
    solutionroute{iter} = route_used;
    solutionrecord(iter) = global_fitness;
    %% plot
    addpoints(lineObj1, iter, global_fitness);
    drawnow;
    iter = iter + 1;
end
toc