
%%
% Funzione che permette di eseguire denoising di un segnale facendo uso della 
% Stationary Wavelt Transform. Il segnale (signal) viene decomposto in L
% livelli (L scale) facendo uso della mother wavelet indicata in wnameSWT. 
% Per ogni livello viene eseguita una sogliatura ai 
% coefficienti contenuti nel canale approssimazione. La scelta della soglia
% viene eseguita per mezzo dei parametri thrType e rescalThr che
% determinano rispettivamente il metodo di calcolo della soglia (ex:
% thrType = minimax) e il rescaling o meno della soglia in base al livello
% (ex: rescalThr = 'one'). 
%
% INPUT:
% - signal: 	segnale a cui vogliamo applicare il denoising
% - L: 			numero di livelli in cui vogliamo decomporre il segnale tramite wavelet
% - wnameSWT:	tipo di mother wavelet con cui vogliamo eseguire la scomposizione
% - thrType:	metodo di calcolo della soglia
% - rescalThr: 	rescaling o meno della soglia in base al livello
%
% OUTPU:
% - SWT_denoise:segnale ripulito da rumore
%%

function SWT_denoise = swt_denoising(signal, L, wnameSWT, thrType, rescalThr)

    % Esegue la trasformata usando la SWT
    swc = swt(signal, L, wnameSWT);
    swcnew = swc;
    
    % Calcolo dei Threshold in base ai parametri passati
    ThreshML = wthrmngr('sw1ddenoLVL',thrType, swc, rescalThr); 
    
    % Applicazione della sogliatura ai diversi canali dettaglio generati
    % con SWT
    for jj = 1:L
        swcnew(jj,:) = wthresh(swc(jj,:),'s',ThreshML(jj));
    end

    % Trasformata inversa da SWT a segnale normale
    SWT_denoise = iswt(swcnew,wnameSWT);

end

