%% Capacity feasibility check for total quantity of all orders which exclude delayed order for today with total capacity of all trucks.
function [capacity_check,total_capacity_truck,total_capacity_routing,route_check] = checking(route_used,Capacity_truck_max, Order_route_quantity,truck_decode,Num_product)
    total_capacity_truck = 0;
    total_capacity_routing = 0;
    route_check = cell2mat(route_used);
    for j = 1:length(route_used) % use route-used because there is some truck is not being used due to drop the delayed order today out of the rout 
        for k = 1:Num_product 
            total_capacity_truck = total_capacity_truck + Capacity_truck_max(truck_decode(j),k); %valid
        end
    end
    for i = 1:length(route_check)
        for k = 1:Num_product 
            total_capacity_routing = total_capacity_routing + Order_route_quantity(route_check(i),k); %valid
        end
    end
    if total_capacity_truck >= total_capacity_routing
       capacity_check = 0;
    else 
       capacity_check = 1;
    end
end