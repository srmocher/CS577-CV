function [] = partc()

W=3;
feature_vector = construct_texture('sunset.tiff',W);
img = imread('tiger-2.tiff');
%imshow(img);
clusters = kmeanscluster(img,feature_vector,5);

 img = imread('tiger-1.tiff');
 clusters = kmeanscluster(img,feature_vector,5);
% 
 img = imread('tiger-2.tiff');
 clusters = kmeanscluster(img,feature_vector,5);

img_color = imread('tiger-2.tiff');

 [feature_vector,filter_resp] = get_feature_vector_with_rgb(img_color,W);
 k=5;
 

 kmeansclusterwithcolor(img_color,feature_vector,filter_resp,k);

[feature_vector,filter_resp]=get_feature_vector_with_rgb_and_location(img_color,W);
kmeansclusterwithcolorandlocation(img_color,feature_vector,filter_resp,k);

img_color = imread('tiger-1.tiff');

 [feature_vector,filter_resp] = get_feature_vector_with_rgb(img_color,W);
 k=5;
 



[feature_vector,filter_resp]=get_feature_vector_with_rgb_and_location(img_color,W);
kmeansclusterwithcolorandlocation(img_color,feature_vector,filter_resp,k);

img_color = imread('sunset.tiff');

 [feature_vector,filter_resp] = get_feature_vector_with_rgb(img_color,W);
 k=5;
 

 

[feature_vector,filter_resp]=get_feature_vector_with_rgb_and_location(img_color,W);
kmeansclusterwithcolorandlocation(img_color,feature_vector,filter_resp,k);

end

function [res] = gray2rgb(a)
a = double(a);
a(a==0) = 1; % Needed to produce nonzero index of the colormap matrix
ci = ceil(l*a/max(a(:))); 

% Colors in the new image
[il,iw] = size(a);
r = zeros(il,iw); 
g = zeros(il,iw);
b = zeros(il,iw);
r(:) = map(ci,1);
g(:) = map(ci,2);
b(:) = map(ci,3);

% New image
res = zeros(il,iw,3);
res(:,:,1) = r; 
res(:,:,2) = g; 
res(:,:,3) = b;

end

function[] = kmeansclusterwithcolor(img_color,feature_vector,filter_resp,k)
feature_means = [];
for i=1:k
        temp1 = randi([0,size(feature_vector,1)]);       
        feature_means = double([feature_means;feature_vector(temp1,:)]);
end
errors = zeros(k,1);
prev_error = -1;
rms_error = -1;
while 1
   clusters = cell(k,1);
   for i=1:size(feature_vector,1)
       p = feature_vector(i,:);
       clusterId = get_nearest_cluster(p,feature_means,k);
       clusters{clusterId} = [clusters{clusterId};p];
   end
   
    for i=1:k
              if size(clusters{i},1) == 0
                  point = get_random_point_from_clusters(clusters,k);
                  clusters{i} = [clusters{i};point];
              end
    end
           
   for i=1:k
      cluster = clusters{i};
      mean_filter_val = mean(cluster(:,1));
      r_m = mean(cluster(:,2));
      g_m = mean(cluster(:,3));
      b_m = mean(cluster(:,4));
      feature_means(i,:) = double([mean_filter_val;r_m;g_m;b_m]);
   end
   
   for i=1:k
       cluster = double(clusters{i});
       temp = cluster;
       cluster_mean = double(feature_means(i,:));
       error = 0.0
       for j=1:size(cluster,1)
           point = cluster(j,:);
          error = error + sqrt(sum((point-cluster_mean).^2));
           
       end
       errors(i)=error;
   end
   prev_error = rms_error;
   rms_error = sum(errors);
   
   if prev_error ~=-1 && rms_error>=prev_error
      break; 
   end
end

   colors = zeros(k,1);
   for i=1:k
       colors(i) = randi([0 255]);
   end
    for i=1:size(img_color,1)
        for j=1:size(img_color,2)
            r = img_color(i,j,1);
            g = img_color(i,j,2);
             b = img_color(i,j,3);
             filter_val = filter_resp(i,j);
             p = [filter_val,r,g,b];
           clusterId = get_nearest_cluster(p,feature_means,k);
           img_color(i,j,1) = colors(clusterId);
           img_color(i,j,2) = colors(clusterId);
           img_color(i,j,3) = colors(clusterId);
        end        
    end
    
    figure;
    imshow(img_color);

end


function[point] = get_random_point_from_clusters(clusters,k)
    for i=1:k
        if size(clusters{i},1)>1
            temp = clusters{i};
            point = temp(size(temp,1),:);
            temp(size(temp,1))=[];
            clusters{i} = temp;
            break;
        end
    end
