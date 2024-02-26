clc
clear all
%%
source_root = 'C:\Users\lisac\Desktop\SELECTED_MEME\';
root = 'C:\Users\lisac\Desktop\';

%% 
clc
[selectedMEME_tab, randomgroups_tab] = importData();

randomgroups = table2array(randomgroups_tab);
selectedMEME = table2array(selectedMEME_tab);
clear selectedMEME_tab randomgroups_tab

%%
clc

for i = 1 : size(randomgroups,2)
    for j = 1 : size(randomgroups,1)
        num = randomgroups(j,i);
        meme_name = findMEME(selectedMEME, num);
        randomgroups_meme(j,i) = meme_name;
        id(j,i) = getQualtricsID(QualtricsID, meme_name);
    end
end

%%
id_t = array2table(id);
writetable(id_t,'id.xls');  
%%

function  meme_name = findMEME (selectedMEME, id)
    for i = 1 : size(selectedMEME,1)
        if(double(selectedMEME(i,1)) == id)
            meme_name = selectedMEME(i,2);
            return
        end
    end
end

function  Q_ID = getQualtricsID(table, name)
    for i = 1 : size(table,1)
        if(table(i,1) == name)
            Q_ID = table(i,2);
            return
        end
    end
end