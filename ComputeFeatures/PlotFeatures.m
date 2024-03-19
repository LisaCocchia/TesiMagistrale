clear all
clc
addpath '..\CreateDataStructure';
MEAN_REST = true;
FULL_REST = false;

%% Carico i dati
load('..\CreateDataStructure\DataStructure\finalQuestResults.mat');
load('..\CreateDataStructure\DataStructure\eprime_data_full.mat');
load('..\CreateDataStructure\DataStructure\workspace_data.mat');

if MEAN_REST & FULL_REST
    root = 'Features_meanRest\';
    restType = 'meanRest';
elseif ~MEAN_REST & FULL_REST
    root = 'Features_precRest\';
    restType = 'precRest';
elseif MEAN_REST & ~FULL_REST
    root = 'Features_meanRest_15sec\';
    restType = 'meanRest_15sec';
else% ~MEAN_REST & ~FULL_REST
    root = 'Features_precRest_15sec\';
    restType = 'precRest_15sec';
end

file_list = dir([root '*.mat']);
n_files = length(file_list);
for i = 1:n_files
    load([root file_list(i).name]);
end


%% Costruisco il vettore dei colori in base alle combinazioni di label
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
for i = 1 : 6
    switch i
        case 1
            subtitle = 'Misogyny';
            outputPath = 'Plot_mis\';
            colors = PlotFeaturesUtilityClass.generateColorsVector(mis);
        case 2
            subtitle = 'Violence and objectification';
            outputPath = 'Plot_vio_obj\';
            colors = PlotFeaturesUtilityClass.generateColorsVector(violence | objectification);
        case 3
            subtitle = 'Violence or offensive';
            outputPath = 'Plot_vio_off\';
            colors = PlotFeaturesUtilityClass.generateColorsVector(violence & offensive);
        case 4
            subtitle = 'Negative emotions';
            outputPath = 'Plot_negEmotions\';
            colors = PlotFeaturesUtilityClass.generateColorsVector(anger & disgust & sadness & troublesome);
        case 5
            subtitle = 'Misogyny max level';
            outputPath = 'Plot_mislev3\';
            colors = PlotFeaturesUtilityClass.generateColorsVector(maxIntensity);
        case 6
            subtitle = 'Offensive OR Violence OR Troublesome';
            outputPath = 'Plot_vio_off_troub\';
            colors = PlotFeaturesUtilityClass.generateColorsVector(violence | offensive | troublesome);
    end
    outputPath = [root outputPath];

    % Plot GSR
    plotTitle = ['Comparisons GSR-' restType ' - ' subtitle];
    % PlotDirectory =  [outputPath 'GSR/Subject'];
    % PlotFeaturesUtilityClass.plotCompareSignalSubj(features_GSR_comparison, ...
    %     PlotDirectory, plotTitle, false, colors, getSex(eprimedatafull.Sex));

    PlotDirectory = [outputPath 'GSR/Meme'];
    PlotFeaturesUtilityClass.plotCompareSignalMeme(features_GSR_comparison, ...
        linker, PlotDirectory, plotTitle, false, colors, memesData.Misogynous);

    % Plot PPG
    plotTitle = ['Comparisons PPG-' restType ' - ' subtitle];
    % PlotDirectory =  [outputPath 'PPG/Subject'];
    % PlotFeaturesUtilityClass.plotCompareSignalSubj(features_PPG_comparison, ...
    %     PlotDirectory, plotTitle, false, colors, getSex(eprimedatafull.Sex));

    PlotDirectory = [outputPath 'PPG/Meme'];
    PlotFeaturesUtilityClass.plotCompareSignalMeme(features_PPG_comparison, ...
        linker, PlotDirectory, plotTitle, false, colors, memesData.Misogynous);

end  
%TODO REMOVE
% Creare un vettore di dati audio (ad esempio, un segnale sinusoidale)
fs = 44100; % Frequenza di campionamento in Hz
durata = 3; % Durata del suono in secondi
frequenza = 440; % Frequenza del suono in Hz

t = 0:1/fs:durata-1/fs; % Vettore del tempo
suono = sin(2*pi*frequenza*t); % Generare un segnale sinusoidale+

% Riprodurre il suono
sound(suono, fs);

%% FUNZIONI
function sex = getSex (categorical)
sex = char(zeros(size(categorical)));
for i = 1 : size(categorical)
    if categorical(i) == 'female'
        sex(i) = 'F';
    else
        sex(i) = 'M';
    end
end
end