end
function[clusterId] = get_nearest_cluster(p,feature_means,k)
dist=1000000;
p = double(p);
clusterId=-1;
for i=1:k
   mean_temp = feature_means(i,:);
   dst = sqrt(sum((p-mean_temp).^2));
   if dst<dist
      dist = dst;
      clusterId = i;
   end
end

end
function[mean_val] = get_mean_from_clusters(point,feature_means,k)
dist=1000000;
point = double(point);
clusterId=-1;
for i=1:k
   mean_temp = feature_means(i,:);
   dst = sqrt(sum((point-mean_temp).^2));
   if dst<dist
      dist = dst;
      clusterId = i;
   end
end
mean_val = feature_means(clusterId,:);
end

function[feature_vector,filter_resp] = get_feature_vector_with_rgb(img_color,W)
grayImg= rgb2gray(img_color);
h1 = fspecial('gaussian', W, 0.62);

h2 = fspecial('gaussian', W, 1);
h3 = fspecial('gaussian', W, 1.6);

r1 = conv2(double(grayImg),h1,'same');
r2 = conv2(double(grayImg),h2,'same');
r3 = conv2(double(grayImg),h3,'same');

r = sqrt((r1.^2+r2.^2+r3.^2)/3);
filter_resp = r;

feature_vector = [];
for i=1:size(img_color,1)
    for j=1:size(img_color,2)
       filter_val = r(i,j);
       r_val = img_color(i,j,1);
       g_val = img_color(i,j,2);
       b_val = img_color(i,j,3);
       feature_vector = [feature_vector;filter_val,r_val,g_val,b_val];
    end
end
end

function [clusters] = kmeanscluster(image,feature_vector,k)
img= rgb2gray(image);
means = zeros(k,1);
for i=1:k
   temp = randi([1 size(feature_vector,1)]); 
   mean_val = feature_vector(temp);
   means(i) = mean_val;
end

errors = zeros(k,1);
prev_error = -1;
rms_error = -1;
while 1
    clusters=cell(k,1);
    for i=1:size(feature_vector,1)
       p = feature_vector(i);
       clusterId = findNearestCluster(p,means,k);
       clusters{clusterId} = [clusters{clusterId};p];
    end
    
    for i=1:k
       cl_mean = mean(clusters{i});
       means(i) = cl_mean;
    end
    for i=1:k
       cluster = clusters{i};
       error = 0.0;
       for j=1:size(cluster,1)
           p = cluster(j);
          error = error + sqrt((p-means(i)).^2);
          
       end
       errors(k) = error;
    end
    prev_error = rms_error;
    rms_error = sum(errors);
    
    if prev_error ~=-1 && rms_error>=prev_error
        break;
    end
    
end

colors = zeros(k,1);
for i=1:k
   colors(i)=randi([0 255]); 
end
for i=1:size(img,1)
    for j=1:size(img,2)
       pixel = double(img(i,j));
       clusterId = findNearestCluster(pixel,means,k);
       img(i,j) = colors(clusterId);
    end
end

figure;
imshow(img);
end


function[clusterId] = findNearestCluster(p,means,k)
    dist = 1000000;
    clusterId = -1;
    
    for i=1:k
        cluster_mean = means(i);
       dst = sqrt((p-cluster_mean).^2);
       if dst<dist
           dist = dst;
           clusterId=i;
       end
    end
end

function[feature_vector] = construct_texture(imageFile,W)
grayImg = rgb2gray(imread(imageFile));
h1 = fspecial('gaussian', W, 0.62);

h2 = fspecial('gaussian', W, 1);
h3 = fspecial('gaussian', W, 1.6);

r1 = conv2(double(grayImg),h1,'same');
r2 = conv2(double(grayImg),h2,'same');
r3 = conv2(double(grayImg),h3,'same');

r = sqrt((r1.^2+r2.^2+r3.^2)/3);

feature_vector = reshape(r,size(r,1)*size(r,2),1);
end

function[feature_vector,filter_resp] = get_feature_vector_with_rgb_and_location(img_color,W)
grayImg= rgb2gray(img_color);
h1 = fspecial('gaussian', W, 0.62);

h2 = fspecial('gaussian', W, 1);
h3 = fspecial('gaussian', W, 1.6);

r1 = conv2(double(grayImg),h1,'same');
r2 = conv2(double(grayImg),h2,'same');
r3 = conv2(double(grayImg),h3,'same');

r = sqrt((r1.^2+r2.^2+r3.^2)/3);
filter_resp = r;

feature_vector = [];
for i=1:size(img_color,1)
    for j=1:size(img_color,2)
       filter_val = r(i,j);
       r_val = img_color(i,j,1);
       g_val = img_color(i,j,2);
       b_val = img_color(i,j,3);
       feature_vector = [feature_vector;filter_val,r_val,g_val,b_val,i,j];
    end
end
end
