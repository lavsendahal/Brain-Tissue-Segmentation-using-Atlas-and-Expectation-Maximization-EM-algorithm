
%Mean Intensity Image by maximum value

clear all;
close all;

tic
addpath('results/resultsRegistration_1000withall');
filesImages=dir('results/resultsRegistration_1000withall/*.nii');

volume1=niftiread(filesImages(1).name);
x1=size(volume1,1); y1=size(volume1,2); z1=size(volume1,3);
template4D=double(zeros(x1,y1,z1,length(filesImages)));

%Put all the 3d slices in one 4d array.
for i = 1:length(filesImages)
    tempTemplate=niftiread(filesImages(i).name);
    template4D(:,:,:,i)=tempTemplate;
end

userTemplate=mean(template4D,4);

figure,imshow(userTemplate(:,:,150),[]);

save('userTemplate', 'userTemplate');
toc