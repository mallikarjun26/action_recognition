function build_vocabulary(conf)
    

    %% If vocabulary file already exists, return
    if(exist(conf.vocabPath, 'file') == 2)
        return;
    end
    
    %% Pull out random 100,000 features for each of the Traj, HoG, HoF, MBHx, MBHy features to build vocab
    datasetDir = [conf.rootDir '/' conf.dataSet];
    classes = dir(datasetDir);
    classes = classes(3:size(classes,1),:);
    
    
    
    
    %% Quantize the features
    
    
    
    %% Save the vocabulary
    
    
    
    

    if ~exist(conf.vocabPath) || conf.clobber
        % Get some PHOW descriptors to train the dictionary
        selTrainFeats = vl_colsubset(selTrain, 30) ;
        descrs = {} ;

        %for ii = 1:length(selTrainFeats)
        parfor ii = 1:length(selTrainFeats)
            im = imread(fullfile(conf.calDir, images{selTrainFeats(ii)})) ;
            im = standarizeImage(im) ;
            [drop, descrs{ii}] = vl_phow(im, model.phowOpts{:}) ;
        end
        
        descrs = vl_colsubset(cat(2, descrs{:}), 10e4) ;
        descrs = single(descrs) ;
        
        % Quantize the descriptors to get the visual words
        vocab = vl_kmeans(descrs, conf.numWords, 'verbose', 'algorithm', 'elkan', 'MaxNumIterations', 50) ;
        save(conf.vocabPath, 'vocab') ;
    else
        load(conf.vocabPath) ;
    end

    model.vocab = vocab ;

    if strcmp(model.quantizer, 'kdtree')
        model.kdtree = vl_kdtreebuild(vocab) ;
    end

end
