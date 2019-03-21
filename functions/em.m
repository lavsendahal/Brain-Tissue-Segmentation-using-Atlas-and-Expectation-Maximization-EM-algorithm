function [segResult ,similarity,member_wt]= em(fullTestVolume,fullAtlasLabel,fullTestLabel,testLabel,indexMask0,indexMaskNon0,viewSlice)
%This function returns the member weight, similarity and the segmentation results for the brain tissue segmentation into CSF, GM and WM.
%Written by : Lavsen Dahal

%-------------------------------------------------------------------------%
        tempTestVol=fullTestVolume;
        tempTestLabel=fullTestLabel;
        tempAtlasLabel=fullAtlasLabel;

        tempTestVol(indexMask0)=[];
        tempTestLabel(indexMask0)=[];
        tempAtlasLabel(indexMask0)=[];

        %data= tempTestVol ;
        tempTestVol=double(tempTestVol);

        idx=tempAtlasLabel;
        unq_idx=unique(idx);
        noCluster=length(unq_idx);

        idxCFS=find(tempAtlasLabel==1);
        idxWM=find(tempAtlasLabel==2);
        idxGM=find(tempAtlasLabel==3);

        dataCSF=tempTestVol(idxCFS);
        dataWM=tempTestVol(idxWM);
        dataGM=tempTestVol(idxGM);
        mu=zeros(1,noCluster);
        mu(1)=mean(dataCSF);
        mu(2)=mean(dataWM);
        mu(3)=mean(dataGM);

        % Initialization of cluster Parameters  weight(wt), mean (mu), covariance matrix
        % (cov_m) for each hard-coded cluster assignments
        alpha=zeros(1,noCluster);
        %mu=zeros(1,no_cluster);
        cov_m= zeros(1,noCluster);
        data_all=cell(1,noCluster);
        nksoft=zeros(1,noCluster);

        for i = 1:noCluster
            uniq_indx= (idx==unique(i));
            nksoft(i)=sum(uniq_indx);
            alpha(i)=nksoft(i)/length(tempTestVol);
            data_temp_T1= tempTestVol(uniq_indx);
            data_all{i}= double(data_temp_T1);
            cov_m(i)=std(data_all{i});
        end

        %E-step : Estimating cluster responsibilities from given cluster parameter
        %initializations/estimates
        %-------------------------------------------------------------------------%
        %-------------------------------------------------------------------------%
        %-------------------------------------------------------------------------%
        count=0;
        max_iter = 60;
        member_wt=zeros(length(tempTestVol),3);
        tempTestVol=double(tempTestVol);
        mu=double(mu);
        cov_m=double(cov_m);

        while (1)

        for j = 1:noCluster
        member_wt(:,j)=double(alpha(j)*probDist(tempTestVol, mu(j), cov_m(j)));
        end

        member_wt_sum=sum(member_wt,2);
        ll=sum(log(member_wt_sum));
        member_wt=(member_wt ./ (member_wt_sum )) ;


        %-------------------------------------------------------------------------%
        %M-step: Maximize likelihood over parameters given current responsibilities
        %Estimate cluster parameters from soft assignments
        %Update means, weights and covariances

        for i = 1:noCluster
        Nksoft=sum(member_wt(:,i));
        nksoft(i)=Nksoft;
        alpha(i)= nksoft(i)/length(tempTestVol);
        mu(i)= (1/nksoft(i)) * sum(member_wt(:,i).*tempTestVol);
        temp_1 = bsxfun (@ minus, tempTestVol,mu(i));
        temp=member_wt(:,i).*temp_1;
        cov_m(i) = (1/nksoft(i))* (temp_1' * temp) ;
        cov_m(i)=sqrt(cov_m(i));
        end

        ll_old=ll;
        ll=sum(log(sum(member_wt,2)));  %Compute log_likelihood

        eps_new = abs(ll-ll_old);
        count=count+1;
        fprintf('Number of iterations is %d \n ',count);
        fprintf('Log likelihood is %d \n ',ll);
        if ( eps_new < eps || count > max_iter)
                    break;
        end

        end

        % %Post-Processing after reaching convergence
        % %Adding zeros back to the background positions

        %Change the cluster responsibility to the class label.
        %class=zeros(1,length_image);
         member_wt=member_wt';
         %member_wt=member_wt.*probAtlas';

         %atlasHistogram = atlasAndHistogram();

         %member_wt=member_wt.*atlasHistogram';
         [~,class]=max(member_wt);

         similarity = dice(double(class),double(tempTestLabel)');
         similarity=similarity(1:3,:);

    % %Adding background zeros
         data_last=zeros(1,length(fullAtlasLabel));

         data_last(indexMask0)=0;
         data_last(indexMaskNon0)=class;
         sizeTestLabel=size(testLabel);
         segResult=reshape(data_last,  sizeTestLabel(1),sizeTestLabel(2),sizeTestLabel(3));

         for iVisualize = viewSlice:viewSlice

         RGB = label2rgb(segResult(:,:,iVisualize ), 'hsv' ,'k');
     figure,subplot(311),imshow(testLabel(:,:,iVisualize ),[]), title('A 2D Groundtruth');
     subplot(312), imshow(RGB), title('Seg EM with Atlas init Color') ,subplot(313), imshow(segResult(:,:,iVisualize),[]),title('Seg EM with Atlas init');
     pause(0.05);
         end
%


end    %end for function
