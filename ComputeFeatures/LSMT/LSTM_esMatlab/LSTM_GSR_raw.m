clc
clear all
%%
load('..\CreateDataStructure\DataStructure\finalQuestResults.mat');
load('..\CreateDataStructure\DataStructure\physiologicalDataTable.mat');

%%
clc
labels = categorical(finalQuestResults.Misogyny);
%GSR_meme_signal = physiologicalDataTable.skinConductanceMeme;
GSR_meme_signal = cellfun(@transpose,physiologicalDataTable.skinConductanceMeme,'UniformOutput',false);

misX = GSR_meme_signal(labels=='1');
misY = labels(labels=='1');

notMisX = GSR_meme_signal(labels=='2');
notMisY = labels(labels=='2');

%%
clc
labels = categorical(finalQuestResults.Misogyny);
%PPG_meme_signal = physiologicalDataTable.PPGmeme;
PPG_meme_signal = cellfun(@transpose,physiologicalDataTable.PPGmeme,'UniformOutput',false);

misX = PPG_meme_signal(labels=='1');
misY = labels(labels=='1');

notMisX = PPG_meme_signal(labels=='2');
notMisY = labels(labels=='2');

%% Divido i dati in test e train (30 -70)
numMis = numel(labels(labels=='1'));
numNotMis = numel(labels(labels=='2'));

[trainMis,~,testMis] = dividerand(numMis,0.7,0.0,0.3);
[trainNotMis,~,testNotMis] = dividerand(numNotMis,0.7,0.0,0.3);

XTrainMis = misX(trainMis);
YTrainMis = misY(trainMis);

XTrainNotMis = notMisX(trainNotMis);
YTrainNotMis = notMisY(trainNotMis);

XTestMis = misX(testMis);
YTestMis = misY(testMis);

XTestNotMis = notMisX(testNotMis);
YTestNotMis = notMisY(testNotMis);

%% Riunisco portando alla dtessa
numForTrain = size(XTrainNotMis);
XTrainMisDuplicated = XTrainMis(1:numForTrain-size(XTrainMis),1);
YTrainMisDuplicated = YTrainMis(1:numForTrain-size(YTrainMis),1);
XTrain = [[XTrainMis; XTrainMisDuplicated]; XTrainNotMis];
YTrain = [[YTrainMis; YTrainMisDuplicated]; YTrainNotMis];

numForTest = size(XTestNotMis);
XTestMisDuplicated = XTestMis(1:numForTest-size(XTestMis),1);
YTestMisDuplicated = YTestMis(1:numForTest-size(YTestMis),1);
XTest = [[XTestMis; XTestMisDuplicated]; XTestNotMis];
YTest = [[YTestMis; YTestMisDuplicated]; YTestNotMis];
%%
numHiddenUnits = 100;
numClasses = 2;
maxEpochs = 50;
miniBatchSize = 100;
inputLayer = 1;

layers = [ ...
    sequenceInputLayer(inputLayer)
    lstmLayer(numHiddenUnits,'OutputMode','last')
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];

options = trainingOptions( 'adam', ...
    'MaxEpochs', maxEpochs, ...
    'MiniBatchSize', miniBatchSize, ...
    'SequenceLength', 'longest', ...
    'Shuffle', 'never', ...
    'Plot','training-progress');
%%
net = trainNetwork(XTrain,YTrain,layers,options);
%%
trainPred = classify(net,XTrain,'SequenceLength',1000);

LSTMAccuracy = sum(trainPred == YTrain)/numel(YTrain)*100;
disp(LSTMAccuracy);

confusionchart(YTrain,trainPred,'ColumnSummary','column-normalized',...
              'RowSummary','row-normalized','Title','Confusion Chart for LSTM');

%%
testPred = classify(net,XTest,'SequenceLength',1000);

LSTMAccuracy = sum(testPred == YTest)/numel(YTest)*100;
figure
confusionchart(YTest,testPred,'ColumnSummary','column-normalized',...
              'RowSummary','row-normalized','Title','Confusion Chart for LSTM');