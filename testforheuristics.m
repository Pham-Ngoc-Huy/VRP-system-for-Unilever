run('datasource.m')
run('input_parameter.m')
route_used = {[11 15 1 18 6 9 4 5]};
routing_mat = cell2mat(route_used);
truck_decode = [2];
sum_price_product = zeros(1,Num_product);
sum_employ_cost = zeros(1,length(truck_decode));
distance_travel = cell(size(route_used));
% revenue calculated
for i = 1:length(routing_mat)
    for m = 1:Num_product
        sum_price_product(i,m) = sum(price_product(m)*Order_route_quantity(routing_mat(i),m));
    end
end
revenue = sum(sum(sum_price_product));
% travel cost calculated
for i = 1:length(route_used)
    for j = 1:numel(route_used{i})+1
        if j == 1
            distance_travel{i}(j) = distance(1, route_used{i}(j) + 1);
        elseif j == numel(route_used{i}) + 1
            distance_travel{i}(j) = distance(route_used{i}(j-1) + 1, 1);
        else
            distance_travel{i}(j) = distance(route_used{i}(j-1) + 1, route_used{i}(j) + 1);
        end
    end
end
distance_travel = cell2mat(distance_travel);
travel_cost = travelling_cost*sum(distance_travel);
% employee cost calculated
for k = 1:(length(truck_decode))
    sum_employ_cost(k) = sum(employ_cost(truck_decode(k)));
end
employee_cost = sum(sum_employ_cost);
% profit calculated
profit = revenue - travel_cost - employee_cost;
disp(profit)
disp(revenue)
disp(travel_cost)
disp(employee_cost)