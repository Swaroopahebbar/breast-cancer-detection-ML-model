function seg1=BCRF(I1)
bb=im2bw(I1);
bw=bwlabel(bb);
out=I1;
se = strel('disk',4);
bw1=imdilate(bw,se);
stats=regionprops(bw1,'all');
[mn inn]=sort([stats.Solidity]);
bsub=(bw1==inn(1));
bw2=(bb-bsub);
bw3=(bw2>0).*bw;
bw5=bwareaopen(bw3,200);
seg=uint8(bw5).*rgb2gray(I1);
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

