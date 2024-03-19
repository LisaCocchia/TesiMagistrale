% Per gli input:
% segment = array di valori (gsr o ppg) da filtrare
% P = valore che corrisponde alla frequenza di campionamento (gsr) o alla
% finestra (ppg)

function [out] = filterSegment_GSR_wave(segment)

    L = 7;

    signLen = size(segment,1); 

    % Dato che SWT con n livelli può essere usata solo su segnali divisibili
    % per 2^n --> allungo di conseguenza il segnale replicando l'ultimo valore
    % per un numero di sample pari a "quanti ne mancavano per diventare
    % divisibile per 256 + 256 bonus) [replicate padding]
    %
    %signalRawLong = [signalRaw; zeros(lungSignNew-size(signalRaw,1),1)];lungSignNew = (ceil(signLen/2^8)+1)*2^8;
    lungSignNew = (ceil(signLen/2^L)+1)*2^L;
    numPad = (lungSignNew - signLen)/2; %quanti sample aggiungere prima e dopo
    if floor(numPad)==numPad
        segmentLong = padarray(segment, numPad ,'replicate', 'both');
    else
        numPad = floor(numPad);
        segmentLong = padarray(segment, numPad,'replicate', 'both');
        segmentLong = [segmentLong; segmentLong(end)];
    end

    thrMethod = 'minimaxi';

    rescalThr = 'one';

    % Coif3

    wnameSWT = 'coif3';%'coif3'; 
    SWT_denoise_coif = swt_denoising(segmentLong, L, wnameSWT, thrMethod, rescalThr);
    out = SWT_denoise_coif(numPad+1 : signLen+numPad);

end

