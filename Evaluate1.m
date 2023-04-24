 function [EVAL OUT] = Evaluate1(ACTUAL,PREDICTED)
  cnames=['Classes'];
 un=unique(ACTUAL);
 for i=1:length(un)
idx = (ACTUAL()==un(i));

p = length(ACTUAL(idx));
n = length(ACTUAL(~idx));
N = p+n;

tp(i) = sum(ACTUAL(idx)==PREDICTED(idx));
tn(i) = sum(ACTUAL(~idx)==PREDICTED(~idx));
fp(i) = n-tn(i);
fn(i) = p-tp(i);

tp_rate = tp(i)/p;
tn_rate = tn(i)/n;
%Fall out or false positive rate
FPR(i) = fp(i)/(fp(i)+tn(i));
% False negative rate
FNR(i) = fn(i)/(tp(i)+fn(i));

P1=(tp(i)+fn(i))/(tp(i)+fp(i)+tn(i)+fn(i));
P2=(tp(i)+fp(i))/(tp(i)+fp(i)+tn(i)+fn(i));
RA=(P1*P2)+((1-P1)*(1-P2));

accuracy(i) = (tp(i)+tn(i))/N;
K(i)=(accuracy(i)-RA)/(1-RA);
mcc(i)= (tp(i)*tn(i)- fp(i)*fn(i)) / sqrt( (tp(i) + fp(i))*(tp(i) + fn(i))*(tn(i) + fp(i))*(tn(i) + fn(i)) );
sensitivity(i) = tp_rate;
specificity(i) = tn_rate;
precision(i) = tp(i)/(tp(i)+fp(i));
recall(i) = sensitivity(i);
f_measure(i) = 2*((precision(i)*recall(i))/(precision(i) + recall(i)));
gmax(i) = sqrt(tp_rate*tn_rate);
sensitivity(isnan(sensitivity))=0;
precision(isnan(precision))=0;
recall(isnan(recall))=0;
f_measure(isnan(f_measure))=0;
gmax(isnan(gmax))=0;
mcc(isnan(mcc))=0;
cnames = [cnames {num2str(i)}];
 end
 mae=mean(abs(ACTUAL-PREDICTED));
 EVAL = [mean(accuracy) mean(sensitivity) mean(specificity) mean(precision) mean(recall) mean(f_measure) mean(gmax) mean(mcc) mae mean(K)];
OUT = [(accuracy)' (sensitivity)' (specificity)' (precision)' (recall)' (f_measure)' (gmax)'];
  