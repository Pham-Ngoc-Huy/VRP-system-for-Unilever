function [tabu_record, step_record, array_record] = swaprandom(array_1, rand_case, routing_order, truck_encode, delayed_today_encode, tabulist, tabusize)
    % Initialize records
    numElements = length(array_1);
    tabu_record = zeros(1, numElements);
    recordstep = cell(1, numElements);
    array_record = zeros(numElements, numElements);
    step_record = zeros(numElements, 2);

    % Determine the start and end index for swapping based on rand_case
    if rand_case == 1
        startIndex = 1;
        endIndex = length(routing_order) - 1;
    elseif rand_case == 2
        startIndex = length(routing_order) + 1;
        endIndex = length(routing_order) + length(cell2mat(truck_encode)) - 1;
    elseif rand_case == 3
        startIndex = length(routing_order) + length(cell2mat(truck_encode)) + 1;
        endIndex = numElements - 1;
    end

    % Perform swaps and record
    for i = startIndex:endIndex
        [is_tabu, swappedArray] = performSwapAndCheckTabu(array_1, i, tabulist, tabusize);
        tabu_record(i) = is_tabu;
        array_record(i,:) = swappedArray;
        step_record(i,:) = [i, i+1];
    end
end

function [is_tabu, swappedArray] = performSwapAndCheckTabu(array, index, tabulist, tabusize)
    swappedArray = array;
    swappedArray([index, index+1]) = array([index+1, index]);
    is_tabu = checkTabuCondition(index, tabulist, tabusize);
end

function is_tabu = checkTabuCondition(index, tabulist, tabusize)
    is_tabu = any((tabulist(1:tabusize,1) == index & tabulist(1:tabusize,2) == index+1) | (tabulist(1:tabusize,2) == index & tabulist(1:tabusize,1) == index+1));
end

