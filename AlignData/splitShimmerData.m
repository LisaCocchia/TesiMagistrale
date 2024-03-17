function [shimmerTimestampSyncUnix, skinConductance, skinResistance, PPG] = splitShimmerData(shimmerData, n)
    if((n ~= 14) && (n ~= 15) && (n ~= 16) && (n ~= 17)) 
        shimmerTimestampSyncUnix = shimmerData.Shimmer_5E8A_TimestampSync_Unix_CAL;
        skinConductance = shimmerData.Shimmer_5E8A_GSR_Skin_Conductance_CAL;
        skinResistance = shimmerData.Shimmer_5E8A_GSR_Skin_Resistance_CAL;
        PPG = shimmerData.Shimmer_5E8A_PPG_A13_CAL; 
    else
        shimmerTimestampSyncUnix = shimmerData.Shimmer_8965_TimestampSync_Unix_CAL;
        skinConductance = shimmerData.Shimmer_8965_GSR_Skin_Conductance_CAL;
        skinResistance = shimmerData.Shimmer_8965_GSR_Skin_Resistance_CAL;
        PPG = shimmerData.Shimmer_8965_PPG_A13_CAL;  
    end
end