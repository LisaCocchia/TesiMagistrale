function [out, area_per_sec, rising_time] = computePeaksFeatures_GSR(D, Fc)
% Funzione per il calcolo dell'area sottostante i picchi presenti nel
% segnale GSR e per il calcolo del peak rise time
% OUTPUT:
% - out = vettore contenente, per ogni picco, l'area sottostante il picco
% - area_per_sec = vettore contenente, per ogni picco, l'area media, sottostante 
%                  il picco, per secondo
% - rising_time = rising time di ogni picco calcolato
    

    % Creazione asse x per il calcolo dell'integrale
    x = 0:numel(D)-1;
    
    % Trovo i picchi del segnale fasico positivo
    [~,loc] = findpeaks(D, 'MinPeakDistance', 128,...
        'MinPeakProminence', 0.02);
    
    % Dimensione finestra per filtraggio
    dim_window_filtr = 70;
    
    % Filtraggio del segnale per rimuovere i picchi più piccoli (che poi
    % genererebbero problemi nella ricerca della base del picco con il
    % metodo della discesa). Il segnale viene allungato lungo i bordi per
    % gestire i picchi al limite 
    D_filt = movmean(padarray(D, [0, dim_window_filtr],'replicate'), ...
        dim_window_filtr);
    
    D_filt = D_filt(dim_window_filtr+1:end-dim_window_filtr);
    
    % Aggiustamento posizione picchi rilevati su segnale originale in funzione 
    % del segnale filtraro
    for k = 1:length(loc)
      i = loc(k);
      if D_filt(i-1) >= D_filt(i) || D_filt(i+1) >= D_filt(i) %Se non è già un picco...
         i = loc(k);
         if D_filt(i-1) >= D_filt(i) % Se si trova a destra del picco
             while i > 1 && D_filt(i-1) >= D_filt(i)
                i = i - 1;
             end
         end
         if D_filt(i+1) >= D_filt(i) % Se si trova a sinistra del picco
             while i < length(D_filt) && D_filt(i+1) >= D_filt(i)
                 i = i + 1;
             end
         end
         loc(k) = i;
      end     
    end
        
    % Trova le basi del picco rilevato
    for k = 1:length(loc)
        i = loc(k);
        while i > 1 && D_filt(i-1) <= D_filt(i) % Base di sinistra
            i = i - 1;
        end
        b_min(k) = i;
        i = loc(k);
        while i < length(D_filt) && D_filt(i+1) <= D_filt(i) % Base di destra
            i = i + 1;
        end
        b_max(k) = i;
    end
    
    
    % Pone negativi i valori minori di 0
    D(D<0) = 0;
    
    % Calcolo dell'area
    IntTot = cumtrapz(x,D);
    
    %% Visualizzazione e calcolo dell'area
    % Visualizza 
%     figure(); findpeaks(D, 'MinPeakDistance', 128,...
%        'MinPeakProminence', 0.02);
    
%    figure(gcf); subplot(2, 2, 3); findpeaks(D, 'MinPeakDistance', 128,...
%        'MinPeakProminence', 0.02, 'Annotate','extents');
%    figure(gcf); subplot(2,2, 4); findpeaks(D, 'MinPeakDistance', 128,...
%        'MinPeakProminence', 0.02);
    
    for k=1:length(b_min)
%         hold on; 
%         % Plotting dell'area su figure
%         area(b_min(k):b_max(k), D(b_min(k):b_max(k)))
        
        % Calcolo dell'area di ogni picco
        out(k) = IntTot(b_max(k)) - IntTot(b_min(k));
        
        % Calcolo, per ogni picco, dell'area media per secondo
        if (b_max(k) - b_min(k)) < Fc 
           area_per_sec(k) = 0; % se il picco dura meno di un secondo è considerato rumore
        else
           area_per_sec(k) = out(k)/round((b_max(k) - b_min(k))/Fc);
        end
        
    end
    
    %% Calcolo del valore di Rising Time dei picchi analizzati
    rising_time = loc - b_min;
%     
%     title('Peaks found and Area');
end