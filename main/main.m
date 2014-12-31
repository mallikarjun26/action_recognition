

%% Initialization
conf.rootDir         = '/Users/mallikarjun/Documents/action_recognition';
conf.dataSet         = 'UCF50';
conf.trainPer        = 0.7;
conf.testPer         = 0.3;
conf.words           = 4000;

conf.vocabPath       = [conf.rootDir '/results/' conf.dataSet '/vocab/vocab.mat'];



%% Build vocabulary
build_vocabulary(conf);


%% Build feature vectors for each category



%% Train SVM



%% Test 
