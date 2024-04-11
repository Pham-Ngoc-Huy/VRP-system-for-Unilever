function feasible_route = feasibleroute(delayed_yesterday, route_used)    
    if all(ismember(delayed_yesterday, cell2mat(route_used)))
        feasible_route = 0;  
    else
        feasible_route = 1; 
    end
end