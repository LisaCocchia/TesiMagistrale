function [meme_eprime_marker, rest_eprime_marker, offsetData] = ...
    createEprimeMarker(subj_num, shimmerTimestamps_dateTime, ePrimeData, ...
    maxConductance, memeManualTimestamps, manualMarker, previousMean)

    startDateTime = ePrimeData.SessionStartDateTimeUtc(1);
    startDateTimeIT = startDateTime + hours(1);

    memeTimestampEPrime = TimeUtility.addMilliseconds(startDateTimeIT, ePrimeData.pictureTrialOnsetTime);
    restTimestampEPrime = TimeUtility.addMilliseconds(startDateTimeIT, ePrimeData.restingTrialOnsetTime);

    offsetData.subjectName = sprintf('subject_%d\n', subj_num);
    offsetData.startDate = startDateTimeIT;

    if ~isempty(manualMarker)
        % Indice degli elementi NaT
        nanIdx = isnat(memeManualTimestamps);
        % Calcolo delle differenze temporali in minuti rispetto ai marcatori manuali
        timeDifferenceInMinutes = nan(size(memeManualTimestamps));
        timeDifferenceInMinutes(~nanIdx) = ...
            TimeUtility.calculateTimeDifferenceInMinutes(memeManualTimestamps(~nanIdx), memeTimestampEPrime(~nanIdx));
        
        meanOffset = mean(timeDifferenceInMinutes, 'omitnan');
        offsetData.offsetArray = timeDifferenceInMinutes;
        zeroIdx = isnan(timeDifferenceInMinutes);
        timeDifferenceInMinutes(zeroIdx) = meanOffset;
        memeTimestampEPrime = TimeUtility.subtractMinutes(memeTimestampEPrime, timeDifferenceInMinutes);
        restTimestampEPrime = TimeUtility.subtractMinutes(restTimestampEPrime, timeDifferenceInMinutes);
    else
        meanOffset = previousMean;
        offsetData.offsetArray = [];
        memeTimestampEPrime = TimeUtility.subtractMinutes(memeTimestampEPrime, meanOffset);
        restTimestampEPrime = TimeUtility.subtractMinutes(restTimestampEPrime, meanOffset);
    end

    %memeTimestampEPrime = TimeUtility.subtractMinutes(memeTimestampEPrime, meanOffset);
    
    offsetData.meanOffset = meanOffset;
    memeTimestampEPrime.TimeZone = "local";
    restTimestampEPrime.TimeZone = "local";

    meme_eprime_marker = zeros(size(shimmerTimestamps_dateTime,1),1);
    k=1;
    for i=1:size(shimmerTimestamps_dateTime,1)
        if((k <= size(memeTimestampEPrime,1)) && ...
           (shimmerTimestamps_dateTime(i) > memeTimestampEPrime(k)))
            meme_eprime_marker(i) = maxConductance + 1.5;
            k = k+1;
        end
    end 
    rest_eprime_marker = zeros(size(shimmerTimestamps_dateTime,1),1);
    k=1;
    for i=1:size(shimmerTimestamps_dateTime,1)
        if((k <= size(restTimestampEPrime,1)) && ...
           (shimmerTimestamps_dateTime(i) > restTimestampEPrime(k)))
            rest_eprime_marker(i) = maxConductance + 1.5;
            k = k+1;
        end
    end 
end