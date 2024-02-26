clc
clear all

%% creo cartelle
inputPath = 'C:\Users\lisac\Desktop\LABELLING_MEME\';
file_name = 'labelling_MERGED.xlsx';
table = readtable(file_name);

root_path = "C:\Users\lisac\Desktop\MEME_OK\";
not_mis_out = root_path + "NonMisogini\";
mkdir(not_mis_out);
misogynous_fold = root_path + "Misogini\";
mkdir(strcat(misogynous_fold, "shaming"));
mkdir(strcat(misogynous_fold, "violence"));
mkdir(strcat(misogynous_fold, "stereotype"));
mkdir(strcat(misogynous_fold, "objectification"));
mkdir(strcat(misogynous_fold, "no_category"));

%% in base alle label assegnate inserisco i meme nelle cartelle corrispondenti
clc
MEME_names = string(table.newName);
misogynous = string(table.misogynous);
misogynous2 = string(table.misogynous2);
usable = string(table.usable);
usable2 = string(table.usable2);

for i = 1 : size(table, 1)
   % if( usable(i) == 'X' && usable2(i) == 'X')
        source = strcat(inputPath, MEME_names(i));

        if(misogynous(i) == misogynous2(i))
            if(misogynous(i) == "N")
                destination = strcat(not_mis_out, MEME_names(i));
            else
                if(isX(table.shaming(i)) && isX(table.shaming2(i)))
                    category_folder = "shaming\";
                elseif(isX(table.violence(i)) && isX(table.violence2(i)))
                    category_folder = "violence/";
                elseif(isX(table.stereotype(i)) && isX(table.stereotype2(i)))
                    category_folder = "stereotype/";
                elseif(isX(table.objectification(i)) && isX(table.objectification2(i)))
                    category_folder = "objectification/";
                else
                    category_folder = "no_category/";
                end

                destination = strcat(misogynous_fold, category_folder, ...
                                    MEME_names(i));
            end
            if(source ~= destination)
                copyfile (source, destination);
            end
        end
    %end
end

clearvars -except table