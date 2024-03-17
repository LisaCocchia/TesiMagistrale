%{
    Funzione che permette di caricare dati dai file.mat creati in
    precedenza, se non viene trovato un file viene visualizzato un
    messaggio di errore e restituita una struttura vuota.

    *ePrimeData*: dati registrati tramite ePrime 
    *shimmerData*: dati registrati tramite il dispositivo shimmer, verrà
    creata una struttura contenenente tutti i segnali registrati.
    *shimmerTimestamps_dateTime*: array dei timestamp registrati da shimmer
    convertiti in dtaTime
    manualMarker: array contenente i timestamp manuali 
%}
function [ePrimeData, shimmerData, shimmerTimestamps_dateTime, manualMarker] = loadData(folder, subjectNumber)
    ePrimeFile = fullfile(folder, sprintf('ePrimeData_subject_%d.xlsx', ...
        subjectNumber));
    shimmerDataFile = fullfile(folder, sprintf('shimmerData_subject_%d.mat', ...
        subjectNumber));
    shimmerTimestampsFile = fullfile(folder, ...
        sprintf('shimmerTimestamps_dateTime_subject_%d.mat', subjectNumber));
    manualMarkerFile = fullfile(folder, ...
        sprintf('manualMarker_subject_%d.mat', subjectNumber));
    
    if exist(ePrimeFile, 'file')
        ePrimeData = import_ePrime_data(ePrimeFile);
    else
        disp(['File not found: ' ePrimeFile]);
        ePrimeData = struct([]);
    end
    
    if exist(shimmerDataFile, 'file')
        shimmerData = load(shimmerDataFile);
    else
        disp(['File not found: ' shimmerDataFile]);
        shimmerData = struct([]);
    end

     if exist(manualMarkerFile, 'file')
        manualMarker = load(manualMarkerFile);
    else
        disp(['File not found: ' manualMarkerFile]);
        manualMarker = struct([]);
    end

    if exist(shimmerTimestampsFile, 'file')
        shimmerTimestamps_dateTime = load(shimmerTimestampsFile);
    else
        disp(['File not found: ' shimmerTimestampsFile]);
        shimmerTimestamps_dateTime = struct([]); 
    end
end