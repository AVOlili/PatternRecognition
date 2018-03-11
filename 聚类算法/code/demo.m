clc;
clear;
load('sonar.mat');
data = sonar;
K = 2;%聚类数目
[data_n,feature_n] = size(data); %特征样本数(190)*特征数(60)，1个样本60个特征
center = zeros(K,feature_n);%用来存储距离中心点 2*60
dist=zeros(data_n,K);%存储各个样本到中心点的 距离
dist1=zeros(data_n,K);
label=zeros(data_n,1);%存储各个样本的类别标签
max=1000;%设置最大迭代次数

%随机产生K个聚类中心
for i=1:K
    center(i,:)=data(floor(rand*data_n),:);%随机产生K个聚类中心,floor为向下取整
end

%开始进行迭代
for n=1:max
    %计算距离矩阵
    for i=1:data_n  %1->190
        for j=1:K
            dist1(i,j)=norm(data(i,:)-center(j,:));%一个样本与所有聚类中心的距离
        end                                        %一行代表一个样本，K列代表与K个聚类中心的距离
    end
    for i=1:data_n %1->190
        [dist_sort,val]=sort(dist1(i,:));%将距离由小到大排序,一共190组
        label(i,1)=val(1,1);%以距离最近的中心分类
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    M=zeros(K,feature_n);%初始化中心点的特征向量M
    count=zeros(K,1);%为求中心点的特征向量平均值而设定的计数器
    %计算新聚类中心
    for i=1:data_n
        M(label(i,1),:)=M(label(i,1),:)+data(i,:);
        count(label(i,1),1)=count(label(i,1),1)+1;
    end
    for k=1:K
        M(k,:)=M(k,:)./count(k,1);
        center(k,:)=M(k,:);%更新聚类中心
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    error=0;
    for i=1:data_n
        for k=1:K%如果距离不再变化，即中心点不再变化，或者达到了最大的迭代次数，则停止迭代
            error=error+norm(dist1(i,k)-dist(i,k));
        end
    end
    dist=dist1;
    dist1=zeros(data_n,K);
    if error==0%如果所有的中心点不再移动
        break;
    end
end

%输出类标
for i = 1:data_n
fprintf('第%d个样本属于第%d类\n',i,label(i,:));
end
index1 = 0;index2 = 0;
for i = 1:data_n
    if label(i,:) == 1;
        index1 = index1+1;
    elseif  label(i,:) == 2;
        index2 = index2+1;
    end
end
fprintf('属于第1类样本个数有%d个，第2类样本个数有%d个\n',index1,index2);