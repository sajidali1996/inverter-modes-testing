function [slave_ID, combination] = findCombination_BC(inputValue)
    % findCombination_AR Finds the best load combination for AR
    % Syntax:
    %   [Slave-ID, combination] = findCombination_AL(RealPower)
    %
    % Description:
    %   This function finds the best combination of loads to match the 
    %   target value as closely as possible.
    % 
    % Inputs:
    %   RealPower    - load values to set.
    % Outputs:
    %   Slave-ID     - Modbus Slave-ID to select this combination.
    %   combination  - Array of load coil registers to get this load
    % Example
    %   To get 5500W on phase-A call the function as follows
    %   [slave_ID, combination] = findCombination_AR(5500)
    %   this will return:
    %   slave_ID = 1
    %   combination = 3     4     6     7
    % Define the data
    slave_ID=2; % This value comes from programming manual of the equipment
    R = [100, 200, 200, 500, 1000, 1000, 2000, 2000];
    address = [8, 9, 10, 11, 12, 13, 14, 15];
    
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
                combination = address(indices);
                return; % Exact match found
            elseif diff < bestDifference
                bestDifference = diff;
                bestAddresses = address(indices);
            end
        end
    end
    
    % Return closest match
    combination = bestAddresses;
end
