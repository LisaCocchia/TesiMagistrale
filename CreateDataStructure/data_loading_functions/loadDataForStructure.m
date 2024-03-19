function [shimmerData, memeMarker, restingMarker, ePrimeData] = loadDataForStructure(folder, subjectNumber)   
    shimmerDataFile = fullfile(folder, sprintf('shimmerData_subject_%d.mat', ...
        subjectNumber));
    restingMarkerFile = fullfile(folder, ...
        sprintf('restingMarker_subject_%d.mat', subjectNumber));
    memeMarkerFile = fullfile(folder, ...
        sprintf('memeMarker_subject_%d.mat', subjectNumber));
    ePrimeFile = fullfile(folder, sprintf('ePrimeData_subject_%d.xlsx', ...
        subjectNumber));
     
    if exist(shimmerDataFile, 'file')
        shimmerData = load(shimmerDataFile);
    else
        disp(['File not found: ' shimmerDataFile]);
        shimmerData = struct([]);
    end

    if exist(memeMarkerFile, 'file')
        memeMarker = load(memeMarkerFile);
    else
        disp(['File not found: ' memeMarkerFile]);
        memeMarker = struct([]);
    end

     if exist(restingMarkerFile, 'file')
        restingMarker = load(restingMarkerFile);
     else
        disp(['File not found: ' restingMarkerFile]);
        restingMarker = struct([]);
     end

     if exist(ePrimeFile, 'file')
        ePrimeData = import_ePrime_data(ePrimeFile);
    else
        disp(['File not found: ' ePrimeFile]);
        ePrimeData = struct([]);
    end

end