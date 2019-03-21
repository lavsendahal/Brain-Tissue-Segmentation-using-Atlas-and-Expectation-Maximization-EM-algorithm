% Written By: Lavsen Dahal
% As part of Medical Imaging and Applications (MAIA) course in University of Girona, Spain
function [segResult,probAtlas,similarity]=atlasSegmentation(atlasCSF,atlasWM,atlasGM,testLabel,testMask,viewSlice)
%The atlas are registered to the fix image. The atlas based segmentation is
%just the maximum probability in CSF, GM or WM.
%Load all the registered CSF, GM and WM into 1d array.

CSF= reshape(atlasCSF,numel(atlasCSF),1);
GM=reshape(atlasGM,numel(atlasGM),1);
WM=reshape(atlasWM,numel(atlasWM),1);

tempCSF=CSF;
tempGM=GM;
tempWM=WM;

tempTestLabel=testLabel;
tempTestLabel=reshape(tempTestLabel,numel(tempTestLabel),1);

testMask1D= reshape(testMask,numel(testMask),1);
testMaskWith0Index= find(~testMask1D);
testMaskWithout0Index= find(testMask1D);

tempCSF(testMaskWith0Index)=[];
tempGM(testMaskWith0Index)=[];
tempWM(testMaskWith0Index)=[];

tempTestLabel(testMaskWith0Index)=[];

%Put CSF, WM and GM in 3xn format.

allData=[tempCSF,tempWM,tempGM];
probAtlas=single(allData./max(max(allData)));

allData=allData';
[~,class]=max(allData);
similarity = dice(double(class),double(tempTestLabel)');
similarity=similarity(1:3,:);

newindex=1:length(allData);
allData=zeros(1,length(atlasCSF));
allData(newindex)=class;

allData(testMaskWith0Index)=0;
allData(testMaskWithout0Index)=class;
segResult=reshape(allData,  size(testMask));

for iVisualize = viewSlice:viewSlice
     RGB = label2rgb(segResult(:,:,iVisualize ), 'hsv' ,'k');
     figure,subplot(311),imshow(testLabel(:,:,iVisualize ),[]), title('A 2D Groundtruth');
     subplot(312), imshow(RGB), title('Seg Only Atlas Color') ,subplot(313), imshow(segResult(:,:,iVisualize),[]),title('Seg Only Atlas');
     pause(0.05);
 end

end
