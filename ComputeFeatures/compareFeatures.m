function structure_comparison = compareFeatures(struct_features, struct_baseline)
    structure_comparison = struct();
    numFields = numel(fieldnames(struct_features));
    fields = fieldnames(struct_features);
    for i = 1:numFields
        currentField = fields{i};
        dim = size(struct_features.(currentField), 1);
        structure_comparison.(currentField) = zeros(dim, 1); % Inizializza la struttura di confronto
        
        for j = 1 : dim
            field_comparison = (struct_features.(currentField)(j) - struct_baseline.(currentField)(j)) ...
                                / struct_baseline.(currentField)(j);
            structure_comparison.(currentField)(j) = field_comparison;
        end
    end
end
