clear all
clc
addpath 'data_loading_functions\';
addpath 'filtering_functions\';
%%
%{
    pysiologicalColumns: lista delle colonne che formeranno la stuttura dati
    MEMEs_PER_PARTICIPANT: numero di meme che visualizza ogni partecipante
    MAIN_FOLDER: Cartella principale in cui trovo i dati
    SAMPLE_FREQ: Frequenza di campionamento
    MEME_TIME_ON_SET: tempo di visualizzazione meme (in secondi)
    REST_TIME_ON_SET: tempo della fase di resting (in secondi)
    data_saving_folder_path = 'DataStructure\';
%}
physiologicalColumns = {...
    'skinConductanceMeme', 'GSRmeme_phasic', 'GRSmeme_tonic', 'PPGmeme', ...
    'skinConductanceRest',  'GSRrest_phasic', 'GRSrest_tonic', 'PPGrest', ...
    'skinConductanceRest15s',  'GSRrest_phasic15s', 'GRSrest_tonic15s', 'PPGrest15s'};
MEMEs_PER_PARTICIPANT = 24;
MAIN_FOLDER = '../Data/subjects';
SAMPLE_FREQ = 128;
MEME_TIME_ON_SET = 15;
REST_TIME_ON_SET = 30;
data_saving_folder_path = 'DataStructure\';
GENERATE_PLOT = false;

%% Carico i dati necessari dai file csv e xlsx
%{
    memesData:  struttura dati contenente tutte le informazioni relative 
                ai Meme. 
                [96x10 table]
    participantsData:   struttura dati contenente tutte le informazioni
                        relative ai partecipanti
                        [20x1 cell]
    groupTable:   tabella contenente tutti i gruppi random. Ogni colonna
                  contiene gli id dei meme del gruppo che ha come numero
                  l'indice della colonna
                  [24x40 table]
    linker: struttura dati che collega gli indici dei partecipanti con i
            corrispondenti indici dei Meme
            [480x2 table]
    finalQuestResults: risposte del questionario finale
%}
memesData = getMemeData();
memeNum = size(memesData, 1);

participantsData = getParticipantsData(  ...
    'excel_file/initialQuestionnaire.csv', ...
    'excel_file/partecipanti.xlsx');
participantsNum = size(participantsData, 1);

groupTable = readtable('excel_file/random_groups.xlsx');
finalQuestResults = getFinalQuestResults('excel_file/finalQuestionnaire.xlsx');
linker = getLinkerArray(participantsData, groupTable);

%% Costruisco le strutture e le variabili necessarie

numberOfPhysiologicalDataType = size(physiologicalColumns, 2);

numberOfPhysiologicalData = MEMEs_PER_PARTICIPANT * participantsNum;

physiologicalData = cell(numberOfPhysiologicalData, ...
    numberOfPhysiologicalDataType);
physioIndex = 1;

memeIntervalSampleCount = SAMPLE_FREQ * MEME_TIME_ON_SET;
restIntervalSampleCount = SAMPLE_FREQ * REST_TIME_ON_SET;

numberOfSubFolder = dir(MAIN_FOLDER);
numberOfSubFolder = nnz(~ismember({numberOfSubFolder.name}, ...
    {'.','..'})&[numberOfSubFolder.isdir]);

memeRatings = [];

%% Itero attraverso le sottocartelle dei soggetti
h = waitbar(0, 'Avanzamento...', 'Name', 'Generate data');
numero_iterazioni = numberOfSubFolder;

