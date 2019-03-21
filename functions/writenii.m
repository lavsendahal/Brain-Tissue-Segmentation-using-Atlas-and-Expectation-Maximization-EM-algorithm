%This scripts writes all the nii files required for registering the user
%template atlas to each test image and using transoformix to transform the
%CSF, WM and GM. 

clear all;
close all;
clc;
%Load the atlas from the workspace.
 userTemplate= load('userTemplate.mat');
 atlasCSF= load('atlasCSF.mat');
 atlasGM= load('atlasGM.mat');
 atlasWM = load('atlasWM.mat');
 
userTemplate=single(userTemplate.userTemplate);
atlasCSF=single(atlasCSF.atlasCSF);
atlasWM=single(atlasWM.atlasWM);
atlasGM=single(atlasGM.atlasGM);

%Convert all the atlases into nifti file by reading the info from each test
%set

addpath('test-set/testing-images');
files=dir('test-set/testing-images/*.nii.gz');

for i = 1:length(files)
    info=niftiinfo(files(i).name);
    outputNameAll=strcat('niiTemplate',files(i).name(1:4));
    outputNameCSF=strcat('niiAtlasCSF',files(i).name(1:4));
    outputNameGM=strcat('niiAtlasGM',files(i).name(1:4));
    outputNameWM=strcat('niiAtlasWM',files(i).name(1:4));
    userTemplate = (imresize3(userTemplate,info.ImageSize));
    atlasCSF=(imresize3(atlasCSF,info.ImageSize));
    atlasWM=(imresize3(atlasWM,info.ImageSize));
    atlasGM = (imresize3(atlasGM,info.ImageSize));
    atlasCSF=rescale(atlasCSF,0,max(max(max(userTemplate))));
    atlasWM=rescale(atlasWM,0,max(max(max(userTemplate))));
    atlasGM=rescale(atlasGM,0,max(max(max(userTemplate))));
    %niftiwrite(userTemplate, outputNameAll,info);
    niftiwrite(atlasCSF, outputNameCSF,info);
    niftiwrite(atlasWM, outputNameWM,info);
    niftiwrite(atlasGM, outputNameGM,info);
end



