function [pop_fitness_matrix,route_used_pop,sep_decode_pop,truck_decode_pop] = calculateFitness(child_sep, child_del, child_route, Num_route,Num_truck, numBits_sep, Capacity_truck_max, Capacity_truck_min,Order_route_quantity, Num_product, price_product, employ_cost, distance, travelling_cost, earliest_time, latest_time, travel_time, BigM, size_delayed, delayed_yesterday)
         % Decoding and processing
        sep_pop_used = mat2cell(child_sep, size(child_sep, 1), repmat(numBits_sep, 1, size(child_sep, 2) / numBits_sep));
        [sep_decode_pop, truck_decode_pop, ~] = truckselect(Num_truck, sep_pop_used, Num_route);
        
        del_pop_used = mat2cell(child_del, size(child_del, 1), repmat(numBits_sep, 1, size(child_del, 2) / numBits_sep));
        
        [~, delayed_decode_feasible_pop] = delayed(Num_route, delayed_yesterday, del_pop_used, size_delayed);
        [~, route_used_pop, truck_decode_pop] = div(sep_decode_pop, child_route, delayed_decode_feasible_pop, truck_decode_pop);
        % Capacity Check
        [capacity_check_pop, ~, ~, ~] = checking(route_used_pop, Capacity_truck_max, Order_route_quantity, truck_decode_pop, Num_product);
        [~, lengths, div_route_check_pop, ~] = capacitycheck(truck_decode_pop, route_used_pop, Order_route_quantity, Capacity_truck_min, Capacity_truck_max, Num_product);
        [~, ~, ~, ~, time_check_feasible_pop, route_used_pop] = time_check_without_repair(lengths, route_used_pop, earliest_time, latest_time, travel_time);
         
        % Convert cell array to matrix for further processing
        routing_mat_pop = cell2mat(route_used_pop); 
        % Feasibility Check
        if capacity_check_pop == 0 && div_route_check_pop == 0 && time_check_feasible_pop == 0
            feasible_full_pop = 1;
        else
            feasible_full_pop = 0;
        end      
        % Calculate Profit
        [~, ~, ~, ~, profit_pop] = fitnessfunction(routing_mat_pop, Num_product, price_product, Order_route_quantity, truck_decode_pop, employ_cost, route_used_pop, distance, lengths, travelling_cost, sep_decode_pop);
        % Update Fitness Matrix
        if feasible_full_pop == 1
            pop_fitness_matrix = profit_pop;
        else
            pop_fitness_matrix = profit_pop - BigM;
        end
end