
%Convert all the atlases into nifti file by reading the info from each test
%set

clear all;
close all;
clc;

allAtlasMNI=niftiread('atlas.nii.gz');
templateMNI= niftiread('template.nii.gz');
CSF_MNI= allAtlasMNI(:,:,:,2);
WM_MNI = allAtlasMNI(:,:,:,3);
GM_MNI= allAtlasMNI(:,:,:,4);


addpath('test-set/testing-images');
files=dir('test-set/testing-images/*.nii.gz');

for i = 1:length(files)
    info=niftiinfo(files(i).name);
    currentTestVol=niftiread(files(i).name);
    outputNameAll=strcat('niiMNITemplate',files(i).name(1:4));
    outputNameCSF=strcat('niiMNIAtlasCSF',files(i).name(1:4));
    outputNameGM=strcat('niiMNIAtlasGM',files(i).name(1:4));
    outputNameWM=strcat('niiMNIAtlasWM',files(i).name(1:4));
    templateMNI = (imresize3(templateMNI,info.ImageSize));
    CSF_MNI=(imresize3(CSF_MNI,info.ImageSize));
    WM_MNI=(imresize3(WM_MNI,info.ImageSize));
    GM_MNI = (imresize3(GM_MNI,info.ImageSize));

    templateMNI=rescale(templateMNI,0,max(max(max(currentTestVol))));
    CSF_MNI=rescale(CSF_MNI,0,max(max(max(currentTestVol))));
    WM_MNI=rescale(WM_MNI,0,max(max(max(currentTestVol))));
    GM_MNI=rescale(GM_MNI,0,max(max(max(currentTestVol))));

    niftiwrite(templateMNI, outputNameAll,info);
    niftiwrite(CSF_MNI, outputNameCSF,info);
    niftiwrite(WM_MNI, outputNameWM,info);
    niftiwrite(GM_MNI, outputNameGM,info);
end
