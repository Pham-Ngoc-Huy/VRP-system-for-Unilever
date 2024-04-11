%% Main loop
run('datasource.m')
run('input_parameter.m')
% khởi tạo initialization array
%% quá trình encoding
% tạo chuỗi routing
tic
    time_check_feasible = 1;
    div_route_check = 1;
    capacity_check = 1;
    feasible_route = 1;
    roll = 0;
    routing_order = randperm(Num_route);
    %sep_decode_org = 0;
    % tạo chuỗi delayed today
    delayed_today_encode = delayedtodayencode(Num_route,size_delayed);
    % decode cho delayed_order 
    [delayed_decode,delayed_decode_feasible] = delayed(Num_route,delayed_yesterday, delayed_today_encode,size_delayed);
    while capacity_check == 1 || div_route_check == 1 || feasible_route == 1 || time_check_feasible == 1 
        % tạo chuỗi separator và truck number
          truck_encode = truckencode(Num_truck,Num_route);
        % decode cho sep và truck
          [sep_decode,truck_decode,sep_decode_org] = truckselect(Num_truck,truck_encode,Num_route);
        % tạo chuỗi delayed today
        % decode cho delayed_order 
        % div routing theo separator và bỏ các đơn delayed today
          [route_divide,route_used,truck_decode] = div(sep_decode,routing_order,delayed_decode_feasible,truck_decode);
        % route check when delayed yesterday is in the route yet ?
          feasible_route = feasibleroute(delayed_yesterday, route_used);    
          routing_mat = cell2mat(route_used);
          disp(route_used)
        % Capacity Check
          [capacity_check,total_capacity_truck,total_capacity_routing,route_check] = checking(route_used,Capacity_truck_max, Order_route_quantity,truck_decode,Num_product);
          [route_capacity,lengths,div_route_check,total_quantity] = capacitycheck(truck_decode,route_used, Order_route_quantity, Capacity_truck_min, Capacity_truck_max,Num_product);
        % arrival time bound
          %[upper,lower,earliest,latest,time_check_feasible,route_used] = arrivaltime(lengths,route_used,earliest_time,latest_time,travel_time);
          [arrival_time,time_check_feasible] = time_solu2(route_used,earliest_time,latest_time,travel_time,Order_route_quantity,pick_time);
          if feasible_route == 0 && capacity_check == 0 &&  div_route_check == 0 %&& time_check_feasible == 0 
              disp('Feasible solution found: Approve')
              break;
          else
              disp('Feasible solution found: Check...')
              disp(route_used);
              disp(sep_decode);
              disp(delayed_decode_feasible);
              roll = roll + 1;
              if roll == 10 % trường hợp initialization không cần mất qquas nhiều thời gian để tìm do có ththể chuỗi ở trên infeasible 
                 roll = 0;
                 routing_order = randperm(Num_route);
                 % tạo chuỗi delayed today
                 delayed_today_encode = delayedtodayencode(Num_route,size_delayed);
                 % decode cho delayed_order 
                 [delayed_decode,delayed_decode_feasible] = delayed(Num_route,delayed_yesterday, delayed_today_encode,size_delayed);
               end
 
          end
    end
 toc







