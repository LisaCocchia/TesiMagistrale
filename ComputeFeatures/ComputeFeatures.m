clear all

addpath '..\CreateDataStructure';
load('..\CreateDataStructure\DataStructure\workspace_data.mat');
load('..\CreateDataStructure\DataStructure\eprime_data_full.mat');

SAMPLE_FREQ = 128;

MEAN_REST = false;
FULL_REST = false;

if MEAN_REST & FULL_REST
    outputPath = 'Features_meanRest\';
elseif ~MEAN_REST & FULL_REST
    outputPath = 'Features_precRest\';
elseif MEAN_REST & ~FULL_REST
    outputPath = 'Features_meanRest_15sec\';
else% ~MEAN_REST & ~FULL_REST
    outputPath = 'Features_precRest_15sec\';
end
createDirectoryIfNotExists(outputPath);

%% Calcola le features GSR
features_GSR_meme = computeFeaturesGSR(physiologicalDataTable(:,1:3), SAMPLE_FREQ, '');
if FULL_REST
    features_GSR_rest = computeFeaturesGSR(physiologicalDataTable(:,5:7), SAMPLE_FREQ, '');
else
    features_GSR_rest = computeFeaturesGSR(physiologicalDataTable(:,9:11), SAMPLE_FREQ, '');
end

% Make comparison
if MEAN_REST
    mean_features_GSR_rest = calculate_struct_average(features_GSR_rest);
    features_GSR_comparison = compareFeaturesMean(features_GSR_meme, mean_features_GSR_rest);
    save([outputPath 'mean_features_GSR_rest.mat'], 'mean_features_GSR_rest');
else
    features_GSR_comparison = compareFeatures(features_GSR_meme, features_GSR_rest);
end

% Save other data 
save([outputPath 'features_GSR_meme.mat'], 'features_GSR_meme');
save([outputPath 'features_GSR_rest.mat'], 'features_GSR_rest');
save([outputPath 'features_GSR_comparison.mat'], 'features_GSR_comparison');


%% Calcola le features PPG
clc
features_PPG_meme = computeFeaturesPPG_full(physiologicalDataTable(:,4), SAMPLE_FREQ);
if FULL_REST
    features_PPG_rest = computeFeaturesPPG_full(physiologicalDataTable(:,8), SAMPLE_FREQ);
else
    features_PPG_rest = computeFeaturesPPG_full(physiologicalDataTable(:,12), SAMPLE_FREQ);
end

% Make comparison
if MEAN_REST
    mean_features_PPG_rest = calculate_struct_average(features_PPG_rest);
    features_PPG_comparison = compareFeaturesMean(features_PPG_meme, mean_features_PPG_rest);
    save([outputPath 'mean_features_PPG_rest.mat'], 'mean_features_PPG_rest');
else
    features_PPG_comparison = compareFeatures(features_PPG_meme, features_PPG_rest);
end

%% Save data
save([outputPath 'features_PPG_meme.mat'], 'features_PPG_meme');
save([outputPath 'features_PPG_rest.mat'], 'features_PPG_rest');
save([outputPath 'features_PPG_comparison.mat'], 'features_PPG_comparison');


%% Funzioni
function structure_with_averages = calculate_struct_average(input_structure)
    structure_with_averages = struct();
    
    numFields = numel(fieldnames(input_structure));
    fields = fieldnames(input_structure);
    numSubj = 20;
    numMeme = 24;
    
    for i = 1:numFields
        currentField = fields{i};
        for j = 1 : numSubj
            startIdx = (j - 1) * numMeme + 1;
            endIdx = j * numMeme;
    
            fieldMean = mean(input_structure.(currentField)(startIdx:endIdx));
            structure_with_averages.(currentField)(j) = fieldMean;
        end
    end
end