run('datasource.m');
run('input_parameter.m')
feasible_route = 1;
while feasible_route == 1 
%      truck_number = 1:length(employ_cost);
%      truck_to_use = randperm(numel(truck_number), Num_truck + 1);
%      truck_decode = truck_number(truck_to_use);
%    truck_decode = [7 12];
    truck_decode = randperm(numel(1:Num_truck+1));
    Num_truck_real = length(truck_decode);
    % for truck
    % total_capacity_truck = zeros(1, Num_truck_real);
    % employ_cost = employ_cost(1:Num_truck_real);
    % [max_values, truck_decode] = mink(employ_cost, Num_truck_real);
    % for route_used
    revenue_order = sum(price_product .* Order_route_quantity(1:Num_route, :), 2);

    [sort_revenue, order_position] = maxk(revenue_order, Num_route);
    % find the order that can delayed
    order_can_delayed = setdiff(order_position,delayed_yesterday);
    % sort the order that need to deliver today according to earliest_time
    if ~isempty(delayed_yesterday)
        [sort_earliest_1, order_rush] = sort(earliest_time(delayed_yesterday),"ascend");
        delayed_yesterday = delayed_yesterday(1,order_rush);
    end
    % sort the order that don't need to deliver today according to earliest_time
    [sort_earliest_2,order_not_rush] = sort(earliest_time(order_can_delayed),"ascend");
    order_can_delayed = transpose(order_can_delayed(order_not_rush,:));
    % perform into an complete array
    order = [delayed_yesterday,order_can_delayed];
    
    capacity_sort = sum(Order_route_quantity, 2);
    
    %% Processing assign array
    route_used = cell(1, Num_truck_real); % Initialize the route_used sample
    % Sort nodes in descending order of revenue
    sortedPositions = order;
    
    for i = 1:Num_truck_real
        for j = 1:Num_route
            if isempty(sortedPositions)
                break;
            end
            if j == 1
                route_used{i}(j) = sortedPositions(1);
                sortedPositions(1) = [];
            else
                for k = 1:length(sortedPositions)
                    temp_route = [route_used{i}, sortedPositions(k)];
                    [time_check_feasible,earliest,latest] = checkTimeFeasibility(temp_route, earliest_time, latest_time, travel_time,distance);                    
                    % disp(time_check_feasible)
                    if time_check_feasible == 1
                        [value, route_order_sort] = sort(latest_time(temp_route),"ascend");
                        temp_route = temp_route(route_order_sort);
                        [time_check_feasible,earliest,latest] = checkTimeFeasibility(temp_route, earliest_time, latest_time, travel_time,distance);
                    end
                    % disp(time_check_feasible)
                    if all(Capacity_truck_max(truck_decode(i),:) >= sum(Order_route_quantity(temp_route,:),1))
                        capacity_feasible = 0;
                    else
                        capacity_feasible = 1;
                    end
                    % disp(capacity_feasible)
    
                    if capacity_feasible == 0 && time_check_feasible == 0
                        route_used{i} = temp_route;
                        sortedPositions(k) = [];
                        break;
                    else
                        temp_route = route_used{i};
                    end
                end
            end
        end
        if Capacity_truck_min(truck_decode(i)) > sum(sum(Order_route_quantity(route_used{i},:),2))
            sortedPositions = [sortedPositions,route_used{i}];
            truck_decode(i) = 0;
            route_used{i} = [];
        end
    end
    node_used = cell2mat(route_used);
    delayed_today_order = setdiff(order,node_used);
    
    route_used = route_used(~cellfun('isempty', route_used));
    truck_decode = truck_decode(truck_decode ~= 0);
    if all(~ismember(delayed_yesterday,delayed_today_order)) && length(delayed_today_order) <= size_delayed
        feasible_route = 0;
    else
        feasible_route = 1;
    end
    disp('feasibility - all the delayed yesterday is delivering:')
    disp(feasible_route)
    disp('Route for each truck:')
    disp(route_used)
    disp('Truck used:')
    disp(truck_decode)
end
%% encoding the array back to the right form
routing_order = [node_used,delayed_today_order];
sep_decode = zeros(1,length(truck_decode)-1);
for i = 1:length(truck_decode) - 1
    if i == 1
        sep_decode(i) = (numel(route_used{i}) + 1);
    else
        sep_decode(i) = sep_decode(i-1) + numel(route_used{i});
    end
end
empty_separator_encode = Num_truck - length(sep_decode);
truck_encode_2 = cell(1,empty_separator_encode);
truck_encode_1 = base10to2(sep_decode,numBits_sep);
for i = 1:empty_separator_encode
    rand_apply = round(random("Uniform",1,empty_separator_encode + 1)-0.5);
    if any(rand_apply == 1:length(truck_encode_1))
        truck_encode_2{i} = truck_encode_1{rand_apply};
    else
        truck_encode_2{i} = zeros(1,numBits_sep);
    end
end
truck_encode = [truck_encode_1,truck_encode_2];
delayed_today_encode_1 = base10to2(delayed_today_order,numBits_sep);
%encode lại cho delayed với số lượng bằng 0.4*Num_route
number_delayed_order_left = size_delayed - length(delayed_today_encode_1);
delayed_today_encode_2 = cell(1,number_delayed_order_left);
for j = 1:number_delayed_order_left
    rand_position = round(random("Uniform",1,number_delayed_order_left+1)-0.5);
    if any(rand_position == 1:length(delayed_today_encode_1))
        delayed_today_encode_2{j} = delayed_today_encode_1{rand_position};
    else
        delayed_today_encode_2{j} = zeros(1,numBits_sep);
    end
end
delayed_today_encode = [delayed_today_encode_1,delayed_today_encode_2];
routing_mat = cell2mat(route_used);
lengths = zeros(1,length(route_used));
for i = 1:length(route_used)
    lengths(i) = numel(route_used{i});
end
