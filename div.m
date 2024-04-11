% %% routing divide by separator
function [route_divide,route_used,truck_decode] = div(sep_decode,routing_order,delayed_decode_feasible,truck_decode)
    route_divide = cell(1,length(sep_decode)+1);
    if ~isempty(sep_decode)
        for i = 1:length(sep_decode)
            if i == 1
                route_divide{i} = routing_order(1:sep_decode(i)-1);
            else
                route_divide{i} = routing_order(sep_decode(i-1):sep_decode(i)-1);
            end
            route_divide{end} = routing_order(sep_decode(end):end);
        end
    else
        route_divide = {routing_order};
    end
    route_used = cell(size(route_divide));
    % remove the delayed order today out of the routing
    for i = 1:numel(route_divide)
        currentCell = route_divide{i};
        if any(ismember(currentCell, delayed_decode_feasible))
            route_used{i} = currentCell(~ismember(currentCell, delayed_decode_feasible));
        else
            route_used{i} = currentCell;
        end
    end
    for i = numel(route_used):-1:1
        if all(route_used{i} == 0)
            route_used(i) = [];
            truck_decode(i) = [];
        end
    end
end 


