run('datasource.m');
truck_decode = [2];
route_used = [11 15 1 18 6 9 4 5];

% Assuming Capacity_truck_min and Order_route_quantity functions are defined
capacity_min = Capacity_truck_min(truck_decode);

% Order_route_quantity matrix
disp('max capacity truck: ');
disp(Capacity_truck_max(truck_decode,:));
disp('capacity order of each product: ');
disp(sum(Order_route_quantity(route_used,:),1));
if all(Capacity_truck_max(truck_decode,:) >= sum(Order_route_quantity(route_used,:),1)) && Capacity_truck_min(truck_decode) <= sum(sum(Order_route_quantity(route_used,:),2))
    feasible = 1;
else
    feasible = 0;
end
disp(feasible)


disp('min capacity truck: ');
disp(capacity_min);
disp('total capacity order: ');
disp(sum(sum(Order_route_quantity(route_used,:),2)));