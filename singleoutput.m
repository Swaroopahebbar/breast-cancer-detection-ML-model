clc;clear all;close all
I=imread('image(97).jpg');
figure;imshow(I);title('Malignant')
%%%%%  Adaptive histogram equalisation
%I2(:,:,1)=adapthisteq(I(:,:,1));I2(:,:,2)=adapthisteq(I(:,:,2));I2(:,:,3)=adapthisteq(I(:,:,3));
I2=adapthisteq(I);
figure;imshow(I2);title('Equalisation')
%%% Wavelet based denoising
wname = 'bior3.5';
level = 5;
[C,S] = wavedec2(I2,level,wname);
thr = wthrmngr('dw2ddenoLVL','penalhi',C,S,3);
sorh = 's';
[XDEN,cfsDEN,dimCFS] = wdencmp('lvd',C,S,wname,level,thr,sorh);
I1=uint8(XDEN);
figure;imshow(I1);title('Wavelet Filter')
bb=im2bw(I1);
bw=bwlabel(bb);
out=I1;
figure;imshow(bw);title('Binary image')
se = strel('disk',2);
bw1=imdilate(bw,se);
stats=regionprops(bw1,'all');
[mn inn]=sort([stats.Solidity]);
bsub=(bw1==inn(1));
figure;imshow(bsub);title('region of intrest')
bw2=(bb-bsub);
bw3=(bw2>0).*bw;
bw5=bwareaopen(bw3,200);
seg=uint8(bsub).*(I2);
figure;imshow(seg);title('initial segmentation')
val=max(seg(:));
for i=1:size(seg,1)
    for j=1:size(seg,2)
        if(seg(i,j)>0)
            if(val-seg(i,j)<50)
                seg1(i,j)=1;
                I1(i,j,1:3)=[255 0 0];
            else
                seg1(i,j)=0;
            end
        else
            seg1(i,j)=0;
        end
    end
end
figure;imshow(seg1);title('Segmented region')
figure;imshow(I1);title('cancer region')
wavelength = [5 10];
orientation = [0 45 90 135];
g = gabor(wavelength,orientation);
outMag = imgaborfilt(seg1,g);
figure;
for ii=1:size(outMag,3)
   subplot(2,4,ii);imshow(outMag(:,:,ii));
   theta = g(ii).Orientation;
    lambda =g(ii).Wavelength;
   title(sprintf('Orientation=%d, Wavelength=%d',theta,lambda));
end

