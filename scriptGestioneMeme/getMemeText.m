clc
root_folder = 'G:\.shortcut-targets-by-id\1FdgroAxFBWDw1MPovtITB4eUsgVq_D0v\00_MEME PROGETTO CON PSICOLOGIA\dataset labelling\SELECTED_MEME';

files = dir(fullfile(root_folder, '**', '*.jpg'));

data = cell(numel(files), 4);
roi = [0, 620, 767, 767];

for i = 1:numel(files)
    path = fullfile(files(i).folder, files(i).name);
    
    image = imcrop(imread(path), roi);
    ocr_parse = ocr(image, 'language', 'ita');
    
    ocr_text = strtrim(ocr_parse.Text);
    ocr_text = regexprep(ocr_text,'\n',' ');

    data{i, 1} = files(i).name; 
    data{i, 2} = ocr_text; 
    num_characters = sum(~isspace(ocr_text));
    data{i, 3} = num_characters;
    num_words = numel(strsplit(ocr_text));
    data{i, 4} = num_words;
    
end
%%
tableData = cell2table(data, 'VariableNames', {'FileName', 'OCRText', 'NumCharacters', 'NumWords'});
writetable(tableData, "memeText.xlsx");