function [arrival_time,time_check_feasible] = time_solu2(object,earliest_time,latest_time,travel_time,Order_route_quantity,pick_time)
    % Assuming other relevant variables (like Order_route_quantity, pick_time, etc.) are defined elsewhere

    % Vectorization for lengths
    lengths = cellfun(@numel, object);

    % Initialize release_time, starting_time, and arrival_time
    release_time = cell(1, length(object));
    starting_time = zeros(1, length(object));
    arrival_time = cell(1, length(object));
    time_check_feasible = 0; % Start with assuming time is feasible

    % Calculate release_time and starting_time
    for i = 1:length(object)
        release_time{i} = arrayfun(@(x) sum(Order_route_quantity(x, :) .* pick_time), object{i});
        starting_time(i) = max(release_time{i});
    end

    % Calculate arrival_time and check feasibility
    for i = 1:length(object)
        for j = 1:lengths(i)
            if j == 1
                arrival_time{i}(j) = starting_time(i) + travel_time(1, object{i}(j) + 1);
            else
                arrival_time{i}(j) = arrival_time{i}(j-1) + travel_time(object{i}(j-1) + 1, object{i}(j) + 1);
            end

            if arrival_time{i}(j) > latest_time(object{i}(j))
                time_check_feasible = 1;
                break; % Exit inner loop
            else
                arrival_time{i}(j) = max(arrival_time{i}(j), earliest_time(object{i}(j)));
            end
        end
        if time_check_feasible == 1 
            break; % Exit outer loop if time is not feasible
        end
    end
end