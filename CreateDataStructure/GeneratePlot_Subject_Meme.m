SAVE_PLOT = true;
VIEW_PLOT = false;

subjectPlotDirectoryRoot = 'Plot/Subject';

load('DataStructure\workspace_data.mat')
columnNames = physiologicalDataTable.Properties.VariableNames;
numberOfSubject = 20;

%%
h = waitbar(0, 'Progress...', 'Name', 'Plot data per subject');
num_iterations = numberOfSubject;

for i = 1:numberOfSubject
    for j = 1:numel(columnNames)
        path = fullfile(subjectPlotDirectoryRoot, columnNames{j});
        PlotClass.plotDataPerSubject(i, columnNames{j}, physiologicalDataTable, ...
            finalQuestResults, linker, SAVE_PLOT, path, VIEW_PLOT);

        waitbar(i / num_iterations, h, sprintf('Progress... %d%%', round(i / num_iterations * 100)));
    end
end
close(h);
%%
clc
memePlotDirectoryRoot = 'Plot/MEME';
numberOfMeme = 96;
h = waitbar(0, 'Progress...', 'Name', 'Plot data per subject');
num_iterations = numberOfMeme;

for i = 1:numberOfMeme 
    for j = 1:numel(columnNames)
        path = fullfile(memePlotDirectoryRoot, columnNames{j});
        PlotClass.plotDataPerMEME(i, columnNames{j}, physiologicalDataTable, ...
            finalQuestResults, linker, SAVE_PLOT, path, VIEW_PLOT);

        waitbar(i / num_iterations, h, sprintf('Progress... %d%%', round(i / num_iterations * 100)));
    end
end
close(h);