for n = 1:numberOfSubFolder
    % Costruisco il percorso della sottocartella
    subFolder = fullfile(MAIN_FOLDER, sprintf('subject_%d', n));
    waitbar(n / numero_iterazioni, h, ...
        sprintf('Subject - %d [%d%%]', n, round(n / numero_iterazioni * 100)));

    if exist(subFolder, 'dir')
        % Carica i dati per il soggetto corrente se esiste la cartella
        [shimmerData, memeMarker, restingMarker, ePrimeData] = ...
            loadDataForStructure(subFolder, n);

        % Se non ci sono i dati di EPrime salto al soggetto successivo
        if isempty(ePrimeData)
            continue;
        end

        % Divido i dati dello Shimmer
        [shimmerTimestampSyncUnix, skinConductance, skinResistance, PPG] ...
            = splitShimmerData(shimmerData, n);

        memeMarker = memeMarker.meme_eprime_marker;
        restingMarker = restingMarker.rest_eprime_marker;
        subjectResponses = ePrimeData(:, {'Subject', 'ID', 'questionTrialRESP'});
        memeRatings = [memeRatings; subjectResponses];

        % Filtro i segnali
        GSR_filtered = filterSegment_GSR_wave(skinConductance);
        PPG_filtered = ppg_data_preprocessing(PPG, SAMPLE_FREQ);

        % Divido il GSR in componente fasica e componente tonica
        [GSR_phasic, ~, GSR_tonic, ~, ~, ~, ~] = ...
            cvxEDA(GSR_filtered, 1/SAMPLE_FREQ);

        % Frammento il segnale in meme, rest e ultimi 30sec di rest
        markerMemeIndex = find(memeMarker);
        markerRestIndex = find(restingMarker);
        skinConductanceSize = size(skinConductance, 1);

        for i = 1:size(markerMemeIndex, 1)
            startMeme = markerMemeIndex(i);
            finishMeme = markerMemeIndex(i) + memeIntervalSampleCount;

            physiologicalData{physioIndex, 1} = GSR_filtered(startMeme:finishMeme);
            physiologicalData{physioIndex, 2} = GSR_phasic(startMeme:finishMeme);
            physiologicalData{physioIndex, 3} = GSR_tonic(startMeme:finishMeme);
            physiologicalData{physioIndex, 4} = PPG_filtered(startMeme:finishMeme);

            startResting = markerRestIndex(i);
            finishResting = markerRestIndex(i) + restIntervalSampleCount;

            physiologicalData{physioIndex, 5} = GSR_filtered(startResting:finishResting);
            physiologicalData{physioIndex, 6} = GSR_phasic(startResting:finishResting);
            physiologicalData{physioIndex, 7} = GSR_tonic(startResting:finishResting);
            physiologicalData{physioIndex, 8} = PPG_filtered(startResting:finishResting);

            startResting15 = markerRestIndex(i) + (restIntervalSampleCount / 2);
            finishResting15 = markerRestIndex(i) + restIntervalSampleCount ;

            physiologicalData{physioIndex, 9} = GSR_filtered(startResting15:finishResting15);
            physiologicalData{physioIndex, 10} = GSR_phasic(startResting15:finishResting15);
            physiologicalData{physioIndex, 11} = GSR_tonic(startResting15:finishResting15);
            physiologicalData{physioIndex, 12} = PPG_filtered(startResting15:finishResting15);

            physioIndex = physioIndex + 1;

        end
    end
end
close(h);

%% Converto l'array in una tabella utilizzando i nomi delle colonne
physiologicalDataTable = array2table(physiologicalData, 'VariableNames', physiologicalColumns);
memeRatings = renamevars(memeRatings,["Subject", "ID"],["participantsIDs","memeIDs"]);

%% Genero i plot dei segnali
if GENERATE_PLOT
    GeneratePlot_Subject_Meme
end

%% Salvo le strutture dati create
createDirectoryIfNotExists(data_saving_folder_path);
save([data_saving_folder_path 'physiologicalDataTable.mat'], 'physiologicalDataTable');
save([data_saving_folder_path 'linker.mat'], 'linker');
save([data_saving_folder_path 'memeRatings.mat'], 'memeRatings');
save([data_saving_folder_path 'memesData.mat'], 'memesData');
save([data_saving_folder_path 'finalQuestResults.mat'], 'finalQuestResults');
save([data_saving_folder_path 'participantsData.mat'], 'participantsData');

clearvars -except groupTable linker memesData physiologicalDataTable ...
    shimmerData participantsData memeRatings finalQuestResults ...
    data_saving_folder_path

save([data_saving_folder_path  'workspace_data.mat']);

%%
rmpath('data_loading_functions\');
rmpath('filtering_functions\');