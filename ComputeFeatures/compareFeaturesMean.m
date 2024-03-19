function structure_comparison = compareFeaturesMean(struct_features, struct_baseline)
    structure_comparison = struct();
    numFields = numel(fieldnames(struct_features));
    fields = fieldnames(struct_features);
    numSubj = 20;
    numMeme = 24;

    for i = 1:numFields
        currentField = fields{i};
        for j = 1 : numSubj
            startIdx = (j - 1) * numMeme + 1;
            endIdx = j * numMeme;
            for k = startIdx : endIdx
                field_comparison = (struct_features.(currentField)(k) - struct_baseline.(currentField)(j))...
                            / struct_baseline.(currentField)(j);
                structure_comparison.(currentField)(k) = field_comparison;
            end
        end
        
    end
    structure_comparison = structfun(@(x) x', structure_comparison, 'UniformOutput', false);
end

