function [meme_manual_marker, memeManualTimestamps] =  ...
createManualMarker(shimmerTimestamps_dateTime, history, manualTimestamp, maxC)

    manualTimestamp.TimeZone = "local";

    meme_manual_marker    = zeros(size(shimmerTimestamps_dateTime,1),1);
    memeManualTimestamps = [];
    k=1;
    for i=1:size(shimmerTimestamps_dateTime,1)
        
        if((k <= size(manualTimestamp,2)) && isnat(manualTimestamp(k)))
            k = k+1;
            memeManualTimestamps =  [memeManualTimestamps; 'NaT'];
        else
            if((k <= size(manualTimestamp,2)) && (shimmerTimestamps_dateTime(i) > manualTimestamp(k)))
                if(history(k) == 'm')
                    meme_manual_marker(i) = maxC;
                    memeManualTimestamps =  [memeManualTimestamps; manualTimestamp(k)];
                end
                k = k+1;
            end
        end
    end
end

