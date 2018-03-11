clc;
clear;
load('sonar.mat');
data = sonar;
K = 2;%������Ŀ
[data_n,feature_n] = size(data); %����������(190)*������(60)��1������60������
center = zeros(K,feature_n);%�����洢�������ĵ� 2*60
dist=zeros(data_n,K);%�洢�������������ĵ�� ����
dist1=zeros(data_n,K);
label=zeros(data_n,1);%�洢��������������ǩ
max=1000;%��������������

%�������K����������
for i=1:K
    center(i,:)=data(floor(rand*data_n),:);%�������K����������,floorΪ����ȡ��
end

%��ʼ���е���
for n=1:max
    %����������
    for i=1:data_n  %1->190
        for j=1:K
            dist1(i,j)=norm(data(i,:)-center(j,:));%һ�����������о������ĵľ���
        end                                        %һ�д���һ��������K�д�����K���������ĵľ���
    end
    for i=1:data_n %1->190
        [dist_sort,val]=sort(dist1(i,:));%��������С��������,һ��190��
        label(i,1)=val(1,1);%�Ծ�����������ķ���
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    M=zeros(K,feature_n);%��ʼ�����ĵ����������M
    count=zeros(K,1);%Ϊ�����ĵ����������ƽ��ֵ���趨�ļ�����
    %�����¾�������
    for i=1:data_n
        M(label(i,1),:)=M(label(i,1),:)+data(i,:);
        count(label(i,1),1)=count(label(i,1),1)+1;
    end
    for k=1:K
        M(k,:)=M(k,:)./count(k,1);
        center(k,:)=M(k,:);%���¾�������
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    error=0;
    for i=1:data_n
        for k=1:K%������벻�ٱ仯�������ĵ㲻�ٱ仯�����ߴﵽ�����ĵ�����������ֹͣ����
            error=error+norm(dist1(i,k)-dist(i,k));
        end
    end
    dist=dist1;
    dist1=zeros(data_n,K);
    if error==0%������е����ĵ㲻���ƶ�
        break;
    end
end

%������
for i = 1:data_n
fprintf('��%d���������ڵ�%d��\n',i,label(i,:));
end
index1 = 0;index2 = 0;
for i = 1:data_n
    if label(i,:) == 1;
        index1 = index1+1;
    elseif  label(i,:) == 2;
        index2 = index2+1;
    end
end
fprintf('���ڵ�1������������%d������2������������%d��\n',index1,index2);