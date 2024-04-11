numRuns = 30; 
results = zeros(numRuns, 3); 

for runIdx = 1:numRuns
    clearvars -except numRuns results runIdx;
    tic;
    run('GAmode.m'); 
    runtime = toc;    
    results(runIdx, :) = [runIdx, sort_pop_fitness_matrix(pmax), runtime];
end

% Export the results to an Excel file
filename = 'results.xlsx';
writematrix(results, filename, 'Sheet', 1, 'Range', 'A1');

disp(['Results have been written to ', filename]);
