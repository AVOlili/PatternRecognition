load('usps_all');
x3=data(:,:,3); %取出手写体3的数据集
x8=data(:,:,8); %取出手写体8的数据集
[a,b]=size(x3);%[256,1100]
for n=1:10
   test3=double(x3(:,(n-1)*b/10+1:n*b/10));%测试样本,b/10=110
   test8=double(x8(:,(n-1)*b/10+1:n*b/10));%每次110个样本,矩阵256x110
   train3=double(x3); train8=double(x8);%此时train3和trian8为[256,1100]
   train3(:,(n-1)*b/10+1:n*b/10)=[];%训练样本
   train8(:,(n-1)*b/10+1:n*b/10)=[];%把测试样本部分设为空大小[256,990]
    %sum(x,2)表示行求和(每一行数据全部加起来)
    %m3=[256,1]/990  m3,m8为110x1矩阵
   m3=sum(train3,2)*10/9/b;  
   m8=sum(train8,2)*10/9/b;  
   S3=zeros(a,a);S8=zeros(a,a);%[256,256]
   for i=1:9*b/10   % 1—>990  
       temp3=train3(:,i)-m3;%train3(:,i)代表第i列的所有元素[256,1]
       temp8=train8(:,i)-m8;
       S3=S3+temp3*(temp3)';
       S8=S8+temp8*(temp8)';
   end
   %%%%%%%%%离散度矩阵
   Sw=S3+S8; %这里S3,S8和书上S1,S2对应
  %%%%%%%%%%得出最优化投影方向w*
   w=inv(Sw)*(m3-m8); 
   %%%% 阈值w0=-1/2(m~1+m~2)   
   %%%% m~i=w'mi (w'是转置矩阵)
   w0=-1/2*(w'*m3+w'*m8);
   count=0;  %count表示识别正确的次数
   for i=1:b/10 %%j=1->110
       g3=w'*test3(:,i)+w0;
       if g3>0 count=count+1;
       end
   end
   for i=1:b/10 %%k=1->110
       g8=w'*test8(:,i)+w0;
       if g8<0 count=count+1;
       end
   end
   R(n)=count/(b/10+b/10); %10倍交叉验证的各个正确率
  % disp(R(n))
   disp(['第',num2str(n),'次的正确率为',num2str(R(n))]);
end
Avg_r=sum(R)/10;
disp(['平均正确率为',num2str(Avg_r)]);