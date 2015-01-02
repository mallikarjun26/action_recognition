

%% Initialization
conf.rootDir         = '/home/altereye/Documents/CV/action_recognition';
conf.dataSet         = 'hmdb51';
conf.numberOfWords   = 4000;

conf.featuresPath    = [conf.rootDir '/results/' conf.dataSet '/features'];
conf.vocabPath       = [conf.rootDir '/results/' conf.dataSet '/vocab/vocab.mat'];

%% Build vocabulary
build_vocabulary(conf);


%% Build feature vectors for each category



%% Train SVM



%% Test 
