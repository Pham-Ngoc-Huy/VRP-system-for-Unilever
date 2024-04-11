%% Define number of location

%% Time matrix
travelTimes = [
    0, 5, 15, 20, 10, 25, 30, 35;  % A
    5, 0, 10, 15, 5,  20, 25, 30;  % B
    15,10, 0,  5, 10, 5,  10, 15;  % C
    20,15, 5,  0, 15, 10, 5,  10;  % D
    10,5, 10, 15, 0,  15, 20, 25;  % E
    25,20, 5, 10, 15, 0,  5,  10;  % F
    30,25,10, 5, 20, 5,  0,  5;    % G
    35,30,15,10,25, 10, 5,  0      % H
];
min_require = 10;
% processing
clusters = adding(travelTimes, min_require);
mergedClusters = overlappingrecheck(clusters);

for i = 1:length(mergedClusters)
    fprintf('Cluster %d: %s\n', i, mat2str(mergedClusters{i}));
end

%% function
function clusters = adding(travelTimes, min_require)
    numPoints = size(travelTimes,1);
    clusters = cell(numPoints, 1);

    for i = 1:numPoints
        if isempty(clusters{i})
            % Start a new cluster with the current point
            currentCluster = i;

            for j = 1:numPoints
                if travelTimes(i, j) <= min_require && isempty(find([clusters{:}] == j, 1)) && i ~= j 
                    currentCluster = [currentCluster, j];
                    clusters{i} = currentCluster;
                end
            end

            % Update all cluster members to point to the same cluster
            for k = currentCluster
                clusters{k} = currentCluster;
            end
        end
    end
% Remove empty cells and duplicate clusters
% clusters = unique(cellfun(@num2str, clusters, 'UniformOutput', false));
% clusters = cellfun(@str2num, clusters, 'UniformOutput', false);
end
%% Merge overlapping clusters
function mergedClusters = overlappingrecheck(clusters)
    mergedClusters = {};
    while ~isempty(clusters)
        first = clusters{1};
        clusters(1) = [];

        % Check for overlap with the rest of the clusters
        hasOverlap = true;
        while hasOverlap
            hasOverlap = false;
            for i = length(clusters):-1:1
                if ~isempty(intersect(first, clusters{i}))
                    % Merge and remove the overlapping cluster
                    first = union(first, clusters{i});
                    clusters(i) = [];
                    hasOverlap = true;
                end
            end
        end
        mergedClusters{end+1} = first;
    end
end





