function linker = getLinkerArray(participantsData, groupTable)
    numParticipants = size(participantsData, 1);
    
    linker = zeros(0, 2);  
    
    for i = 1:numParticipants
        group = participantsData{i}.GruppoMEME;
        memeIDs = table2array(groupTable(:, group));
        
        participantsMEME = [repmat(group, size(memeIDs, 1), 1), memeIDs];
        linker = [linker; participantsMEME];
    end
    
    linker = array2table(linker, 'VariableNames', {'participantsIDs', 'memeIDs'});
    linker = sortrows(linker, 1);
end