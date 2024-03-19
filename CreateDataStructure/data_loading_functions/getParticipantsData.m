function participantsCellArray = getParticipantsData(initialQuestPath, participantsFilePath)
    % Carico i risultati del questionario iniziale selezionando le colonne
    % che mi interessano
    initialQuestResults = readtable(initialQuestPath, 'VariableNamingRule', 'preserve');
    initialQuestResults = initialQuestResults(:, 19:53);
    % Normalizzo i  nomi delle colonne
    initialQuestResults.Properties.VariableNames = regexprep(initialQuestResults.Properties.VariableNames, '[àáâãäå]', 'a');
    initialQuestResults.Properties.VariableNames = matlab.lang.makeValidName(initialQuestResults.Properties.VariableNames);

    % Carico i dati dei partecipanti
    participantsData = readtable(participantsFilePath, 'VariableNamingRule', 'preserve');
    participantsData.Properties.VariableNames = matlab.lang.makeValidName(participantsData.Properties.VariableNames);


    % Eseguo una left join tra i dati dei partecipanti e 
    % i risultati del questionario iniziale confrontando i codici
    participantsQuestData = outerjoin(participantsData, initialQuestResults, ...
                                'LeftKeys', 'CodicePartecipante', ...
                                'RightKeys', 'CODICE', 'Type', 'left');
    

    % Rimuovo colonne non necessarie e rinomino la colonna del codice
    participantsQuestData = sortrows(participantsQuestData, 'NumeroPartecipante');
    participantsQuestData(:, {'NumeroPartecipante', 'DataPartecipazione', ...
                                'Note', 'CODICE'}) = [];
    participantsQuestData = renamevars(participantsQuestData, 'CodicePartecipante', 'CODICE');
    
    codici = participantsQuestData.CODICE;
    participantsCellArray = cell(length(codici), 1);

    for i = 1:length(codici)
        codice = codici{i};
        participant_idx = find(strcmp(participantsQuestData.CODICE, codice));
        
        % Inizializzo una struttura per il partecipante corrente
        participantsCellArray{i} = struct('CODICE', convertToCellOrString(codice));

        % Itera sulle colonne dei dati
        for col = participantsQuestData.Properties.VariableNames
            col_name = col{1};
            
            if ~isempty(regexp(col_name, '_\d+$', 'once'))
                % Se il nome della colonna termina con _n allora creo una
                % sottostruttura. 
                parts = strsplit(col_name, '_');
                parent_name = strjoin(parts(1:end-1), '_');
                
                % Creo la sottostruttura se non esiste
                if ~isfield(participantsCellArray{i}, parent_name)
                    participantsCellArray{i}.(parent_name) = struct();
                end
                
                % Ottieni i valori unici e assegna alla struttura
                values = participantsQuestData.(col_name)(participant_idx);
                participantsCellArray{i}.(parent_name).(col_name) = convertToCellOrString(values);
            else
                values = participantsQuestData.(col_name)(participant_idx);
                col_name = genvarname(col_name); % Trasforma in un nome valido
                participantsCellArray{i}.(col_name) = convertToCellOrString(values);
            end
        end
    end
end


%{
    convertToCellOrString
    converte in stringa il valore se è costituito da caratteri 
    e se è formato da un solo elemento ritorna il valore non in formato cell
%}
function result = convertToCellOrString(value)
    if ischar(value)
        result = string(value);
    elseif iscell(value) && numel(value) == 1
        result = string(value{1});
    else
        result = value;
    end
end
