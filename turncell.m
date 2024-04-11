function subarray_cells = turncell(numbit,array_1)

num_subarrays = length(array_1) / numbit;

% Initialize a cell array to store the sub-arrays
subarray_cells = cell(1, num_subarrays);

% Loop through the original array and fill the cell array with sub-arrays
for i = 1:num_subarrays
    % Calculate indices for the sub-array
    start_idx = (i - 1) * numbit + 1;
    end_idx = i * numbit;
    
    % Extract the sub-array and store it in the cell array
    subarray_cells{i} = array_1(start_idx:end_idx);
end