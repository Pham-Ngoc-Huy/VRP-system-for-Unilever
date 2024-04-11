%% calculate arrival time 
function [upper,lower,earliest,latest,time_check_feasible,route_used] = time_check_without_repair(lengths,route_used,earliest_time,latest_time,travel_time)
earliest_data = cell(size(route_used));
latest_data = cell(size(route_used));
num_routes = length(route_used);
time_check_feasible = 0;
% take out earliest_time and latest_time
for i = 1:num_routes
    for j = 1:lengths(i)
        latest_data{i}(j) = latest_time(route_used{i}(j));
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
            lower{u}(j) = earliest{u}(j) - travel_time(route_used{u}(j) + 1, route_used{u}(j -1 ) + 1);
            upper{u}(j) = latest{u}(j)  - travel_time(route_used{u}(j) + 1, route_used{u}(j -1 ) + 1);
            if upper{u}(j) < 0
                time_check_feasible = 1; 
                break
            end
            earliest{u}(j-1) = max(lower{u}(j), earliest_data{u}(j-1));
            latest{u}(j-1) = min(upper{u}(j), latest_data{u}(j-1));
            if earliest{u}(j-1) <= latest{u}(j-1)
                time_check_feasible = 0;
            else
                time_check_feasible = 1;
                break
            end
    end
    if time_check_feasible == 1 
        time_check_feasible = 1;
        break
    end
end
end