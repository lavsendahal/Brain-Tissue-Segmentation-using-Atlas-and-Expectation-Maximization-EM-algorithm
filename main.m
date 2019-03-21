%This is the main function for the Atlas and EM Based segmentation
%algorithms
%MIRA MISA Combined Lab (MAIA 2018)
%Written By: Lavsen Dahal 
%This script runs and displays the results of a particular slice for atlas
%based, em with atlas init and , em with atlas init and tissue model.


clc;
clear all;
close all;

addpath('functions');
addpath(genpath('resultsNIIAtlas'));
addpath(genpath('test-set'));

atlasCSFpath='resultsNIIAtlas/resultsafterTransformixCSF/';
atlasGMpath='resultsNIIAtlas/resultsafterTransformixGM/';
atlasWMpath='resultsNIIAtlas/resultsafterTransformixWM/';


%Modify this to include test-set%
%-------------------------------------------------------------------------%
testGTPath=dir('test-set/testing-labels/*.nii');
testMaskPath= dir('test-set/testing-mask/*.nii');
filesTestingVolume=dir('test-set/testing-images/*.nii');
%-------------------------------------------------------------------------%

atlasCSFfolders=dir(atlasCSFpath);
atlasWMfolders=dir(atlasWMpath);
atlasGMfolders=dir(atlasGMpath);
sumDice=zeros(3,1);
sumDiceAtlas=zeros(3,1);
sumDiceEMtissue=zeros(3,1);
viewSlice=150;
for totalFolders = 1:length(atlasCSFfolders)
    tic;
    % First 3 files are hidden MacOSx files.
     if totalFolders>3
         fprintf('Implementing %d vol \n',totalFolders-3);
         atlasCSFfilepath= strcat('resultsNIIAtlas/resultsafterTransformixCSF/',atlasCSFfolders(totalFolders).name,'/result.nii');
         atlasCSF=niftiread(atlasCSFfilepath);
         atlasWMfilepath= strcat('resultsNIIAtlas/resultsafterTransformixWM/',atlasWMfolders(totalFolders).name,'/result.nii');
         atlasWM=niftiread(atlasWMfilepath);
         atlasGMfilepath= strcat('resultsNIIAtlas/resultsafterTransformixGM/',atlasGMfolders(totalFolders).name,'/result.nii');
         atlasGM=niftiread(atlasGMfilepath);

        testVolume= niftiread(filesTestingVolume(totalFolders-3).name);
        testLabel=niftiread(testGTPath(totalFolders-3).name);
        testMask= niftiread(testMaskPath(totalFolders-3).name);

%-------------------------------------------------------------------------%
%Initialization from Atlas for EM
        [atlasLabel,probAtlas,diceAtlas]= atlasSegmentation(atlasCSF,atlasWM,atlasGM,testLabel,testMask,viewSlice);


        similarityatlasall(:,totalFolders-3)=diceAtlas

        sumDiceAtlas=sumDiceAtlas+diceAtlas;
%Removing all the background 0 from the slices
        fullTestVolume= reshape(testVolume,numel(testVolume),1);
        fullTestMask=reshape(testMask,numel(testMask),1);
        fullAtlasLabel= reshape(atlasLabel,numel(atlasLabel),1);
        fullTestLabel= reshape(testLabel,numel(testLabel),1);

        indexMask0= find(~fullTestMask);
        indexMaskNon0= find(fullTestMask);
        tempTestLabel=fullTestLabel;
        tempTestLabel(indexMask0)=[];

%-------------------------------------------------------------------------%

        [segResult,similarity,member_wt] = em(fullTestVolume,fullAtlasLabel,fullTestLabel,testLabel,indexMask0,indexMaskNon0,viewSlice);
        disp('dice for em');
        similarityEMall(:,totalFolders-3)=similarity

        sumDice=sumDice+similarity;

        member_wt=member_wt'.*probAtlas;
        [~,class]=max(member_wt');
        data_last=zeros(1,length(fullAtlasLabel));

         data_last(indexMask0)=0;
         data_last(indexMaskNon0)=class;
         sizeTestLabel=size(testLabel);
         segResult=reshape(data_last,  sizeTestLabel(1),sizeTestLabel(2),sizeTestLabel(3));


         for iVisualize = viewSlice:viewSlice
             RGB = label2rgb(segResult(:,:,iVisualize ), 'hsv' ,'k');
             figure,subplot(311),imshow(testLabel(:,:,iVisualize ),[]), title('A 2D Groundtruth');
             subplot(312), imshow(RGB), title('Seg EM with Atlas Init and Tissue Model Color') ,subplot(313), imshow(segResult(:,:,iVisualize),[]),title('Seg EM with Atlas init and tissue Model');
             pause(0.05);
         end
        disp('dice for em+tissue model');
         similarityEMtissue = dice(double(class),double(tempTestLabel)');
         similarityEMtissue=similarityEMtissue(1:3,:);
         similarityEMtissueall(:,totalFolders-3)=similarityEMtissue
        sumDiceEMtissue=sumDiceEMtissue+similarityEMtissue;

    else
        disp('Hidden files');
    end
end
   toc
   disp('dice average for atlas is');
   diceAverage=sumDiceAtlas/length(filesTestingVolume)


   disp('dice average for em with atlas initialization');
   diceAverageEM=sumDice/length(filesTestingVolume)


    disp('dice average for em with atlas initialization and tissue model');
   diceAverageEMtissue=sumDiceEMtissue/length(filesTestingVolume)
