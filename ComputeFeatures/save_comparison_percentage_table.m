clc
clear all
MEAN_REST = true;

if MEAN_REST
    root = 'Features_meanRest';
    file_name = 'confronti_features_meanRest.xlsx';
else
    root = 'Features_precRest';
    file_name = 'confronti_features_precRest.xlsx';
end

load(fullfile(root, 'features_GSR_comparison.mat'));
load(fullfile(root, 'features_PPG_comparison.mat'));
load('..\CreateDataStructure\DataStructure\finalQuestResults.mat');
load('..\CreateDataStructure\DataStructure\eprime_data_full.mat');
load('..\CreateDataStructure\DataStructure\workspace_data.mat');
mis = eprimedatafull.Subject_reponse == 1;
notMis = eprimedatafull.Subject_reponse == 2;
offensive = finalQuestResults.Offensive == 1;
notOffensive = finalQuestResults.Offensive == 2;
troublesome = finalQuestResults.Nuisance == 1;
notTroublesome = finalQuestResults.Nuisance == 2;
funny = eprimedatafull.questionTrialRESP == 1;
notFunny = eprimedatafull.questionTrialRESP == 2;
anger = finalQuestResults.Anger >= 3;
disgust = finalQuestResults.Disgust >= 3;
sadness = finalQuestResults.Sadness >= 3;


female = eprimedatafull.Sex == 'female';
male = eprimedatafull.Sex == 'male';

shaming = finalQuestResults.MemeCategory1 == 1 | finalQuestResults.MemeCategory2 == 1;
stereotipe = finalQuestResults.MemeCategory1 == 2 | finalQuestResults.MemeCategory2 == 2;
objectification = finalQuestResults.MemeCategory1 == 3 | finalQuestResults.MemeCategory2 == 3;
violence = finalQuestResults.MemeCategory1 == 4 | finalQuestResults.MemeCategory2 == 4;

maxIntensity = finalQuestResults.LevOfMisogyny == 3;

%%

% Esempio di utilizzo per GSR
features_GSR_comparison_table = struct2table(features_GSR_comparison);
calculateAndWritePercentages(root, file_name, features_GSR_comparison_table, 'features_comp', 'A1');

% Esempio di utilizzo per PPG
features_PPG_comparison_table = struct2table(features_PPG_comparison);
calculateAndWritePercentages(root, file_name, features_PPG_comparison_table, 'features_comp', 'A6');
%%
index = find(finalQuestResults.Misogyny == 1);
% Esempio di utilizzo per GSR
features_GSR_mis_comparison_table = features_GSR_comparison_table(index,:);
calculateAndWritePercentages(root, file_name, features_GSR_mis_comparison_table, 'features_comp_MIS', 'A1');

% Esempio di utilizzo per PPG
features_PPG_mis_comparison_table = features_PPG_comparison_table(index,:);
calculateAndWritePercentages(root, file_name, features_PPG_mis_comparison_table, 'features_comp_MIS', 'A6');

%%
index_funny = find(memeRatings.questionTrialRESP == 1);
% Esempio di utilizzo per GSR
features_GSR_funny_comparison_table = features_GSR_comparison_table(index_funny,:);
calculateAndWritePercentages(root, file_name, features_GSR_funny_comparison_table, 'features_comp_FUNNY', 'A1');

% Esempio di utilizzo per PPG
features_PPG_funny_comparison_table = features_PPG_comparison_table(index_funny,:);
calculateAndWritePercentages(root, file_name, features_PPG_funny_comparison_table, 'features_comp_FUNNY', 'A6');

%%
index_f_vio_troub_off = find(female & (violence | troublesome | offensive));
% Esempio di utilizzo per GSR
features_GSR_features_GSR_f_vio_off = features_GSR_comparison_table(index_f_vio_troub_off,:);
calculateAndWritePercentages(root, file_name, features_GSR_features_GSR_f_vio_off, 'features_f_vio_off', 'A1');

% Esempio di utilizzo per PPG
features_PPGfeatures_GSR_f_vio_off = features_PPG_comparison_table(index_f_vio_troub_off,:);
calculateAndWritePercentages(root, file_name, features_PPGfeatures_GSR_f_vio_off, 'features_f_vio_off', 'A6');




%% 
function calculateAndWritePercentages(root, file_name, features_comparison_table, sheet_name, startsCell)

    [num_rows, num_cols] = size(features_comparison_table);

    greater_than_zero = zeros(1, num_cols);
    lower_than_zero = zeros(1, num_cols);
    equal_zero = zeros(1, num_cols);
    % Calcola la percentuale di valori maggiori e minori di zero per ogni colonna
    for col = 1:num_cols

        column_data = features_comparison_table{:, col};
        count_error =  sum(column_data == -1 | isnan(column_data));

        count_greater_than_zero = sum(column_data > 0);
        count_lower_than_zero =  sum(column_data <= 0 & column_data ~=-1);

        num = num_rows - count_error;

        greater_than_zero(col) = count_greater_than_zero / num;
        lower_than_zero(col) = count_lower_than_zero / num;

        % count_greater_than_zero = sum(column_data > 0);
        % count_equal_zero =  sum(column_data == 0 | column_data == -1);
        % count_lower_than_zero =  sum(column_data < 0 & column_data ~= -1);
        % 
        % greater_than_zero(col) = count_greater_than_zero / num_rows;
        % equal_zero(col) = count_equal_zero / num_rows;
        % lower_than_zero(col) = count_lower_than_zero / num_rows;
    end

    % Scrivi i risultati in una tabella
    variableNames = features_comparison_table.Properties.VariableNames;
    % results = [greater_than_zero; equal_zero; lower_than_zero];
    % results = array2table(results, 'VariableNames', variableNames);
    % results.Properties.RowNames = {'greater_than_zero', 'equal_zero', 'lower_than_zero'};

    results = [greater_than_zero; lower_than_zero];
    results = array2table(results, 'VariableNames', variableNames);
    results.Properties.RowNames = {'greater_than_zero', 'lower_than_zero'};

    % Scrivi la tabella in un file Excel
    writetable(results, file_name, 'Sheet', sheet_name, 'WriteRowNames', true, 'Range', startsCell);
end