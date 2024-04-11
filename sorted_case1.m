%% case 1 - inversion route
function [route_used,latest] = sorted_case1(latest,num_routes,route_used)
location = zeros(1,num_routes);
num_routes = length(route_used);
for i = 1:num_routes
    [~, maxIndex] = max(latest{i}(1,:));
    location(i) = maxIndex;  
    [latest{i}(maxIndex), latest{i}(end)] = deal(latest{i}(end), latest{i}(maxIndex));   
    [route_used{i}(maxIndex), route_used{i}(end)] = deal(route_used{i}(end), route_used{i}(maxIndex));
end
end