%% test
%% calculate arrival time 
run("datasource.m")
route_used = {[1 6 9 4 5]};
lengths = zeros(1,length(route_used));
for i = 1:length(route_used)
    lengths(i) = numel(route_used{i});
end
earliest_data = cell(size(route_used));
latest_data = cell(size(route_used));
num_routes = length(route_used);
time_check_feasible = 0;
% take out earliest_time and latest_time
for i = 1:num_routes
    for j = 1:lengths(i)
        latest_data{i}(j) = latest_time(route_used{i}(j));
    end
end
% choosing type of sorting
rand_case = round(random('Uniform',1,10+1) -0.5);
% if rand_case <= 7
%     [route_used,latest_data] = sorted_case1(latest_data,num_routes,route_used); 
% else
%     [route_used,latest_data] = sorted_case2(latest_data,num_routes,route_used);
% end

for i = 1:num_routes
    for j = 1:lengths(i)
        earliest_data{i}(j) = earliest_time(route_used{i}(j));
    end
end
upper = cell(size(route_used));
lower = cell(size(route_used));
latest = cell(size(route_used));
earliest = cell(size(route_used));
% Calculate upper and lower
    for u = 1: num_routes
        upper{u} = zeros(1, lengths(u));
        lower{u} = zeros(1, lengths(u));
        earliest{u}(lengths(u)) = earliest_data{u}(lengths(u)); 
        latest{u}(lengths(u)) = latest_data{u}(lengths(u));
        for j = lengths(u):-1:2
            if distance(route_used{u}(j)+1, route_used{u}(j-1)+1) == 0 && earliest_data{u}(j) == earliest_data{u}(j-1)
               earliest{u}(j-1) = earliest{u}(j);
               latest{u}(j-1) = latest{u}(j);
            else

                lower{u}(j) = earliest{u}(j) - travel_time(route_used{u}(j) + 1, route_used{u}(j -1 ) + 1);
                upper{u}(j) = latest{u}(j)  - travel_time(route_used{u}(j) + 1, route_used{u}(j -1 ) + 1);
                if upper{u}(j) < 0
                    time_check_feasible = 1; 
                    break
                end
                earliest{u}(j-1) = max(lower{u}(j), earliest_data{u}(j-1));
                latest{u}(j-1) = min(upper{u}(j), latest_data{u}(j-1));
            end
            if earliest{u}(j-1) <= latest{u}(j-1)
                time_check_feasible = 0;
            else
                time_check_feasible = 1;
                break
            end
        end

        if time_check_feasible == 1 %sum(sum_of_ones) <= 0 
            time_check_feasible = 1;
            break
        end
    end
disp('Time_feasibility - 0/feasible - 1/infeasible')
disp(time_check_feasible)