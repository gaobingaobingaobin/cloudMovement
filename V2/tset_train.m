clear
clc
close all
load feature
load cloud
feature = feature';
cloud = cloud';
%xdata = feature(1:100,1:2);��ά������Showplot��ͼ
xdata = feature(1:160,:);
group = cloud(1:160);

%%crossvalind:train&test HoldOut
%p:testing�ı���
p=0.5;
[Train,Test] = crossvalind('HoldOut',group,p);
TrainingSample = xdata(Train,:);
TrainingLabel = group(Train,1);
TestingSample = xdata(Test,:);
TestingLabel = group(Test,1);
svmStruct = svmtrain(TrainingSample,TrainingLabel,...
    'kernel_function','linear')%,'rbf_sigma',0.1);
%svmStruct = svmtrain(TrainingSample,TrainingLabel,'showplot',true,'kernel_function','rbf','rbf_sigma',0.1);

%%svmclassify
%��ʽGroup = svmclassify(SVMStruct,Sample,'Showplot',true)
OutLabel = svmclassify(svmStruct,TestingSample);
%�Ƚ�TestingLabel��TestingLabel�Ľ��
c1=sum(grp2idx(OutLabel) == grp2idx(TestingLabel))/sum(Test);

resdata = feature(161:end,:);
resgroup = cloud(161:end);
resLabel = svmclassify(svmStruct,resdata);
sum(grp2idx(resLabel) == grp2idx(resgroup))/160
