function finalQuestResults = getFinalQuestResults(finalQuestPath)
    finalQuestResults = readtable(finalQuestPath, 'VariableNamingRule', 'preserve');
    finalQuestResults.Properties.VariableNames = regexprep(finalQuestResults.Properties.VariableNames, '[àáâãäå]', 'a');
    finalQuestResults.Properties.VariableNames = matlab.lang.makeValidName(finalQuestResults.Properties.VariableNames);
    columnsToExclude = {'ParticipantCode', 'MisogynyDatasetLabel', 'DatasetCategory'};
    finalQuestResults = finalQuestResults(:, ~ismember(finalQuestResults.Properties.VariableNames, columnsToExclude));
end