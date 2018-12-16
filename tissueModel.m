%This script plots the histogram for 3 tissues CSF, GM and WM.
 clc;
 clear all;
 close all;

addpath('results/ResultsRegistration_1000withall/');
addpath('results/resultsTraininglabels/');

trainingImagesPath = fullfile('results','ResultsRegistration_1000withall');
trainingLabelsPath = fullfile('results','ResultsTraininglabels');

trainingImagesPathall = fullfile('results','ResultsRegistration_1000withall','*.nii');
trainingLabelsPathall = fullfile('results','ResultsTraininglabels','*.nii');

trainingImagesFiles=dir(trainingImagesPathall);
trainingLabelFiles=dir(trainingLabelsPathall);

allCSF=[]; allWM=[]; allGM=[];

for i = 1:length(trainingImagesFiles)
    trainingImage=strcat(trainingImagesPath,'/',trainingImagesFiles(i).name);
    trainingLabel=strcat(trainingLabelsPath,'/',trainingLabelFiles(i).name);
    trainingImageni=niftiread(trainingImage);
    trainingLabelni=niftiread(trainingLabel);
    temp=trainingImageni;
    intensitiesCSF = temp(trainingLabelni(:) == 1);
    intensitiesWM = temp(trainingLabelni(:) == 2);
    intensitiesGM = temp(trainingLabelni(:) == 3);
    
    allCSF=[allCSF;intensitiesCSF];
    allWM=[allWM;intensitiesWM];
    allGM=[allGM;intensitiesWM];
    
end

figure,histogram(allCSF, 'Normalization', 'probability'), title('Histogram CSF');
figure,histogram(allWM, 'Normalization', 'probability'),title('Histogram WM');
figure,histogram(allGM, 'Normalization', 'probability'),title('Histogram GM');
    