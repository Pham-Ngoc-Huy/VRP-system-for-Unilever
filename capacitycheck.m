%% capacity check - for min and max 
function [route_capacity,lengths,div_route_check,total_quantity] = capacitycheck(truck_decode,route_used, Order_route_quantity, Capacity_truck_min, Capacity_truck_max,Num_product)
    lengths = zeros(1,length(route_used));
    total_quantity = zeros(1,length(route_used));
    for i = 1:length(route_used)
        lengths(i) = numel(route_used{i});
    end
    route_capacity = zeros(length(route_used),Num_product);
    for j = 1:length(route_used)
        % for k = 1:Num_product
        %     route_capacity(i, k) = sum(Order_route_quantity(route_used{i}, k));
        % end
        % total_quantity(i) = sum(route_capacity(i, :),2);  % Calculate total quantity for each route
        % for k = 1:Num_product
            if all(sum(Order_route_quantity(route_used{j},:),1) <= Capacity_truck_max(truck_decode(j),:)) && sum(sum(Order_route_quantity(route_used{j},:),2)) >= Capacity_truck_min(truck_decode(j))
                div_route_check = 0;
            else
                div_route_check = 1;  
                break;
            end
                % if div_route_check == 1
                %    break;  
                % end
        % end
        % 
       
    end
end