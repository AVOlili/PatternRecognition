clear
load('usps');
data=double(data);
load('T');%T是标签集
M=11000;
K=10;
index= crossvalind('Kfold',M, K);%十倍交叉验证
count = zeros(1,K);
accuracy = zeros(1,K);
for i=1:K
    test=(index==i);
    train=~test;
    data_train=data(train,:);
    data_test=data(test,:);
    trainT=T(train,:);
    testT=T(test,:);
    Dist = pdist2(data_test,data_train);%训练数据
    [dmin,id]=min(Dist');
    temp=trainT(id);
    %计算正确率：
    for j=1:(M/K)  
        if(temp(j) == testT(j))
            count(i)=count(i)+1;
        end  
    end
    accuracy(i) = count(i)/(M/K);
    disp(['第',num2str(i),'次正确率为',num2str(accuracy(i))]);
end
Average = mean(accuracy);
disp(['平均正确率为',num2str(Average)]);