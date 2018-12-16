%This script prepares the atlas for CSF, GM and WM. 
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

    newCSF=zeros(size(trainingImageni));
    newWM=zeros(size(trainingImageni));
    newGM=zeros(size(trainingImageni));
    for iin = 1 :size(trainingImageni,3)
        CSF=double(trainingLabelni(:,:,iin)==1);
        WM=double(trainingLabelni(:,:,iin)==2);
        GM=double(trainingLabelni(:,:,iin)==3);
        
        
        currentSlice=trainingImageni(:,:,iin);
        newCSF(:,:,iin)=double(currentSlice).*CSF;        
        newWM(:,:,iin)=double(currentSlice).*WM;
        newGM(:,:,iin)=double(currentSlice).*GM;
    end
    disp(i)
    CSF4D(:,:,:,i)=newCSF;
    WM4D(:,:,:,i)=newWM;
    GM4D(:,:,:,i)=newGM;
    
end

atlasCSF=mean(CSF4D,4);
atlasWM=mean(WM4D,4);
atlasGM=mean(GM4D,4);

figure,imshow(atlasCSF(:,:,150),[])

save('atlasCSF' ,'atlasCSF');
save('atlasGM', 'atlasGM');
save('atlasWM', 'atlasWM');


niftiwrite(atlasCSF, 'atlasCSF');
niftiwrite(atlasWM, 'atlasWM');
niftiwrite(atlasGM, 'atlasGM');


