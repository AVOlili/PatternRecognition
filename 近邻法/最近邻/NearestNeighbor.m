clear
load('usps');
data=double(data);
load('T');%T�Ǳ�ǩ��
M=11000;
K=10;
index= crossvalind('Kfold',M, K);%ʮ��������֤
count = zeros(1,K);
accuracy = zeros(1,K);
for i=1:K
    test=(index==i);
    train=~test;
    data_train=data(train,:);
    data_test=data(test,:);
    trainT=T(train,:);
    testT=T(test,:);
    Dist = pdist2(data_test,data_train);%ѵ������
    [dmin,id]=min(Dist');
    temp=trainT(id);
    %������ȷ�ʣ�
    for j=1:(M/K)  
        if(temp(j) == testT(j))
            count(i)=count(i)+1;
        end  
    end
    accuracy(i) = count(i)/(M/K);
    disp(['��',num2str(i),'����ȷ��Ϊ',num2str(accuracy(i))]);
end
Average = mean(accuracy);
disp(['ƽ����ȷ��Ϊ',num2str(Average)]);