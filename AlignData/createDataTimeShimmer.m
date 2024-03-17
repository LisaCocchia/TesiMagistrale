%{
    Questa funzione è progettata per convertire un array di timestamp Unix
    in valori di data e ora locali utilizzando il fuso orario Europe. 
    I valori datetime risultanti vengono memorizzati in un array datetime, 
    che viene successivamente salvato.
    # Input
    folder: percorso della cartella in cui verrà salvato l'array datetime.
    filename: Il nome del file in cui verrà salvato l'array datetime.
    timestamps: Un array di timestamp Unix (in millisecondi) da convertire 
            in datetime.
    # Output
    shimmerTimestamps_dateTime: array contenente valori datatime
                                corrispondenti ai timestamp Unix di input.
%}
function shimmerTimestamps_dateTime = createDataTimeShimmer(folder, filename, timestamps)
    shimmerTimestamps_dateTime = NaT(1,length(timestamps));
    shimmerTimestamps_dateTime.TimeZone = "local";
    for i = 1 : length(timestamps)
        timestamp_unix_seconds = timestamps(i) / 1000;
        shimmerTimestamps_dateTime(i) = datetime(timestamp_unix_seconds, ...
            'ConvertFrom', 'posixtime', 'TimeZone', 'Europe/Amsterdam', ...
            'Format', 'dd-MMM-yyyy HH:mm:ss.SSS');
    end
    shimmerTimestamps_dateTime.TimeZone = "local";
    save(fullfile(folder, filename), "shimmerTimestamps_dateTime");
end