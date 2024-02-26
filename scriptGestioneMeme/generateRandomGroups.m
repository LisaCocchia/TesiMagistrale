clc
clear all

mat = zeros(12, 40);

i = 1; 
j = 1;

for meme = 1:96
    for n = 1:10
        mat(i,j) = meme;
        j = j+1;
        if (j > 40)
            j = 1;
            i = i+1;
        end
    end
end
%%

names =  strings(1,40);
for i = 1:40
    names(i) = "group" + string(i);
end

table = array2table(mat);

table.Properties.VariableNames = names;
writetable(table, "groups.xlsx");

%% Shuffle matrix

m_rand = mat(:, randperm(size(mat, 2)));

for i = 1:40
    a = m_rand(:,i);
    a_rand = a(randperm(length(a)));
    mat_r(:,i) = a_rand;
end

table = array2table(mat_r);

table.Properties.VariableNames = names;
writetable(table, "random_groups.xlsx");

