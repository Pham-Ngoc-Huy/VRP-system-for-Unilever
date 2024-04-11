function [location,t1,t2,x_best, x_result, x_route] = localoptimization(profit_matrix,step_record,array_record,array_route_decode)
    location = find(profit_matrix == max(profit_matrix));
    %disp(location);
    rand_solu = round(random('Uniform',1,length(location)+1)-0.5);
    location_new = location(rand_solu);
    %disp(location_new)
    t1 = step_record(location_new,1);
    t2 = step_record(location_new,2);
    x_best = array_record(location_new,:);
    x_result = profit_matrix(location_new,:);
    x_route = array_route_decode{location_new};
end