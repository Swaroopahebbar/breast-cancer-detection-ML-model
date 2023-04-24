clc;clear all;close all;
TrainFiles = dir('Testing\');
Train_Number=0;
for i = 1:size(TrainFiles,1)
    if not(strcmp(TrainFiles(i).name,'.')|strcmp(TrainFiles(i).name,'..') | strcmp(TrainFiles(i).name,'Thumbs.db'))
        Train_Number = Train_Number + 1; % Number of all images in the training database
        name{Train_Number}=TrainFiles(i).name;
         testlabel{Train_Number}=name{Train_Number};
        TrainFiles1{Train_Number} = strcat('Testing','\',name{Train_Number});
    end
end
Train_Number1=0;tt=0;
for i1 = 1:length(TrainFiles1)
    tt=tt+1;
    TrainFiles2 = dir(TrainFiles1{i1});
    for j1=1:length(TrainFiles2)
    if not(strcmp(TrainFiles2(j1).name,'.')|strcmp(TrainFiles2(j1).name,'..') | strcmp(TrainFiles2(j1).name,'Thumbs.db'))
        Train_Number1 = Train_Number1 + 1; % Number of all images in the training database
        name1{Train_Number1}=strcat(TrainFiles1{i1},'\',TrainFiles2(j1).name);
       [p n ex]=fileparts(name1{Train_Number1});
       p1=strcat(p,'.jpg');
       [p2 n2 ex2]=fileparts(p1);
       testlabel{Train_Number1}=n2;
       testlabel1(Train_Number1)=i1;
    end
    end
    
end
for i2=1:length(name1)
%for i2=1:2
    disp(strcat('Image',num2str(i2)));
    I=imresize(imread(name1{i2}),[256 256]);
    
    %%%%%  Adaptive histogram equalisation
    I2(:,:,1)=adapthisteq(I(:,:,1));I2(:,:,2)=adapthisteq(I(:,:,2));I2(:,:,3)=adapthisteq(I(:,:,3));
   %%% Wavelet based denoising
    wname = 'bior3.5';
    level = 5;
    [C,S] = wavedec2(I2,level,wname);
    thr = wthrmngr('dw2ddenoLVL','penalhi',C,S,3);
    sorh = 's';
    [XDEN,cfsDEN,dimCFS] = wdencmp('lvd',C,S,wname,level,thr,sorh);
    I1=uint8(XDEN);
    %%%%% Segmentation
    seg1=BCRF(I1);
    wavelength = [5 10];
    orientation = [0 45 90 135];
    g = gabor(wavelength,orientation);
    outMag = imgaborfilt(seg1,g);
    FF=[];
    for i=1:size(outMag,3)
         [out] = GLCM_Features1(outMag(:,:,i));
   
    FF=[FF cell2mat(struct2cell(out))'];
    end
      feat(i2,:)=FF;
end
    testfeature=(feat);
save('testfeature.mat','testfeature');
save('testlabel.mat','testlabel')
save('testlabel1.mat','testlabel1')