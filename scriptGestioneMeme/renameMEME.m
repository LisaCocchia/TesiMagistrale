clear allc
lc

oldFolderPath   = 'G:\.shortcut-targets-by-id\1FdgroAxFBWDw1MPovtITB4eUsgVq_D0v\00_MEME PROGETTO CON PSICOLOGIA\00_dataset MEME\Dataset meme italiani (1888)\';
newFolderPath   = 'G:\.shortcut-targets-by-id\1FdgroAxFBWDw1MPovtITB4eUsgVq_D0v\00_MEME PROGETTO CON PSICOLOGIA\dataset labelling\LABELLING_MEME\';

fileList    = dir([oldFolderPath, '/*.jpg']);
nFiles      = size(fileList, 1);

name_cell   = {fileList.name};

%% Creo array contente vecchi e nuovi nomi

rand = randperm(nFiles, nFiles);

for i = 1 : nFiles
    str = convertCharsToStrings(name_cell{i});
    oldName(i) = str;
    newName(i) = strcat("meme_", num2str(rand(i), '%04.f'), ".jpg");
end

namesRelations = [oldName; newName];

%% Rinomino i file

for i = 1 : nFiles
    source = strcat(oldFolderPath, namesRelations(1,i));
    destination = strcat(newFolderPath, namesRelations(2,i));
    if(source ~= destination)
        movefile (source, destination);
    end
end
clearvars -except namesRelations nFiles newFolderPath

%% Save the relationships between the names in an excel file

headers = ["oldName" "newName"];
namesRelations = namesRelations';
data = [headers; namesRelations(:, 1) namesRelations(:, 2)];

save('data/names_relations_array', 'namesRelations');
writematrix(data,"data/MEME_Names_Relations.xlsx",'Sheet',1)
