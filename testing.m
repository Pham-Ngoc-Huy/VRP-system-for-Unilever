array_x = [1 0 0 0 1 1 0];
number = length(array_x);
rand_pos_mutation = randi([1, 10]); % Generating a random position for mutation
if any(rand_pos_mutation == [1, 2, 3])
    rand_pos_switch = randi([1, number]); % Generating a random position for switching
    if array_x(rand_pos_switch) == 0
        array_x(rand_pos_switch) = 1;
    else
        array_x(rand_pos_switch) = 0;
    end
end
disp(array_x)

