clear all
clc

load('..\..\..\CreateDataStructure\DataStructure\finalQuestResults.mat');
load('..\..\..\CreateDataStructure\DataStructure\physiologicalDataTable.mat');

%%
numHiddenUnits = 100;
numClasses = 2;
maxEpochs = 10;
miniBatchSize = 150;

layers = [ ...
    sequenceInputLayer(1)
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

% options = trainingOptions('adam', ...
%     'MaxEpochs',10, ...
%     'MiniBatchSize', 150, ...
%     'InitialLearnRate', 0.01, ...
%     'SequenceLength', 1000, ...
%     'GradientThreshold', 1, ...
%     'ExecutionEnvironment',"auto",...
%     'plots','training-progress');

%% DATA ROW
labels = categorical(finalQuestResults.Misogyny);

memeData = physiologicalDataTable.skinConductanceMeme;
restData = physiologicalDataTable.skinConductanceRest30s;
numOfRecords = size(memeData,1);
trainData = cell(numOfRecords,1);
for i = 1:numOfRecords
    trainData{i} = [restData{i} memeData{i}];
end

%%
net = trainNetwork(trainData, labels, layers, options);

%%
YPred = classify(net,trainData, ...
    MiniBatchSize=miniBatchSize, ...
    SequenceLength="longest");
acc = sum(YPred == labels)./numel(labels);
disp(acc);
fig = figure();

confusionchart(YTrain,trainPred,'ColumnSummary','column-normalized',...
              'RowSummary','row-normalized','Title','Confusion Chart for LSTM');