clear
load('sonar.mat');
A = double(sonar(1:90,:));
B = double(sonar(101:190,:));
indices = crossvalind('Kfold',90,10);%10Ϊ������֤����
for a = 1:10   %ʵ��ǽ���10��(������֤����)����10�ε�ƽ��ֵ��Ϊʵ������
    test = (indices == a); train = ~test;  %�������Լ���ѵ��������
    A_test = A (test,:);
    A_train = A (train,:);
    B_test = B (test,:);
    B_train = B (train,:);
        %����������ֵ  
    m1=mean(A_train)';  
    m2=mean(B_train)';  
        %s1��s2�ֱ�����ʾ��һ�ࡢ�ڶ���������������ɢ�Ⱦ���  
    s1=zeros(size(A_train,2));  
    for i=1:size(A_train,1)
       s1 = s1 + (A_train(i,:)'-m1)*(A_train(i,:)'-m1)';  
    end;  
    s2=zeros(size(B_train,2));   
    for i=1:size(B_train,1)
       s2 = s2 + (B_train(i,:)'-m2)*(B_train(i,:)'-m2)';  
    end;  
    %������������ɢ�Ⱦ���Sw  
    Sw=s1+s2;  
    %����fisher׼����ȡ����ֵʱ�Ľ�w  
    w=inv(Sw)*(m1-m2);  
    %������ֵw0  
    ave_m1 = w'*m1;  
    ave_m2 = w'*m2;  
    w0 = -(ave_m1+ave_m2)/2;     
    countA=0;
    countB=0;
    %������ȷ��
    for i=1:9
        %�б���
        g1 = w'*A_test(i,:)'+w0;
        if g1>0 
            countA = countA+1;
        end
    end
    disp(['��',num2str(a),'��ʶ��d1����ȷ��Ϊ',num2str(countA/9)]);
    for i=1:9
        g2 = w'*B_test(i,:)'+w0;
        if g2<0 
            countB = countB+1;
        end
    end
    disp(['��',num2str(a),'��ʶ��d2����ȷ��Ϊ',num2str(countB/9)]);
end


