%{
    Il codice esegue la sincronizzazione dei marker manuali con i marker
    creati utilizzando i dati di EPrime.
    Permette di visualizzare e salvare i grafici dei dati fisiologici con
    i marker sovrapposti. 

    Definisco le costanti
    MAIN_FOLDER: Cartella principale in cui trovo i dati
    SAMPLE_FREQ: Frequenza di campionamento
    SAVE_PLOT: Flag per salvare i grafici nella cartella Plot/ all'interno di MAIN_FOLDER
    VIEW_PLOT: Flag per visualizzare i grafici
%}

clear all
close all
MAIN_FOLDER = '../Data/subjects'; 
SAMPLE_FREQ = 128; 
SAVE_PLOT = false; 
plot_file_name = 'PlotEprime-Shimmer_rest';
VIEW_PLOT = false; 

% Recupero la lista delle sottocartelle nella cartella principale
listSubFolder = dir(MAIN_FOLDER);
numberOfSubFolder = nnz(~ismember({listSubFolder.name}, {'.','..'}) & [listSubFolder.isdir]);

allOffsetData = struct('subjectName', {}, 'startDate', {}, 'meanOffset', {}, 'offsetArray', {});

% Itero su ciascuna sottocartella
for n = 1 : numberOfSubFolder
    fprintf('subject_%d\n', n);
    subFolder = fullfile(MAIN_FOLDER, sprintf('subject_%d', n));

    if isfolder(subFolder)
        % Carico i dati dai file presenti nella sottocartella
        [ePrimeData, shimmerData, shimmerTimestamps_dateTime, manualMarker]...
            = loadData(subFolder, n);
        shimmerTimestamps_dateTime = struct2array(shimmerTimestamps_dateTime).';
		
		% Se non ci sono i dati di EPrime salto al soggetto successivo
        if isempty(ePrimeData)
            continue;
        end
        
        [shimmerTimestampSyncUnix, skinConductance, skinResistance, PPG]...
            = splitShimmerData(shimmerData, n);
        
        numOfSamples = size(shimmerTimestampSyncUnix);
        maxConductance = max(skinConductance);
        marker = zeros(numOfSamples);

        % Creo vettori di marker manuali
        if ~isempty(manualMarker)
            [meme_manual_marker, memeManualTimestamps] = ...
                createManualMarker(shimmerTimestamps_dateTime, ...
                manualMarker.history, manualMarker.timestamp, maxConductance);
        else
			% Se il file non esiste inizializzo l'array a tutti 0
            meme_manual_marker = zeros(size(shimmerTimestamps_dateTime, 1), 1);
        end       

        % Creo vettore di marker ePrime calcolato utilizzando i timestamp
        % dello shimmer
        if(n == 1)
            meanOffset = 0;
        elseif (n < 9)
            meanOffset = allOffsetData(n-1).meanOffset;     
        else
            meanOffset = allOffsetData(n-2).meanOffset;
        end
        [meme_eprime_marker, rest_eprime_marker, offsetData] =  ...
                createEprimeMarker(n, shimmerTimestamps_dateTime, ...
                ePrimeData ,maxConductance, memeManualTimestamps, ...
                manualMarker, meanOffset);  

        % Concatenazione delle strutture
        allOffsetData = [allOffsetData; offsetData];
        

        % Salvo i vettori dei marker ePrime allineati, nella sottocartella del soggetto
        save(fullfile(subFolder, sprintf('memeMarker_subject_%d', n)), "meme_eprime_marker");
        save(fullfile(subFolder, sprintf('restingMarker_subject_%d', n)), "rest_eprime_marker");

        if(VIEW_PLOT || SAVE_PLOT)
            fig = figure('visible', VIEW_PLOT);
            set(fig, 'Name', sprintf('subject_%d', n));
            title(sprintf("subject_%d", n), 'Interpreter', 'none');
            hold on
            plot(skinConductance, 'black');
            plot(meme_eprime_marker, 'g');
            plot(rest_eprime_marker, 'r');
            plot(meme_manual_marker, 'b');
            hold off
            legend('Conductance', 'MemeEprimeMarker', 'RestEprimeMarker', 'MemeManualMarker');
            % Salvo il plot se il flag è abilitato
            if(SAVE_PLOT)
                saveas(fig, sprintf('Plot/%s_subject_%d.fig', plot_file_name, n));
                saveas(fig, sprintf('Plot/%s_subject_%d.png', plot_file_name, n));
            end
        end
    else
        disp(['Sotto-cartella non trovata: ' subFolder]);
    end

end
excelFileName = 'all_offset_data.xlsx';
writetable(struct2table(allOffsetData), excelFileName, 'Sheet', 'Sheet1');

clearvars -except ePrimeData meme_manual_marker meme_marker meme_eprime_marker...
    shimmerData shimmerTimestamps_dateTime meme_eprime_marker_sub allOffsetData