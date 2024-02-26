clc
clear all

%%
inputPath = 'G:\.shortcut-targets-by-id\1FdgroAxFBWDw1MPovtITB4eUsgVq_D0v\00_MEME PROGETTO CON PSICOLOGIA\dataset labelling\MEME_OK\_standardized';
%%
n = 96;
ID = (1:n)';
FileName = strings(n,1);
Misogynous = zeros(n,1);
Objectification = zeros(n,1);
Shaming = zeros(n,1);
Stereotype = zeros(n,1);
Violence = zeros(n,1);
%%
clc
folderList    = UtilityClass.getFolderList(inputPath);
misogynousFolder = UtilityClass.getFolderList(inputPath + "\" + folderList{1,1});
notMisogynous = UtilityClass.getFileList(inputPath + "\" + folderList{1,2});
%% notMisogynous
for i = 1 : size(notMisogynous,2)
    FileName(i,1) = notMisogynous(i);
end
i = i+1;
Misogynous(i:end) = 1;

%% 
for f = 1 : size(misogynousFolder,2)
    fileList = UtilityClass.getFileList(inputPath + "\" + folderList{1,1} + "\" + misogynousFolder{1,f});
    for j = 1:size(fileList,2)
        FileName(i,1) = fileList(j);
       
        if (misogynousFolder{1,f} == "objectification")
            Objectification(i) = 1;
        elseif (misogynousFolder{1,f} == "shaming")
            Shaming(i) = 1;
        elseif (misogynousFolder{1,f} == "stereotype")
            Stereotype(i) = 1;
        else
            Violence(i) = 1;
        end
        i = i+1;
    end
end

%%
clc
clearvars table
table = table(ID, FileName, Misogynous, Objectification, Shaming, ...
    Stereotype, Violence);

writetable(table, "tabella.xlsx");