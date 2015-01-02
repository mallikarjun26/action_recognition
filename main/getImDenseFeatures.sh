#!/bin/sh

# Initialization
path=$1;
currentPath=$(pwd);
dataset="hmdb51";
datasetPath="$path/datasets/$dataset";
featuresPath="$path/results/$dataset/features"; 
execPath="$currentPath/../rest/trajectories/improved_trajectory_release/release/DenseTrackStab";

# Check if features are already generated
if [ -d "$featuresPath" ] 
then
  echo Features folder already generated!
else
  echo "$featuresPath";
  mkdir -p "$featuresPath"; 
fi

# Iterate over all folders 
cd $datasetPath
for d in */ ; do
  # echo d is $d
  classPath="$datasetPath/$d";
  resultClassPath="$featuresPath/$d";
  # echo $resultClassPath;
  mkdir -p "$resultClassPath";

  cd $classPath
  i=0
  for f in *.avi; do
    i=`expr $i + 1`
    echo i is $i
    echo f is $f
    samplePath="$classPath/$f";
    featurePath="$resultClassPath/$f.txt";
    $execPath $samplePath > $featurePath;
    if [ $i -eq 2 ] 
    then
      break  
    fi
  done
  cd $datasetPath
done
