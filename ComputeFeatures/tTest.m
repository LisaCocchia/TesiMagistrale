%% t-test
clc
clear all

MEAN_REST = true;

if MEAN_REST
    folder = 'Features_meanRest\';
else
    folder = 'Features_precRest\';
end

addpath '..\CreateDataStructure';
load([folder 'features_GSR_meme.mat']);
load([folder 'features_PPG_meme.mat']);
load('../CreateDataStructure/DataStructure/memesData.mat');
%%
load('../CreateDataStructure/DataStructure/linker.mat');
%%
clc
misogynyLabels = memesData.Misogynous;

outputPath = ['tTest_results\' folder 'GSR\'];
ttestFeatures (features_GSR_meme, linker, outputPath, 'ttest_features_GSR');
outputPath = ['tTest_results\' folder 'PPG\'];
ttestFeatures (features_PPG_meme, linker, outputPath, 'ttest_features_PPG');



%%
function [] = ttestFeatures (features, linker, outputPath, fileName)
    createDirectoryIfNotExists(outputPath);
    misogynous = zeros(size(linker, 1), 1);
    not_misogynous = zeros(size(linker, 1), 1);
    numFields = numel(fieldnames(features));
    paramNames = fieldnames(features);
    
    results.features = string(paramNames);
    results.h = zeros(numFields, 1);
    results.p = zeros(numFields, 1);
    
    for j = 1 : numFields
        featureData = features.(paramNames{j});
        ni = 1;
        mi = 1;
        misogynous = [];
        not_misogynous = [];
    
        for i = 1 : size(linker, 1)
            if linker.memeIDs(i) >= 49
                misogynous(mi) = featureData(i);
                mi = mi + 1;
            else
                not_misogynous(ni) = featureData(i);
                ni = ni + 1;
            end
        end
         % Combine boxplot and statistical analysis
        [h, p, ~, ~] = ttest2(misogynous, not_misogynous);
        figure;
        data_combined = [misogynous, not_misogynous];
        group = [ones(size(misogynous)), 2*ones(size(not_misogynous))];
        boxplot(data_combined, group, 'Labels', {'misogynous', 'not_misogynous'});
        title(paramNames{j}, 'Interpreter', 'none');
        ylabel('Valori della Features');
        savefig(gcf, [outputPath, 'boxplot_', paramNames{j}, '-', fileName, '.fig']);
        saveas(gcf, [outputPath, 'boxplot_', paramNames{j}, '-', fileName, '.png']);
        close(gcf);

        % Store results
        results.h(j) = h;
        results.p(j) = p;
    
        fprintf('%s - h: %d; p: %0.5f\n', string(paramNames{j}), h, p);
    end
    
    resultsTable = struct2table(results);
    save([outputPath  fileName '.mat'], 'resultsTable');
    writetable(resultsTable, [outputPath fileName '.xlsx']);
end