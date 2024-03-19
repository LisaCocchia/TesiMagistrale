classdef PlotClass

    methods(Static)
        function save(fig, imagePath, titolo)
            createDirectoryIfNotExists(imagePath);
            saveas(fig, [imagePath '/' titolo '.fig']);
            saveas(fig, [imagePath '/' titolo '.png'], 'png');
        end

        function label = getMisogynyLabel(answer)
            if answer == 1
                label = 'mis';
            else
                label = 'notMis';
            end
        end

        function plotDataPerSubject(subjectNumber, columnName, dataTable, finalQuestResults, linker, SAVE_PLOT, imagePath, VIEW_PLOT)

            % Calcola gli indici delle righe per il soggetto specificato
            startRow = find(linker.participantsIDs == subjectNumber, 1);
            endRow = find(linker.participantsIDs == subjectNumber, 1) + 23;

            if ~isempty(startRow)
                data = dataTable.(columnName)(startRow:endRow);
                misogynyLabel = finalQuestResults.Misogyny(startRow:endRow);
                IDMeme = finalQuestResults.ID(startRow:endRow);

                % Creazione di 24 subplot
                fig = figure('WindowState', 'maximized', 'visible', VIEW_PLOT, ...
                    'Position',  get(0, 'Screensize'));
                for i = 1:24
                    subplot(4, 6, i);
                    plot(data{i,1});
                    misogyny = PlotClass.getMisogynyLabel(misogynyLabel(i));

                    title(['Meme', num2str(IDMeme(i)), ...
                        '(', misogyny ,')']);
                    titolo = [columnName, ' - Subject ', num2str(subjectNumber)];
                    sgtitle(titolo, 'Interpreter', 'none');
                end

                if(SAVE_PLOT)
                    PlotClass.save(fig, imagePath, titolo);
                end
            end
        end

        function plotDataPerMEME(memeID, columnName, dataTable, finalQuestResults, ...
                linker, SAVE_PLOT, imagePath, VIEW_PLOT)
            % Calcola gli indici delle righe per il soggetto specificato
            indexes = find(linker.memeIDs == memeID);
            numSubplots = size(indexes,1);

            data = dataTable.(columnName)(indexes);
            misogynyLabel = finalQuestResults.("Misogyny")(indexes);
            subjectsNumber = linker.participantsIDs(indexes);

            fig = figure('WindowState', 'maximized', 'visible', VIEW_PLOT, ...
                'Position',  get(0, 'Screensize'));
            for i = 1:numSubplots
                subplot(2, ceil(numSubplots/2), i);
                plot(data{i,1});
                misogyny = PlotClass.getMisogynyLabel(misogynyLabel(i));

                title(['Subject', num2str(subjectsNumber(i)), ...
                    '(', misogyny ,')']);
                titolo = [columnName, ' - Meme ', num2str(memeID)];
                sgtitle(titolo, 'Interpreter', 'none');
            end
            if(SAVE_PLOT)
                PlotClass.save(fig, imagePath, titolo);
            end
        end
    
    end % method
end