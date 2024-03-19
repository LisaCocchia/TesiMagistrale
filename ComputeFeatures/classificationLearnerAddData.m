clc
clear all
load('..\CreateDataStructure\DataStructure\finalQuestResults.mat');

load('..\CreateDataStructure\DataStructure\eprime_data_full.mat');
% root = 'Features_meanRest\';
root = 'Features_precRest\';

file_list = dir([root '*.mat']);
n_files = length(file_list);
for i = 1:n_files
   load([root file_list(i).name]);
end
% labels = finalQuestResults.Misogyny;

labels = eprimedatafull.questionTrialRESP;

%% GSR Features 
features = prepareDataForClassification(features_GSR_meme, labels);

%% PPG Features
features = prepareDataForClassification(features_PPG_meme, labels);

%% GSR and PPG 
clc
features_GSR_PPG = [struct2table(features_GSR_meme), struct2table(features_PPG_meme), array2table(labels)];
classificationLearner(features_GSR_PPG, "labels", "CrossVal", "on");

%% GSR Comparison 
features = prepareDataForClassification(features_GSR_comparison, labels);

%% PPG Comparison 
clc
features = prepareDataForClassification(features_PPG_comparison, labels);

%% CLASSIFICATION
clc
classificationLearner(features, "Labels", "CrossVal", "on");




%% funzioni 
function featuresTable = prepareDataForClassification(featuresStructure, labels)
   featuresStructure.Labels = labels;
   featuresTable = struct2table(featuresStructure);
end

