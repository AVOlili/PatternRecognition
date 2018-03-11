clear
load('sonar.mat');
A = double(sonar(1:90,:));
B = double(sonar(101:190,:));
indices = crossvalind('Kfold',90,10);%10为交叉验证折数
for a = 1:10   %实验记进行10次(交叉验证折数)，求10次的平均值作为实验结果，
    test = (indices == a); train = ~test;  %产生测试集合训练集索引
    A_test = A (test,:);
    A_train = A (train,:);
    B_test = B (test,:);
    B_train = B (train,:);
        %计算样本均值  
    m1=mean(A_train)';  
    m2=mean(B_train)';  
        %s1、s2分别代表表示第一类、第二类样本的类内离散度矩阵  
    s1=zeros(size(A_train,2));  
    for i=1:size(A_train,1)
       s1 = s1 + (A_train(i,:)'-m1)*(A_train(i,:)'-m1)';  
    end;  
    s2=zeros(size(B_train,2));   
    for i=1:size(B_train,1)
       s2 = s2 + (B_train(i,:)'-m2)*(B_train(i,:)'-m2)';  
    end;  
    %计算总类内离散度矩阵Sw  
    Sw=s1+s2;  
    %计算fisher准则函数取极大值时的解w  
    w=inv(Sw)*(m1-m2);  
    %计算阈值w0  
    ave_m1 = w'*m1;  
    ave_m2 = w'*m2;  
    w0 = -(ave_m1+ave_m2)/2;     
    countA=0;
    countB=0;
    %计算正确率
    for i=1:9
        %判别函数
        g1 = w'*A_test(i,:)'+w0;
        if g1>0 
            countA = countA+1;
        end
    end
    disp(['第',num2str(a),'次识别d1的正确率为',num2str(countA/9)]);
    for i=1:9
        g2 = w'*B_test(i,:)'+w0;
        if g2<0 
            countB = countB+1;
        end
    end
    disp(['第',num2str(a),'次识别d2的正确率为',num2str(countB/9)]);
end


