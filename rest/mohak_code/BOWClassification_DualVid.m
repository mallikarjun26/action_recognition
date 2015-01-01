% Author:      Mohak Kumar Sukhwani
% Roll No.:    201307583
% Affiliation: IIIT Hyderabad


%Edit loop counter in vocabBuilt, train,test 

function [accBOW]=BOWClassification_DualVid()
%CALTECHCLASSIFICATION 

addpath('/home/mohak/libsvm-3.17/matlab/');
trainingPer=40;
finalPath='ShotDetection/dense_trajectory_release_v1.2/denseTrajectOp';
 
vocab_size = 2000;
categories=dir(finalPath);

fileId=fopen('newAnn_Sent.ann','r');
Ann=textscan(fileId,'%s %s %s %s %s');

labelsStroke_Up=Ann{:,2};
labelsMov_Up=Ann{:,3};

labelsStroke_Down=Ann{:,4};
labelsMov_Down=Ann{:,5};

uniqueLabels_Up=unique(labelsStroke_Up);
uniqueLabels_Down=unique(labelsStroke_Down);

trainLabelUp=labelsStroke_Up(1:150);
trainLabelDown=labelsStroke_Down(1:150);

testLabelUp=labelsStroke_Up(151:211);
testLabelDown=labelsStroke_Down(151:211);

fclose(fileId);

%SIFT  - Bag Of Word
vocabNameUp='Vocab_Data_Up.mat';
vocabNameDown='Vocab_Data_Down.mat';
if(exist(vocabNameUp,'file') == 0 && exist(vocabNameDown,'file') == 0)
   fprintf('No existing visual word vocabulary found. Computing one from training images\n');
   build_vocabulary_DualVid(vocab_size);
%    save(vocabNameUp,'vocabUp');
%    save(vocabNameDown,'vocabDown');
else
   load(vocabNameUp);
   load(vocabNameDown);
end

%% Vocab Creation
vocabTmp=vocabUp;
vocabTraj=vocabTmp(:,1:30);
vocab=vocabTraj;
save('vocabTrajUp.mat', 'vocab');

vocabHOG=vocabTmp(:,31:126);
vocab=vocabHOG;
save('vocabHOGUp.mat', 'vocab');

vocabHOF=vocabTmp(:,127:234);
vocab=vocabHOF;
save('vocabHOFUp.mat', 'vocab');

vocabMBHx=vocabTmp(:,235:330);
vocab=vocabMBHx;
save('vocabMBHxUp.mat', 'vocab');

vocabMBHy=vocabTmp(:,331:426);
vocab=vocabMBHy;
save('vocabMBHyUp.mat', 'vocab');


vocabTmp=vocabDown;
vocabTraj=vocabTmp(:,1:30);
vocab=vocabTraj;
save('vocabTrajDown.mat', 'vocab');

vocabHOG=vocabTmp(:,31:126);
vocab=vocabHOG;
save('vocabHOGDown.mat', 'vocab');

vocabHOF=vocabTmp(:,127:234);
vocab=vocabHOF;
save('vocabHOFDown.mat', 'vocab');

vocabMBHx=vocabTmp(:,235:330);
vocab=vocabMBHx;
save('vocabMBHxDown.mat', 'vocab');

vocabMBHy=vocabTmp(:,331:426);
vocab=vocabMBHy;
save('vocabMBHyDown.mat', 'vocab');


% image_paths='/home/mohak/lawnTennis/tennisDB/ShotDetection/dense_trajectory_release_v1.2/denseTrajectOp/';
imagePath = 'createDB/';

traiNameUp='trainDataUp.mat';
traiNameDown='trainDataDown.mat';

if(exist(traiNameUp,'file') == 0 && exist(traiNameDown,'file') == 0)
train_image_featsUp=[];
train_image_feats_TrajUp=[];
train_image_feats_HOGUp=[];
train_image_feats_HOFUp=[];
train_image_feats_MBHxUp=[];
train_image_feats_MBHyUp=[];

train_image_featsDown=[];
train_image_feats_TrajDown=[];
train_image_feats_HOGDown=[];
train_image_feats_HOFDown=[];
train_image_feats_MBHxDown=[];
train_image_feats_MBHyDown=[];

