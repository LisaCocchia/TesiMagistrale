function preprocessed_ppg = ppg_data_preprocessing(PPG, srate)
    
    % Design the filter ...
    [ba, aa] = butter(4, [0.7 4]/(srate/2), 'bandpass');
    
    % ... and apply it.
    dPPG = filtfilt(ba, aa, PPG);
    
    % Normalisation
    nPPG = zscore(dPPG);
    
    % Demodulation
    % Rinkevičius, M., Rapalis, A., Pluščiauskaitė, V., Piartli, P., Kaniusas, 
    % E., & Marozas, V. (2021, September). Low-Exertion Testing of Autonomic 
    % Cardiovascular Integrity Through PPG Signal Analysis. 
    % In 2021 Computing in Cardiology (CinC) (Vol. 48, pp. 1-4). IEEE.
    [yu, yl] = envelope(nPPG, 75, 'peak');
    PAV = yu - yl;
    dPPG = nPPG./PAV;
    
    preprocessed_ppg = dPPG;

end