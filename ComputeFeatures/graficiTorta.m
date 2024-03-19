%%
load('..\CreateDataStructure\DataStructure\finalQuestResults.mat');
load('..\CreateDataStructure\DataStructure\physiologicalDataTable.mat');
load('..\CreateDataStructure\DataStructure\eprime_data_full.mat');
mis = eprimedatafull.Subject_reponse == 1;
notMis = eprimedatafull.Subject_reponse == 2;
offensive = finalQuestResults.Offensive == 1;
notOffensive = finalQuestResults.Offensive == 2;
trublesome = finalQuestResults.Nuisance == 1;
notTrublesome = finalQuestResults.Nuisance == 2;
funny = eprimedatafull.questionTrialRESP == 1;
notFunny = eprimedatafull.questionTrialRESP == 2;
anger = finalQuestResults.Anger >= 2;
disgust = finalQuestResults.Disgust >= 2;
sadness = finalQuestResults.Sadness >= 2;

levMis1 = finalQuestResults.LevOfMisogyny == 1;
levMis2 = finalQuestResults.LevOfMisogyny == 2;
levMis3 = finalQuestResults.LevOfMisogyny == 3;

female = eprimedatafull.Sex == 'female';
male = eprimedatafull.Sex == 'male';

%%
% Colori per le categorie
colorsMisoginia = [1.0000 0.5529 0.4392; 0.6667 0.8902 0.5882];
colorsDivertimento = [0.9 0.9 0.7; 0.8 0.7 1];
colorsDivertimentoMisoginia = [1.0000 0.5529 0.4392; 0.6667 0.8902 0.5882];
colorsDivertimentoNonMisoginia = [1.0000    0.7882    0.7882; 0.9804    0.6157    0.6157];
figure('units','normalized','outerposition',[0 0 1 1]);
% Create pie chart for the category "Misoginia"
ax1 = subplot(2, 2, 1);
num_mis = sum(mis);
num_notMis = sum(notMis);
plotPie2Label(ax1, [num_mis, num_notMis], 'Misoginia', colorsMisoginia, {'Misogino', 'Non misogino'});

% Create pie chart for the category "Divertimento"
ax2 = subplot(2, 2, 2);
num_funny = sum(funny);
num_notFunny = sum(notFunny);
plotPie2Label(ax2, [num_funny, num_notFunny], 'Divertimento', colorsDivertimento, {'Divertente', 'Non divertente'});

% Create pie chart for the category "Divertimento - Misoginia"
ax3 = subplot(2, 2, 3);
funny_mis = sum(funny & mis);
notfunny_mis = sum(notFunny & mis);
plotPie2Label(ax3, [funny_mis, notfunny_mis], 'Divertimento - Misoginia', ...
    colorsDivertimentoMisoginia, {'Misogino e divertente', 'Misogino e NON divertente'});

% Create pie chart for the category "Divertimento - Non Misoginia"
ax4 = subplot(2, 2, 4);
funny_notMis = sum(funny & notMis);
notfunny_notMis = sum(notFunny & notMis);
plotPie2Label(ax4, [funny_notMis, notfunny_notMis], 'Divertimento - Non Misoginia', ...
    colorsDivertimentoNonMisoginia, {'Non misogino e divertente', 'Non misogino e non divertente'});

print('PieChart/misoginia-divertimento.png', '-dpng', '-r300');
%%
clc
figure('units','normalized','outerposition',[0 0 1 1]);
colors = [ 0.6392    0.7882    0.9412; 0.6157    0.8000    0.6275];

ax1 = subplot(2, 2, 1);
misF = sum(mis & female);
misM = sum(mis & male);
plotPie2Label(ax1, [misF, misM], 'Meme misogini', colors, {'Donne', 'Uomini'});

% 
colors = [0.8039    0.8863    0.9686; 
        0.6392    0.7882    0.9412;  
        0.7647    0.9098    0.7725;
        0.6157    0.8000    0.6275];
ax2 = subplot(2, 2, 2);
misFunnyF = sum(funny & mis & female);
misFunnysM = sum(funny & mis & male);
misNotFunnyF = sum(notFunny & mis & female);
misNotFunnysM = sum(notFunny & mis & male);
plotPie4Label(ax2, [misFunnyF,  misNotFunnyF, misFunnysM, misNotFunnysM], ...
    'Misogini divertenti e non divertenti', colors, ...
    {'Divertente - Donna', 'Non divertente - Donna', ...
    'Divertente - Uomo', 'Non divertente - Uomo'});

%
ax3 = subplot(2, 2, 3);
data1 = sum(mis & offensive & female);
data2 = sum(mis & notOffensive & female);
data3 = sum(mis & offensive & male);
data4 = sum(mis & notOffensive & male);
plotPie4Label(ax3, [data1, data2, data3, data4], 'Misogini offensivi - non offensivi', colors, ...
    {'Offensivi - Donna', 'Non offensivi - Donna', ...
    'Offensivi - Uomo', 'Non divertente - Uomo'});


%
ax4 = subplot(2, 2, 4);
data1 = sum(mis & trublesome & female);
data2 = sum(mis & notTrublesome & female);
data3 = sum(mis & trublesome & male);
data4 = sum(mis & notTrublesome & male);
plotPie4Label(ax4, [data1, data2, data3, data4], 'Misogini fastidiosi - non fastidiosi', colors, ...
    {'Fastidioso - Donna', 'Non fastidioso - Donna', ...
    'Fastidioso - Uomo', 'Non fastidioso - Uomo'});

print('PieChart/misoginia-Uomini-Donne.png', '-dpng', '-r300');
%%
figure
colors = [ 0.6392    0.7882    0.9412; 0.6157    0.8000    0.6275];
female = sum(female);
male = sum(male);
pie([female, male]);
colormap(colors);
title('Distribuzione sesso');
legend('Donne', 'Uomini', 'Location', 'best');
print('PieChart/sex_distribution.png', '-dpng', '-r300');
%%
figure
colors = [0.8314    0.9059    0.9804; 0.7098    0.8353    0.9608;...
    0.5686    0.7490    0.9294];
pie([sum(levMis1), sum(levMis2), sum(levMis3)]);
colormap(colors);
title('Distribuzione livelli misoginia');
legend('1', '2', '3', 'Location', 'best');
print('PieChart/misogyny_levels.png', '-dpng', '-r300');

%% FUNCTION
function plotPie2Label(ax, data, titleText, colors, labels)
    pie(ax, data);
    colormap(ax, colors);
    title(ax, titleText);
    legend(ax, labels{1}, labels{2}, 'Location', 'best');
end

function plotPie4Label(ax, data, titleText, colors, labels)
    pie(ax, data);
    colormap(ax, colors);
    title(ax, titleText);
    legend(ax, labels{1}, labels{2}, labels{3}, labels{4}, 'Location', 'best');
end