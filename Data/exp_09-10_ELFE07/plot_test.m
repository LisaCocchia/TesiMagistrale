



%% Clear temporary variables
clear opts

%%

for i=1:size(timestamp,2)
    timestamp_unix(i) =  milliseconds(timestamp(i));
end

%%
timestamp.TimeZone="local";

%%
dt = createDataTimeShimmer(Shimmer_5E8A_TimestampSync_Unix_CAL);
%%
clc
j=1;
rest =  zeros(size(Shimmer_5E8A_TimestampSync_Unix_CAL));
meme =  zeros(size(Shimmer_5E8A_TimestampSync_Unix_CAL));
marker =  zeros(size(Shimmer_5E8A_TimestampSync_Unix_CAL));

MAX = max(Shimmer_5E8A_GSR_Skin_Conductance_CAL);
for i=1:size(rest)
    
    if(j<=size(timestamp,2) && dt(i) >= timestamp(j))
        if(history(j)=='m')
            meme(i)=MAX;
        elseif (history(j)=='r')
            rest(i)=MAX;
        elseif (history(j)=='i' || history(j)=='f')
            marker(i)=MAX;
        end

        j=j+1;
    end
end

%%
figure
hold on
plot(Shimmer_5E8A_GSR_Skin_Conductance_CAL, 'black');
plot(meme, 'red');
plot(rest, 'blue');
plot(marker);
hold off

legend('Conductance','meme', 'rest', 'start/end');
%%
clc
figure(2)
hold on
plot(Shimmer_5E8A_GSR_Skin_Resistance_CAL, 'black');
plot(meme, 'red');
plot(rest, 'blue');
plot(marker);
hold off

legend('Resistance','meme', 'rest', 'start/end');