display('Train Data');
 for iCount=1:150
     iCount
   
      inpVid=[imagePath num2str(iCount) '.avi'];
      mov=mmreader(inpVid);
      total=mov.NumberOfFrames;
      
      VideoFileUp='UpperVid.avi';
      writerObjUpper = VideoWriter(VideoFileUp);
      fps= 30; 
      writerObjUpper.FrameRate = fps;
      
      VideoFileDown='lowerVid.avi';
      writerObjLower = VideoWriter(VideoFileDown);
      fps= 30; 
      writerObjLower.FrameRate = fps;
      open(writerObjUpper);
      open(writerObjLower);
      %% Play Video
        for i=1:total
            
            img = read(mov,i);
            img = rgb2gray(img); %Convert to gray video
            
            %% Bottom & Lower part
            upperImg=img(1:size(img,1)/2,1:size(img,2));
            writeVideo(writerObjUpper,upperImg);
            
            lowerImg=img((size(img,1)/2)+1:size(img,1),1:size(img,2));
            writeVideo(writerObjLower,lowerImg);
        end     
          
    close(writerObjUpper);
    close(writerObjLower);
     
     upCmd=['dense_trajectory_release_v1.2/release/DenseTrack '  VideoFileUp ' > resultUp.txt'];
     lowerCmd=['dense_trajectory_release_v1.2/release/DenseTrack '  VideoFileDown ' > resultDown.txt'];

     status = unix(upCmd);
     status = unix(lowerCmd);
    
         
     AUp=importdata('resultUp.txt');
     TrajUp=AUp(:,11:40);
     HOGUp=AUp(:,41:136);
     HOFUp=AUp(:,137:244);
     MBHxUp=AUp(:,245:340);
     MBHyUp=AUp(:,341:436);
     
     ADown=importdata('resultDown.txt');
     TrajDown=ADown(:,11:40);
     HOGDown=ADown(:,41:136);
     HOFDown=ADown(:,137:244);
     MBHxDown=ADown(:,245:340);
     MBHyDown=ADown(:,341:436);
     
