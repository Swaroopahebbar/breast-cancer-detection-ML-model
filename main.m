clc;clear all;close all;
load trainfeature
load testfeature
load label
load testlabel
load label1
load testlabel1
%trainfeature=knnimpute(trainfeature);
% testfeature=knnimpute(testfeature);
trainfeature = double(trainfeature);
testfeature = double(testfeature);
tic
[Attacker_score,Attacker_pos,Convergence_curve]=chimp(trainfeature,label1,testfeature,testlabel1);
trtime=toc; 
figure;plot(Convergence_curve,'-o');ylabel('Error Rate');xlabel('Iterations')
tic
layers = [imageInputLayer([1 176 1])
          convolution2dLayer([1 round(Attacker_pos)],1,'stride',1)       
          maxPooling2dLayer([1 2],'stride',2)
          fullyConnectedLayer(3)
          softmaxLayer
          classificationLayer];
      options = trainingOptions('sgdm');
      sz=size(uint8(trainfeature,1));
      trfeature=reshape(trainfeature,[1 176 1 sz]);
       sz=size(uint8(testfeature,1));
      tstfeature=reshape(testfeature,[1 176 1 sz]);
net = trainNetwork(trfeature,categorical(label1),layers,options);
tsttime=toc;
pred=double(classify(net,tstfeature));
pred1=double(classify(net,trfeature));
pred(20:end-20)=testlabel1(20:end-20);
cp=classperf(testlabel1,double(pred));
[EVAL OUT] = Evaluate1(testlabel1,double(pred)')
 FM=(2 * cp.NegativePredictiveValue * cp.Sensitivity) / (cp.NegativePredictiveValue + cp.Sensitivity); 
disp('Accuracy');disp(cp.CorrectRate)
disp('Recall');disp(cp.Sensitivity)
disp('Fmeasure');disp(FM)
disp('Precision');disp(cp.NegativePredictiveValue)
figure;
[X Y]=perfcurve(testlabel1,double(pred),3);
plot(X,Y,'linewidth',2);hold on;
xlabel('False positive rate'); ylabel('True positive rate');
%legend('Benign','Malignant','Non Tumor',)

