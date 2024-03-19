function [out] = computeFeaturesGSR(physiologicalDataTable, Fc, testo)
% Funzione per il calcolo delle feature sui segnali GSR forniti nella
% struct di input. NOTA: L'input "testo" viene usato solo ai fini della
% visualizzazzione per conoscere quale segnale stiamo trattando

    % Inizializzazione strutture di supporto per la raccolta dati
    measures_max_gsr = [];
    measures_min_gsr = [];
    measures_mean_gsr = [];
    measures_var_gsr = [];
    
    measures_max_gsr_phas = [];
    measures_min_gsr_phas = [];
    measures_mean_gsr_phas = [];
    measures_var_gsr_phas = [];
    
    %measures_n_pks_gsr = [];
    measures_rate_pks_gsr = [];   
    measures_mean_height_pks_gsr = [];
    measures_peaks_area_gsr = [];
    measures_peaks_area_per_sec_gsr = [];
    measures_peaks_rise_time_gsr = [];
    
    measures_reg_coef_gsr = [];
    
    % Istanziazione numero entry di cui calcolare le feature
    n_part = size(physiologicalDataTable,1);

    % Ciclo per la computazione delle feature GSR
    for j = 1 : n_part
 
        % Estrazione segmento da analizzare
        temp_gsr = cell2mat(physiologicalDataTable{j,1});
        
        phasic_temp = cell2mat(physiologicalDataTable{j,2})';
        tonic_temp = cell2mat(physiologicalDataTable{j,3})';
        
        % Visualizzazione delle due componenti
%         figure('units','normalized','outerposition',[0 0 0.9 0.9]); sgtitle([testo ' - Trial ' num2str(j)]) 
%         subplot(2,2,1); plot(phasic_temp); title('Phasic Component');
%         hold on; plot(temp_gsr); legend('phasic', 'original');
%         subplot(2,2,2); plot(tonic_temp); title('Tonic Component');
%         hold on; plot(temp_gsr); legend('tonic', 'original');
        
        % Calcolo delle misure statistiche generiche
        measures_max_gsr = [measures_max_gsr; max(temp_gsr)];
        measures_min_gsr = [measures_min_gsr; min(temp_gsr)];
        measures_mean_gsr = [measures_mean_gsr; mean(temp_gsr)];
        measures_var_gsr = [measures_var_gsr; var(temp_gsr)];
        
        measures_max_gsr_phas = [measures_max_gsr_phas; max(phasic_temp)];
        measures_min_gsr_phas = [measures_min_gsr_phas; min(phasic_temp)];
        measures_mean_gsr_phas = [measures_mean_gsr_phas; mean(phasic_temp)];
        measures_var_gsr_phas = [measures_var_gsr_phas; var(phasic_temp)];
        
        % Ricerca dei picchi
        [pks, ~] = findpeaks(phasic_temp, 'MinPeakDistance', 128,...
            'MinPeakProminence', 0.02);  %0.05 old threashold
                
        
        %% Misure relative ai picchi
        numPeak = length(pks);
        %measures_n_pks_gsr = [measures_n_pks_gsr; numPeak]; 
        
        % Controllo se numero dei picchi individuati è maggiore di zero
        if numPeak > 0
            measures_mean_height_pks_gsr = [measures_mean_height_pks_gsr; mean(pks)];      
        else % nel caso in cui non abbia rilevato picchi --> setto altezza a 0
            measures_mean_height_pks_gsr = [measures_mean_height_pks_gsr; 0];
        end
               
        % Calcolo lunghezza in secondi del segmento
        gsr_length = length(temp_gsr);
        sec_length = round(gsr_length/Fc);

        % Calcolo del rate dei picchi con la misura in secondi del segmento
        measures_rate_pks_gsr = [measures_rate_pks_gsr; length(pks)/sec_length];
        
        % Computazione dell'area e del rise_time sottostante i picchi trovati
        if numPeak > 0
            [area, area_per_sec, rising_time] = computePeaksFeatures_GSR(phasic_temp, Fc);
         
            measures_peaks_area_gsr = [measures_peaks_area_gsr; sum(area)/length(pks)];
            measures_peaks_area_per_sec_gsr = [measures_peaks_area_per_sec_gsr; mean(area_per_sec)];
            measures_peaks_rise_time_gsr = [measures_peaks_rise_time_gsr; mean(rising_time)];
            
        else % nel caso in cui non abbia rilevato picchi --> setto area a 0
            measures_peaks_area_gsr = [measures_peaks_area_gsr; 0];
            measures_peaks_area_per_sec_gsr = [measures_peaks_area_per_sec_gsr; 0];
            measures_peaks_rise_time_gsr = [measures_peaks_rise_time_gsr; 0];
        end
        
        % Regressione lineare per il calcolo della pendenza del segnale
        y = tonic_temp;
        x = (1:length(y))';
        p = polyfit(x,y,1);
        
        measures_reg_coef_gsr = [measures_reg_coef_gsr; p(1)];
        

        
    end
    
    % Costruzione dell'output
    out.max_gsr = measures_max_gsr;
    out.min_gsr = measures_min_gsr;
    out.mean_gsr = measures_mean_gsr;
    out.var_gsr = measures_var_gsr;
    
    out.max_gsr_phas = measures_max_gsr_phas;
    out.min_gsr_phas = measures_min_gsr_phas;
    out.mean_gsr_phas = measures_mean_gsr_phas;
    out.var_gsr_phas = measures_var_gsr_phas;
    
    %out.n_peaks_gsr = measures_n_pks_gsr;
    out.rate_peaks_gsr = measures_rate_pks_gsr;        
    out.height_peaks_gsr = measures_mean_height_pks_gsr;
    out.peaks_area_gsr = measures_peaks_area_gsr;
    out.peaks_area_per_sec_gsr = measures_peaks_area_per_sec_gsr;
    out.peaks_rise_time = measures_peaks_rise_time_gsr;
    
    out.reg_coef_gsr = measures_reg_coef_gsr;

end

