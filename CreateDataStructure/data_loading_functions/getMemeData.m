function memeData = getMemeData()
    
    % Carica i dati dai due file Excel
        % memeText.xlsx:    FileName	OCRText	NumCharacters	NumWords
        % SelectedMEME:     ID	FileName	Misogynous	Objectification	Shaming	Stereotype	Violence
    memeText = readtable('excel_file/memeText.xlsx');
    selected_MEME = readtable('excel_file/selected_MEME.xlsx');
    
    % Unisci le tabelle utilizzando 'FileName' come chiave
    memeData = join(selected_MEME, memeText, 'Keys', 'FileName');
    
    % Calcola il numero di caratteri leggibili (senza spazi e simboli) in OCRText
    memeData.NumReadableCharacters = cellfun(@(x) sum(isstrprop(x, 'alphanum')), memeData.OCRText);
    
    % Calcola il numero di parole in OCRText
    memeData.NumWordsInOCRText = cellfun(@(x) length(strsplit(x)), memeData.OCRText);

end