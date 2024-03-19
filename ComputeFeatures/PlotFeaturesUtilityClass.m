classdef PlotFeaturesUtilityClass
    
    methods (Static)
        
        function save(fig, imagePath, titolo)
            createDirectoryIfNotExists(imagePath);
            saveas(fig, fullfile(imagePath, [titolo, '.png']), 'png');
        end

        function label = getMisogynyLabel(answer)
            if answer == 1
                label = 'mis';
            else
                label = 'notMis';
            end
        end

        function plotCompareSignalSubj(signalStructure, PlotDirectory, plotTitle, VIEW_PLOT, colors, sex)
            paramNames = fieldnames(signalStructure);
            numParams = numel(paramNames);

            h = waitbar(0, 'Progress...', 'Name', plotTitle);
            numIterations = numParams;

            for i = 1:numParams
                PlotFeaturesUtilityClass.plotCompareSubj(signalStructure, paramNames{i}, PlotDirectory, plotTitle, VIEW_PLOT, colors, sex);
                waitbar(i / numIterations, h, sprintf('Progress... %d%%', round(i / numIterations * 100)));
            end
            close(h);
        end

        function plotCompareSubj(signalCompare, paramName, PlotDirectory, plotTitle, VIEW_PLOT, colors, sex)
            vettore = signalCompare.(paramName);
            numSubj = 20;
            numMeme = 24;

            fig = figure('WindowState', 'maximized', 'visible', VIEW_PLOT, 'Position', get(0, 'Screensize'));
            
            for i = 1:numSubj
                startIdx = (i - 1) * numMeme + 1;
                endIdx = i * numMeme;
                subsetVettore = vettore(startIdx:endIdx);
      
                subplot(4, 5, i);
                subsetVettore(subsetVettore == -1) = 0;
                bar(subsetVettore, 'FaceColor', 'flat', 'CData', colors(startIdx:endIdx, :));
                xlabel('Memes');
                idx = (i - 1) * numMeme + 1;
                title(['subject', num2str(i + (i >= 9)), '(', sex(idx), ')']);
            end
            plotTitle = [paramName '-' plotTitle];
            disp(plotTitle);
            sgtitle(plotTitle, 'Interpreter', 'none');
            PlotFeaturesUtilityClass.save(fig, PlotDirectory, plotTitle);
        end

        function plotCompareSignalMeme(signalStructure, linker, PlotDirectory, plotTitle, VIEW_PLOT, colors, misogynyLabels)
            numberOfMemes = 96;
            h = waitbar(0, 'Progress...', 'Name', plotTitle);
            numIterations = numberOfMemes;

            for i = 1:numberOfMemes
                indexes = find(linker.memeIDs == i);
                misogynyLabel = PlotFeaturesUtilityClass.getMisogynyLabel(misogynyLabels(i));
                PlotFeaturesUtilityClass.plotCompareMeme(signalStructure, indexes, PlotDirectory, [plotTitle, ' - meme ', num2str(i), misogynyLabel], VIEW_PLOT, colors);
                waitbar(i / numIterations, h, sprintf('Progress... %d%%', round(i / numIterations * 100)));
            end
            close(h);
        end

        function plotCompareMeme(signalStructure, indexes, PlotDirectory, plotTitle, VIEW_PLOT, colors)
            paramNames = fieldnames(signalStructure);
            numParams = numel(paramNames);
            cP = floor(numParams/3) + 1;
            rP = ceil(numParams/cP);
            fig = figure('visible', VIEW_PLOT, 'units', 'normalized', 'outerposition', [0 0 1 1]);
            
            for i = 1:numParams
                subplot(rP, cP, i);
                bar(signalStructure.(paramNames{i})(indexes), 'FaceColor', 'flat', 'CData', colors(indexes, :));
                xlabel('Subjects');
                ylabel(paramNames{i}, 'Interpreter', 'none');
            end
            sgtitle(plotTitle, 'Interpreter', 'none');
            PlotFeaturesUtilityClass.save(fig, PlotDirectory, plotTitle);
        end
        
        
        function colors = generateColorsVector(values)
            colors = zeros(size(values, 1), 3);
        
             % Definisci i colori
            neutralColor = [0.2588 0.2588 0.2588];
            evidenceColor = [0.6350 0.0780 0.1840];
        
            for i = 1:numel(values)
                if values(i) == 1
                    colors(i, :) = evidenceColor;
                elseif values(i) == 0 || values(i) == 2
                    colors(i, :) = neutralColor;
                end
            end
        end

    end

end