%      feat=[Traj HOG HOF MBHx MBHy];
%      feat=feat';
     %train_image_feats(iCount,:)=get_bags_of_feat(feat,vocabName);
     
     train_image_feats_TrajUp(iCount,:)=get_bags_of_feat(TrajUp','vocabTrajUp.mat');
     train_image_feats_HOGUp(iCount,:)=get_bags_of_feat(HOGUp','vocabHOGUp.mat');
     train_image_feats_HOFUp(iCount,:)=get_bags_of_feat(HOFUp','vocabHOFUp.mat');
     train_image_feats_MBHxUp(iCount,:)=get_bags_of_feat(MBHxUp','vocabMBHxUp.mat');
     train_image_feats_MBHyUp(iCount,:)=get_bags_of_feat(MBHyUp','vocabMBHyUp.mat');
     
     train_image_feats_TrajDown(iCount,:)=get_bags_of_feat(TrajDown','vocabTrajDown.mat');
     train_image_feats_HOGDown(iCount,:)=get_bags_of_feat(HOGDown','vocabHOGDown.mat');
     train_image_feats_HOFDown(iCount,:)=get_bags_of_feat(HOFDown','vocabHOFDown.mat');
     train_image_feats_MBHxDown(iCount,:)=get_bags_of_feat(MBHxDown','vocabMBHxDown.mat');
     train_image_feats_MBHyDown(iCount,:)=get_bags_of_feat(MBHyDown','vocabMBHyDown.mat');
     
end
 train_image_featsUp=train_image_feats_TrajUp;
 train_image_featsDown=train_image_feats_TrajDown;
 save(traiNameUp, 'train_image_featsUp');
 save(traiNameDown, 'train_image_featsDown');
else
   load(traiNameUp);
   load(traiNameDown);
 
   train_image_feats_TrajUp=train_image_featsUp(:,1:vocab_size);
   train_image_feats_HOGUp=train_image_featsUp(:,vocab_size+1:2*vocab_size);
   train_image_feats_HOFUp=train_image_featsUp(:,2*vocab_size+1:3*vocab_size);
   train_image_feats_MBHxUp=train_image_featsUp(:,3*vocab_size+1:4*vocab_size);
   train_image_feats_MBHyUp=train_image_featsUp(:,4*vocab_size+1:5*vocab_size); 
   
   train_image_feats_TrajDown=train_image_featsDown(:,1:vocab_size);
   train_image_feats_HOGDown=train_image_featsDown(:,vocab_size+1:2*vocab_size);
   train_image_feats_HOFDown=train_image_featsDown(:,2*vocab_size+1:3*vocab_size);
   train_image_feats_MBHxDown=train_image_featsDown(:,3*vocab_size+1:4*vocab_size);
   train_image_feats_MBHyDown=train_image_featsDown(:,4*vocab_size+1:5*vocab_size); 
end



testNameUp='testDataUp.mat';
testNameDown='testDataDown.mat';
if(exist(testNameUp,'file') == 0 && exist(testNameDown,'file') == 0) 
test_image_feats_TrajUp=[];
test_image_feats_HOGUp=[];
test_image_feats_HOFUp=[];
test_image_feats_MBHxUp=[];
test_image_feats_MBHyUp=[];

test_image_feats_TrajDown=[];
test_image_feats_HOGDown=[];
test_image_feats_HOFDown=[];
test_image_feats_MBHxDown=[];
test_image_feats_MBHyDown=[];

display('Test Data');
for iCount=151:211
     iCount
     inpVid=[imagePath num2str(iCount) '.avi'];
      mov=mmreader(inpVid);
      total=mov.NumberOfFrames;
      
      VideoFileUp='UpperVid.avi';
      writerObjUpper = VideoWriter(VideoFileUp);
      fps= 25; 
      writerObj.FrameRate = fps;
      
      VideoFileDown='lowerVid.avi';
      writerObjLower = VideoWriter(VideoFileDown);
      fps= 25; 
      writerObj.FrameRate = fps;
      open(writerObjUpper);
      open(writerObjLower);
      %% Play Video
        for i=1:total
            
            img = read(mov,i);
            
            %% Bottom & Lower part
            upperImg=img(1:size(img,1)/2,1:size(img,2),:);
            writeVideo(writerObjUpper,im2frame(upperImg));
            
            
            lowerImg=img((size(img,1)/2)+1:size(img,1),1:size(img,2),:);
            writeVideo(writerObjLower,im2frame(lowerImg));
        end     
          
    close(writerObjUpper);
    close(writerObjLower);
     
     upCmd=['dense_trajectory_release_v1.2/release/DenseTrack '  VideoFileUp ' > resultUp.txt'];
     lowerCmd=['dense_trajectory_release_v1.2/release/DenseTrack '  VideoFileDown ' > resultDown.txt'];

     status = unix(upCmd);
     status = unix(lowerCmd);
    
         
     AUp=importdata('resultUp.txt');
     TrajUp=AUp(:,11:40);
     HOGUp=AUp(:,41:136);
     HOFUp=AUp(:,137:244);
     MBHxUp=AUp(:,245:340);
     MBHyUp=AUp(:,341:436);
     
     ADown=importdata('resultDown.txt');
     TrajDown=ADown(:,11:40);
     HOGDown=ADown(:,41:136);
     HOFDown=ADown(:,137:244);
     MBHxDown=ADown(:,245:340);
     MBHyDown=ADown(:,341:436);
     
     
     test_image_feats_TrajUp(iCount-150,:)=get_bags_of_feat(TrajUp','vocabTrajUp.mat');     %%CHANGE here too if test image index changes
     test_image_feats_HOGUp(iCount-150,:)=get_bags_of_feat(HOGUp','vocabHOGUp.mat');
     test_image_feats_HOFUp(iCount-150,:)=get_bags_of_feat(HOFUp','vocabHOFUp.mat');
     test_image_feats_MBHxUp(iCount-150,:)=get_bags_of_feat(MBHxUp','vocabMBHxUp.mat');
     test_image_feats_MBHyUp(iCount-150,:)=get_bags_of_feat(MBHyUp','vocabMBHyUp.mat');
     
     test_image_feats_TrajDown(iCount-150,:)=get_bags_of_feat(TrajDown','vocabTrajDown.mat');     %%CHANGE here too if test image index changes
     test_image_feats_HOGDown(iCount-150,:)=get_bags_of_feat(HOGDown','vocabHOGDown.mat');
     test_image_feats_HOFDown(iCount-150,:)=get_bags_of_feat(HOFDown','vocabHOFDown.mat');
     test_image_feats_MBHxDown(iCount-150,:)=get_bags_of_feat(MBHxDown','vocabMBHxDown.mat');
     test_image_feats_MBHyDown(iCount-150,:)=get_bags_of_feat(MBHyDown','vocabMBHyDown.mat');
     
end
  test_image_featsUp=[test_image_feats_TrajUp test_image_feats_HOGUp test_image_feats_HOFUp test_image_feats_MBHxUp test_image_feats_MBHyUp];
  test_image_featsDown=[test_image_feats_TrajDown test_image_feats_HOGDown test_image_feats_HOFDown test_image_feats_MBHxDown test_image_feats_MBHyDown];
  save(testNameUp, 'test_image_featsUp');
  save(testNameDown, 'test_image_featsDown');
  
else
   load(testNameUp);
   load(testNameDown);
   test_image_feats_TrajUp=test_image_featsUp(:,1:vocab_size);
   test_image_feats_HOGUp=test_image_featsUp(:,vocab_size+1:2*vocab_size);
   test_image_feats_HOFUp=test_image_featsUp(:,2*vocab_size+1:3*vocab_size);
   test_image_feats_MBHxUp=test_image_featsUp(:,3*vocab_size+1:4*vocab_size);
   test_image_feats_MBHyUp=test_image_featsUp(:,4*vocab_size+1:5*vocab_size);
   
   test_image_feats_TrajDown=test_image_featsDown(:,1:vocab_size);
   test_image_feats_HOGDown=test_image_featsDown(:,vocab_size+1:2*vocab_size);
   test_image_feats_HOFDown=test_image_featsDown(:,2*vocab_size+1:3*vocab_size);
   test_image_feats_MBHxDown=test_image_featsDown(:,3*vocab_size+1:4*vocab_size);
   test_image_feats_MBHyDown=test_image_featsDown(:,4*vocab_size+1:5*vocab_size);
end

accBOW=zeros(1,2);
for kCount=1:2
    
 if kCount==1
     train_image_feats_Traj=train_image_feats_TrajUp;
     train_image_feats_HOG=train_image_feats_HOGUp;
     train_image_feats_HOF=train_image_feats_HOFUp;
     train_image_feats_MBHx=train_image_feats_MBHxUp;
     train_image_feats_MBHy=train_image_feats_MBHyUp;
     
     test_image_feats_Traj=test_image_feats_TrajUp;
     test_image_feats_HOG=test_image_feats_HOGUp;
     test_image_feats_HOF=test_image_feats_HOFUp;
     test_image_feats_MBHx=test_image_feats_MBHxUp;
     test_image_feats_MBHy=test_image_feats_MBHyUp;
     
     train_labels=trainLabelUp;
     test_labels=testLabelUp;    
 else
     train_image_feats_Traj=train_image_feats_TrajDown;
     train_image_feats_HOG=train_image_feats_HOGDown;
     train_image_feats_HOF=train_image_feats_HOFDown;
     train_image_feats_MBHx=train_image_feats_MBHxDown;
     train_image_feats_MBHy=train_image_feats_MBHyDown;
     
     test_image_feats_Traj=test_image_feats_TrajDown;
     test_image_feats_HOG=test_image_feats_HOGDown;
     test_image_feats_HOF=test_image_feats_HOFDown;
     test_image_feats_MBHx=test_image_feats_MBHxDown;
     test_image_feats_MBHy=test_image_feats_MBHyDown;
     
     train_labels=trainLabelDown;
     test_labels=testLabelDown;
 end
 
dist_Train_Traj=pdist2(train_image_feats_Traj,train_image_feats_Traj,@distChiSq);
dist_Train_HOG=pdist2(train_image_feats_HOG,train_image_feats_HOG,@distChiSq);
dist_Train_HOF=pdist2(train_image_feats_HOF,train_image_feats_HOF,@distChiSq);
dist_Train_MBHx=pdist2(train_image_feats_MBHx,train_image_feats_MBHx,@distChiSq);
dist_Train_MBHy=pdist2(train_image_feats_MBHy,train_image_feats_MBHy,@distChiSq);
sigma=mean([mean(mean(dist_Train_Traj)) mean(mean(dist_Train_HOG)) mean(mean(dist_Train_HOF)) mean(mean(dist_Train_MBHx)) mean(mean(dist_Train_MBHy))]);
dist_Train_Train=dist_Train_Traj+dist_Train_HOG+dist_Train_HOF+dist_Train_MBHx+dist_Train_MBHy;

dist_Train_Test_Traj=pdist2(train_image_feats_Traj,test_image_feats_Traj,@distChiSq);
dist_Train_Test_HOG=pdist2(train_image_feats_HOG,test_image_feats_HOG,@distChiSq);
dist_Train_Test_HOF=pdist2(train_image_feats_HOF,test_image_feats_HOF,@distChiSq);
dist_Train_Test_MBHx=pdist2(train_image_feats_MBHx,test_image_feats_MBHx,@distChiSq);
dist_Train_Test_MBHy=pdist2(train_image_feats_MBHy,test_image_feats_MBHy,@distChiSq);
dist_Train_Test=dist_Train_Test_Traj+dist_Train_Test_HOG+dist_Train_Test_HOF+dist_Train_Test_MBHx+dist_Train_Test_MBHy;

dist_Test_Train_Traj=pdist2(test_image_feats_Traj,train_image_feats_Traj,@distChiSq);
dist_Test_Train_HOG=pdist2(test_image_feats_HOG,train_image_feats_HOG,@distChiSq);
dist_Test_Train_HOF=pdist2(test_image_feats_HOF,train_image_feats_HOF,@distChiSq);
dist_Test_Train_MBHx=pdist2(test_image_feats_MBHx,train_image_feats_MBHx,@distChiSq);
dist_Test_Train_MBHy=pdist2(test_image_feats_MBHy,train_image_feats_MBHy,@distChiSq);
dist_Test_Train=dist_Test_Train_Traj+dist_Test_Train_HOG+dist_Test_Train_HOF+dist_Test_Train_MBHx+dist_Test_Train_MBHy;



numTrain = size(train_labels,1);
numTest = size(test_labels,1);
tmp=exp(-(1/sigma) .* dist_Train_Test);
K =  [ (1:numTrain)',exp(-(1/sigma) .* dist_Train_Train)]

max(max(K))
min(min(K))
KK = [ (1:numTest)',exp(-(1/sigma) .* dist_Test_Train)];


categories = unique(train_labels); 
num_categories = length(categories);

train_labels_ind=zeros(size(train_labels,1),size(train_labels,2));
test_labels_ind=zeros(size(test_labels,1),size(test_labels,2));

for iCount=1:num_categories
    [ind]=find(strcmp(train_labels,categories(iCount)));
    train_labels_ind(ind)=iCount;
    
    [ind]=find(strcmp(test_labels,categories(iCount)));
    test_labels_ind(ind)=iCount;
end


% model = svmtrain(train_labels_ind, K, '-t 4 -b 1');
% 
%  if kCount==1
%   save('modelUp.mat','model');    
%  else
%    save('modelDown.mat','model'); 
%  end
% 
% [predClass, acc, decVals] = svmpredict(test_labels_ind, KK, model);
% C = confusionmat(test_labels_ind,predClass)
% 
% 
% accBOW(1,kCount)=acc(1);

if kCount==1
 uniqueSym=uniqueLabels_Up;
 symbName=uniqueSym;
 modelFolder='modelsUp/'
else
 uniqueSym=uniqueLabels_Down;
 symbName=uniqueSym;
 modelFolder='modelsDown/'   
end
%% Create Model for each class
for iCount=1:length(uniqueSym)
    posData=[];
    negData=[];
    posLabels=[];
    negLabels=[];
    
    presentClass=uniqueSym{iCount}
    modelName=[modelFolder presentClass '_model.mat'];
    if(~exist(modelName,'file'))
      %  [row,col]=find(ismember(symbName,presentClass));
        [row,col]=find(train_labels_ind==iCount);
        posData=K(row,:);
        
        mCount=1;
        for jCount=1:size(K,1)
            if(~ismember(row,jCount))
                negData(mCount,:)= K(jCount,:);
                mCount=mCount+1;
            end
        end
        
        posLabels=ones(length(row),1);
        negLabels=-1*ones(mCount-1,1);
        
        totalVect=[posData;negData];
        totalLabel=[posLabels;negLabels];
        
        display('Training... Model!!');
        model = svmtrain(double(totalLabel), K, '-q -b 1 -t 4 -c 1');
        save(modelName,'model');
    else
        load(modelName);
    end
    
    
    
end


 



end

end




