%% Extract data from xlsx file
clear; clc;
filename = 'House_31_10_24.xlsx'; 
data = rmmissing(readtable(filename));
% Sample unique city names
citiesNames = unique(data.Var1);  % Adjust according to your table variable names if needed
numOfCities = length(citiesNames);
% Initialize an empty struct to hold matrices
cities = struct();

% Loop through each unique city and extract data as a matrix
for i = 1:numOfCities
    cityName = citiesNames{i};
    
    % Select rows for the current city
    cityData = data(strcmp(data.Var1, cityName), 2:3);
    
    % Convert Var2 (if it's a cell) to numeric
    if iscell(cityData.Var2)
        cityData.Var2 = str2double(regexprep(cityData.Var2, '\s+', ''));
    end
    
    % Convert the table to a matrix after ensuring both columns are numeric
    cities.(cityName) = [cityData.Var2, cityData.Var3];
end
clearvars -except cities numOfCities citiesNames
%% Calculations
citiesChances = struct();
for i_city=1:numOfCities
    mat = cities.(citiesNames{i_city});
    chances_not_to_win = 1;
    for j_lottery=1:size(mat,1)
        chances_not_to_win = chances_not_to_win * (mat(j_lottery,2) - mat(j_lottery,1)) / mat(j_lottery,2);
    end
    citiesChances.(citiesNames{i_city}) = (1 - chances_not_to_win) * 100;
end
%% Sort the struct

% Get field names and values
fieldNames = fieldnames(citiesChances);
values = struct2cell(citiesChances);

% Sort values and get indices
[sortedValues, sortedIndices] = sort(cell2mat(values));
sortedIndices = flip(sortedIndices);
% Reorder field names
sortedFieldNames = fieldNames(sortedIndices);

% Create a new struct with the reordered fields
citiesChancesSorted = orderfields(citiesChances, sortedFieldNames);

clearvars -except citiesChancesSorted






