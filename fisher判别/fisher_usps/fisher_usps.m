load('usps_all');
x3=data(:,:,3); %ȡ����д��3�����ݼ�
x8=data(:,:,8); %ȡ����д��8�����ݼ�
[a,b]=size(x3);%[256,1100]
for n=1:10
   test3=double(x3(:,(n-1)*b/10+1:n*b/10));%��������,b/10=110
   test8=double(x8(:,(n-1)*b/10+1:n*b/10));%ÿ��110������,����256x110
   train3=double(x3); train8=double(x8);%��ʱtrain3��trian8Ϊ[256,1100]
   train3(:,(n-1)*b/10+1:n*b/10)=[];%ѵ������
   train8(:,(n-1)*b/10+1:n*b/10)=[];%�Ѳ�������������Ϊ�մ�С[256,990]
    %sum(x,2)��ʾ�����(ÿһ������ȫ��������)
    %m3=[256,1]/990  m3,m8Ϊ110x1����
   m3=sum(train3,2)*10/9/b;  
   m8=sum(train8,2)*10/9/b;  
   S3=zeros(a,a);S8=zeros(a,a);%[256,256]
   for i=1:9*b/10   % 1��>990  
       temp3=train3(:,i)-m3;%train3(:,i)�����i�е�����Ԫ��[256,1]
       temp8=train8(:,i)-m8;
       S3=S3+temp3*(temp3)';
       S8=S8+temp8*(temp8)';
   end
   %%%%%%%%%��ɢ�Ⱦ���
   Sw=S3+S8; %����S3,S8������S1,S2��Ӧ
  %%%%%%%%%%�ó����Ż�ͶӰ����w*
   w=inv(Sw)*(m3-m8); 
   %%%% ��ֵw0=-1/2(m~1+m~2)   
   %%%% m~i=w'mi (w'��ת�þ���)
   w0=-1/2*(w'*m3+w'*m8);
   count=0;  %count��ʾʶ����ȷ�Ĵ���
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
   R(n)=count/(b/10+b/10); %10��������֤�ĸ�����ȷ��
  % disp(R(n))
   disp(['��',num2str(n),'�ε���ȷ��Ϊ',num2str(R(n))]);
end
Avg_r=sum(R)/10;
disp(['ƽ����ȷ��Ϊ',num2str(Avg_r)]);