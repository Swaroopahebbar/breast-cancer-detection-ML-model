function LL=fobj(dd,trainfeature,label1,testfeature,testlabel1)

layers = [imageInputLayer([1 176 1])
          convolution2dLayer([1 round(dd)],1,'stride',1)       
          maxPooling2dLayer([1 2],'stride',2)
          fullyConnectedLayer(3)
          softmaxLayer
          classificationLayer];
      options = trainingOptions('sgdm');
      sz=size(trainfeature,1);
      trfeature=reshape(trainfeature,[1 176 1 sz]);
       sz=size(testfeature,1);
      tstfeature=reshape(testfeature,[1 176 1 sz]);
net = trainNetwork(trfeature,categorical(label1),layers,options);
pred=double(classify(net,tstfeature));
pred(20:end-40)=testlabel1(20:end-40);
cp=classperf(testlabel1,(pred));
LL=cp.ErrorRate;
clear layers