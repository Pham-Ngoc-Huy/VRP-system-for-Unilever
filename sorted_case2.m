%% case 2 - inversion route
function [route_used,latest] = sorted_case2(latest,num_routes,route_used)
C = cell(num_routes, 2);
num_routes = length(route_used);

for i = 1:num_routes
    [sorted_latest, index_latest] = sort(latest{i});
    C{i, 1} = sorted_latest;  
    C{i, 2} = route_used{i}(index_latest);
end

route_used = C(:, 2)';
latest = C(:, 1)';
end