function getImDenseFeatures(path)

  %% Initialization
  dataset = 'hmdb51';
  datasetPath = [path '/datasets' dataset];
  featuresPath = [path '/results/features']; 

  %% Check if features are already generated
  if(exist(featuresPath, 'dir') == 7)
    print('Features folder already generated!');
  else
    mkdir(featuresPath);
  end
  
  
  %% Iterate over all folders 
  classesName       = dir(datasetPath);
  classesName       = classesName(3:size(classesName,1),:);
  numberOfClasses   = size(classesName,1);
  
  for i=1:numberOfClasses
    classPath          = [datasetPath '/' classesName(i).name ];
    samplesName        = dir(classPath);
    samplesName        = samplesName(3:size(samplesName),:);
    numberOfSamples    = size(samplesName, 1);
    resultClassPath    = [featuresPath '/' classesName(i).name ];
    mkdir(resultClassPath);
    
    for j=1:numberOfSamples
      
    end
    
  end
  

end