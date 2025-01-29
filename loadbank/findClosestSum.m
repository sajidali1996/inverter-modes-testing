function result = findClosestSum(inputValue)
    % Define the data
    R = [100, 200, 200, 500, 1000, 1000, 2000, 2000];
    address = [0, 1, 2, 3, 4, 5, 6, 7];
    
    % Get all combinations of indices
    n = numel(R);
    allIndices = 1:n;
    bestDifference = inf;
    bestAddresses = [];
    
    % Loop through all possible subsets
    for subsetSize = 1:n
        combinations = nchoosek(allIndices, subsetSize);
        for i = 1:size(combinations, 1)
            indices = combinations(i, :);
            sumR = sum(R(indices));
            diff = abs(inputValue - sumR);
            if diff == 0
                result = address(indices);
                return; % Exact match found
            elseif diff < bestDifference
                bestDifference = diff;
                bestAddresses = address(indices);
            end
        end
    end
    
    % Return closest match
    result = bestAddresses;
end
