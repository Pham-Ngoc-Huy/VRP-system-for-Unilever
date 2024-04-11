%% time check feasible for heuristics

function [time_check_feasible,earliest,latest] = checkTimeFeasibility(route, earliest_time, latest_time, travel_time,distance)
    % Initialize variables
    num_locations = numel(route);
    earliest = zeros(1, num_locations);
    latest = zeros(1, num_locations);

    % Assign earliest and latest times for each location in the route
    for j = 1:num_locations
        earliest(j) = earliest_time(route(j));
        latest(j) = latest_time(route(j));
    end

    % Check time feasibility
    time_check_feasible = 0;
    for j = num_locations:-1:2
        if distance(route(j)+1, route(j-1)+1) == 0 && earliest(j) == earliest(j-1)
           earliest(j-1) = earliest(j);
           latest(j-1) = latest(j);
        else
            travelTimeToNext = travel_time(route(j-1)+1, route(j)+1);
            earliestArrival = earliest(j) - travelTimeToNext;
            latestArrival = latest(j) - travelTimeToNext;
            % Update earliest and latest times
            earliest(j-1) = max(earliest(j-1), earliestArrival);
            latest(j-1) = min(latest(j-1), latestArrival);
        end
          if earliest(j-1) > latest(j-1)
            time_check_feasible = 1;
            break;
          end
    end
end
