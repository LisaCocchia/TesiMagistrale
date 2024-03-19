function [out] = computeFeaturesPPG_full(physiologicalDataTable, Fc)
% Funzione per il calcolo delle feature sui segnali PPG forniti nella
% struct di input
% @Authors: Alessandra Grossi, Roberto Crotti 
    
    % Inizializzazione strutture di supporto per la raccolta dati
    measures_max_ppg = [];
    measures_min_ppg = [];
    measures_mean_ppg = [];
    measures_var_ppg = [];
    
    measures_n_pks_ppg = [];
    measures_rate_pks_ppg = [];
    
    measures_IBI_mean = [];
    measures_RMSSD = [];

    %% PARTE AGGIUNTA
    measures_SDNN = [];
    measures_SDSD = [];
    % measures_NN50 = [];
    % measures_pNN50 = [];
    % measures_NN20 = [];
    %measures_pNN20 = [];
    measures_SD1 = [];
    measures_SD2 = [];
    measures_SD2SD1_ratio = [];
    measures_ApEn = [];
    measures_SampEn = [];
    measures_VLF = [];
    measures_LF = [];
    measures_HF = [];
    measures_LFHF_ratio = [];
    %%
    
    % Istanziazione numero entry di cui calcolare le feature
    n_part = size(physiologicalDataTable,1);
    
    % Ciclo per la computazione delle features PPG
    % Per ciascuno degli spezzoni di segnale di cui è composto un task 
    % (es. ciascuno degli spezzoni di segnale corrispondenti a ciascun brano)
    for j = 1 : n_part 
        
        % Estrazione segmento da analizzare
        temp_ppg = cell2mat(physiologicalDataTable{j,1})';
        
        % Calcolo delle misure statistiche generiche
        measures_max_ppg = [measures_max_ppg; max(temp_ppg)];
        measures_min_ppg = [measures_min_ppg; min(temp_ppg)];
        measures_mean_ppg = [measures_mean_ppg; mean(temp_ppg)];
        measures_var_ppg = [measures_var_ppg; var(temp_ppg)];
        

        % Ricerca dei picchi
        [pks2, loc2] = findpeaks(temp_ppg, 'MinPeakDistance', 75);
               
        % Misure relative ai picchi
        measures_n_pks_ppg = [measures_n_pks_ppg; length(pks2)];
             
        % Calcolo lunghezza in secondi del segmento
        ppg_length = length(temp_ppg);
        sec_length = round(ppg_length/Fc);
        
        % Calcolo del rate dei picchi con la misura in secondi del segmento
        measures_rate_pks_ppg = [measures_rate_pks_ppg; length(pks2)/sec_length];
          
        % Calcolo del vettore di distanze dei picchi e la media

        IBI_vet = 0;
        for k = 1 : length(pks2) - 1
            IBI_vet(k) = loc2(k+1) - loc2(k);
        end
        IBI = mean(IBI_vet);
        measures_IBI_mean = [measures_IBI_mean; IBI];
    
        % Calcolo RMSSD (Root Mean Square of the Successive Differences)
        RMSSD_vet = 0;
        for m = 1 : length(IBI_vet) - 1
            RMSSD_vet(m) = (IBI_vet(m+1)-IBI_vet(m)) .^ 2;
        end
        RMSSD = mean(RMSSD_vet) .^ 0.5;
        measures_RMSSD = [measures_RMSSD; RMSSD];


        %% PARTE AGGIUNTA
        %% HRV features - time domain

        % Vettore intervalli interbattito (millisecondi)
        IBI_vet_millis = (IBI_vet / Fc) * 1000; 

        % 1) SDNN: deviazione standard degli intervalli interbattito
        SDNN_millis = std(IBI_vet_millis); % (millisecondi)
        SDNN = std(IBI_vet); % (campioni)
        measures_SDNN = [measures_SDNN; SDNN];

        % Serie di intervalli interbattito differenziata 
        diffNN_millis = diff(IBI_vet_millis); % (millisecondi)
        diffNN = diff(IBI_vet); % (campioni)

        % 2) RMSSD 
        RMSSD_millis = rms(diffNN_millis); % (millisecondi)

        % 3) SDSD: deviazione standard delle differenze tra le durate di
        % intervalli successivi
        SDSD_millis = std(diffNN_millis); % (millisecondi)
        SDSD = std(diffNN); % (campioni)
        measures_SDSD = [measures_SDSD; SDSD];

        % 4) NN50: numero delle coppie di intervalli successivi che 
        % differiscono in durata per più di 50 ms
        % NN50 = length(find(abs(diffNN_millis) > 50));
        % measures_NN50 = [measures_NN50; NN50];

        % 5) pNN50: proporzione di NN50 sul totale degli intervalli 
        % pNN50 = NN50 / length(IBI_vet);
        % measures_pNN50 = [measures_pNN50; pNN50];

        % 6) NN20: numero delle coppie di intervalli successivi che 
        % differiscono in durata per più di 20 ms
        % NN20 = length(find(abs(diffNN) > 20));
        % measures_NN20 = [measures_NN20; NN20];

        % 7) pNN20: proporzione di NN20 sul totale degli intervalli 
        % pNN20 = NN20 / length(IBI_vet);
        % measures_pNN20 = [measures_pNN20; pNN20];
        

        %% HRV features - nonlinear

        % 1) SD1: deviazione standard del grafico di Poincaré 
        % perpendicolare alla linea di identità 
        SD1_millis = sqrt(0.5 * SDSD_millis^2); % (millisecondi)
        SD1 = sqrt(0.5 * SDSD^2); %(campioni)
        measures_SD1 = [measures_SD1; SD1];

        % 2) SD2: deviazione standard del grafico di Poincaré lungo la 
        % linea di identità
        SD2 = sqrt(2*(SDNN_millis^2) - (0.5 * SDSD_millis^2)); % (millisecondi)
        SD2 = sqrt(2*(SDNN^2) - (0.5 * SDSD^2)); % (campioni)
        measures_SD2 = [measures_SD2; SD2];

        % 3) Rapporto SD2/SD1
        measures_SD2SD1_ratio = [measures_SD2SD1_ratio; SD2/SD1];

        % Vettore distanze tra picchi (secondi)
        IBI_vet_secs = IBI_vet_millis / 1000; 

        % ApEn: Entropia Approssimata dello spezzone corrente del segnale
        ApEn = approximateEntropy(IBI_vet_secs, 'dim', 2, 'Radius', 0.2 * SDNN_millis / 1000);
        measures_ApEn = [measures_ApEn; ApEn];

        % SampEn: Sample Entropy - sampen(signal, m, r)
        SampEn = sampen(IBI_vet_secs, 2, 0.2 * std(IBI_vet_secs));
        measures_SampEn = [measures_SampEn; SampEn];

        %% HRV features - frequency domain
        f_interplotion = 4;
        t = zeros(1, length(IBI_vet_secs));
        for l = 1 : 1 : length(IBI_vet_secs)
            t(l) = sum(IBI_vet_secs(1:l));
        end
        t2 = t(1) : 1/f_interplotion : t(length(t)); %time values for interp.
        y= interp1(t, IBI_vet_secs, t2', 'spline')'; % Cubic spline interpolation

        % power spectral density
        y1 = y - mean(y); %remove mean
        NFFT = max(256, 2^nextpow2(length(y1))); % the number of FFTs
        [pxx,f] = pwelch(y1, length(t2), length(t2)/2, (NFFT*2) - 1, f_interplotion); % using welch method to calculate the power spectrum

        % HRV
        f_VLF = [0 0.04];
        f_LF = [0.04 0.15];
        f_HF = [0.15 0.4];
        
        VLF = trapz(f(f >= f_VLF(1) & f <= f_VLF(2)), ...
            pxx(f >= f_VLF(1) & f <= f_VLF(2))) * 1e6; % (millisecondi^2)

        LF = trapz(f(f >= f_LF(1) & f <= f_LF(2)), ...
            pxx(f >= f_LF(1) & f <= f_LF(2))) * 1e6; % (millisecondi^2)

        HF = trapz(f(f >= f_HF(1) & f <= f_HF(2)), ...
            pxx(f >= f_HF(1) & f <= f_HF(2))) * 1e6; % (millisecondi^2)

        measures_VLF = [measures_VLF; VLF];
        measures_LF = [measures_LF; LF];
        measures_HF = [measures_HF; HF];
        measures_LFHF_ratio = [measures_LFHF_ratio; LF / HF];
        
    end
        
    % Costruzione dell'output
    out.max_ppg = measures_max_ppg;
    out.min_ppg = measures_min_ppg;
    out.mean_ppg = measures_mean_ppg;
    out.var_ppg = measures_var_ppg;
    
    %out.n_peaks_ppg = measures_n_pks_ppg;
    out.rate_peaks_ppg = measures_rate_pks_ppg;
    
    out.IBI_mean = measures_IBI_mean;
    out.RMSSD = measures_RMSSD;

    %% PARTE AGGIUNTA
    out.SDNN = measures_SDNN;
    out.SDSD = measures_SDSD;
    % out.NN50 = measures_NN50;
    % out.pNN50 = measures_pNN50;
    % out.NN20 = measures_NN20;
    % out.pNN20 = measures_pNN20;
    out.SD1 = measures_SD1;
    out.SD2 = measures_SD2;
    out.SD2SD1_ratio = measures_SD2SD1_ratio;
    out.ApEn = measures_ApEn;
    out.SampEn = measures_SampEn;
    out.VLF = measures_VLF;
    out.LF = measures_LF;
    out.HF = measures_HF;
    out.LFHF_ratio = measures_LFHF_ratio;
    %%

end

