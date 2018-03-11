clear
load('usps');
data=double(data);
load('T');
M=11000;
N=10;
K=3;%设置K值为3
%十倍交叉验证：
indices= crossvalind('Kfold',M, N);
count = zeros(1,N);
accuracy = zeros(1,N);
for i=1:N
    test=(indices==i);
    train=~test;
    dataTrain=data(train,:);
    dataTest=data(test,:);
    trainT=T(train,:);
    testT=T(test,:);
    %%训练数据：
    A = unique(trainT);
    %取矩阵T的不同元素构成的向量，其中A可能是行向量也可能是列向量。
    L=length(A);
    ST=size(dataTest,1);
    B = pdist2(dataTest,dataTrain);
    [~,id] = sort(B,2,'ascend');
    %对B每一行进行升序排序
    k = zeros(L,ST);
    for x=1:L
        if(ST==1)
            k(x) = sum(trainT(id(:,1:K))==A(x));
        else
            k(x,:) = sum(trainT(id(:,1:K))==A(x),2);
        end
    end
    [~,j] = max(k);
    temp = A(j);
    %计算正确率：
    for b=1:(M/N)
        if(temp(b) == testT(b))
            count(i) = count(i)+1;
        end
    end
    accuracy(i) = count(i)/(M/N);
    disp(['正确率为',num2str(accuracy(i))]);
end
average = mean(accuracy);
disp(['平均正确率为',num2str(average)]);