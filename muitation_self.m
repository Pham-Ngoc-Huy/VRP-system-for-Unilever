function array_x = muitation_self(array_x, start, stop)
    rand_pos_mutation = randi([1, 10]); % Generating a random position for mutation
    if any(rand_pos_mutation == [1, 2, 3])
        rand_pos_switch = randi([start, stop]); % Generating a random position for switching
        if array_x(rand_pos_switch) == 0
            array_x(rand_pos_switch) = 1;
        else
            array_x(rand_pos_switch) = 0;
        end
    end
end
