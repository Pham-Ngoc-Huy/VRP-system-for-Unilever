function child_route = generateChildRoute(route_cell, parent,rand_parent)
    % Pre-calculate sizes to avoid repeated computation
    numRoutes = size(cell2mat(route_cell), 2);

    % Generate random size using more efficient methods
    rand_size_par = round(rand * (numRoutes - 2)) + 1;
    % Generate random starting position
    rand_pos_par = round(random("Uniform",0,numRoutes - rand_size_par)-0.5);
    % Determine if the parents are identical
    identicalParents = isequal(parent{1}, parent{2});

    % Initialize 'child_route' to improve efficiency
    child_route = zeros(1, numRoutes); % Adjust according to the actual data structure

    % Generate 'child_route' based on the conditions
    if identicalParents
        route_remain = route_cell{1,1}(rand_pos_par + 1:(rand_pos_par + rand_size_par));
    else
        route_remain = route_cell{rand_parent,1}(rand_pos_par + 1:(rand_pos_par + rand_size_par));
    end
    
    % Permutation of the remaining route
    %route_permutation = route_remain(randperm(length(route_remain)));
    route_permutation(1:rand_pos_par) = route_cell{rand_parent,1}(1:rand_pos_par);
    
    route_permutation(rand_pos_par + 1: numRoutes - rand_size_par) = route_cell{rand_parent,1}(rand_pos_par + 1 + rand_size_par: end);
    
    order_pos = randperm(length(route_permutation));
    route_permutation = route_permutation(order_pos);
    % Constructing the child route
    % case 1: 
    %child_route(1:rand_pos_par) = route_cell{rand_parent}(1:rand_size_par); 
    %child_route(rand_size_par + 1:end) = route_permutation;
    
    child_route(1:rand_pos_par) = route_permutation(1:rand_pos_par);
    child_route(rand_pos_par + 1: rand_pos_par + rand_size_par) = route_remain;
    child_route(rand_pos_par + 1 + rand_size_par: end) = route_permutation(rand_pos_par + 1: end);
end
