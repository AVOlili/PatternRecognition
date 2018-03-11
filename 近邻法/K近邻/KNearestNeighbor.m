clear
load('usps');
data=double(data);
load('T');
M=11000;
N=10;
K=3;%����KֵΪ3
%ʮ��������֤��
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
    %%ѵ�����ݣ�
    A = unique(trainT);
    %ȡ����T�Ĳ�ͬԪ�ع��ɵ�����������A������������Ҳ��������������
    L=length(A);
    ST=size(dataTest,1);
    B = pdist2(dataTest,dataTrain);
    [~,id] = sort(B,2,'ascend');
    %��Bÿһ�н�����������
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
    %������ȷ�ʣ�
    for b=1:(M/N)
        if(temp(b) == testT(b))
            count(i) = count(i)+1;
        end
    end
    accuracy(i) = count(i)/(M/N);
    disp(['��ȷ��Ϊ',num2str(accuracy(i))]);
end
average = mean(accuracy);
disp(['ƽ����ȷ��Ϊ',num2str(average)]);