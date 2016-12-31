function[] = partb()

k=5;
 kMeansCluster('sunset.tiff',k);
   kMeansCluster('tiger-1.tiff',k);
   kMeansCluster('tiger-2.tiff',k);
  
  k=10;
   kMeansCluster('sunset.tiff',k);
   kMeansCluster('tiger-1.tiff',k);
   kMeansCluster('tiger-2.tiff',k);


k=5;
 kMeansClusterWithLocation('sunset.tiff',k,1);
 kMeansClusterWithLocation('tiger-1.tiff',k,1);
% 
% % 
  kMeansClusterWithLocation('tiger-2.tiff',k,1);


kMeansClusterWithLocation('sunset.tiff',k,5);
 kMeansClusterWithLocation('tiger-1.tiff',k,5);
 kMeansClusterWithLocation('tiger-2.tiff',k,5);
 
 kMeansClusterWithLocation('sunset.tiff',k,10);
 kMeansClusterWithLocation('tiger-1.tiff',k,10);
 
  kMeansClusterWithLocation('sunset.tiff',k,15);
 kMeansClusterWithLocation('tiger-1.tiff',k,15);
 kMeansClusterWithLocation('tiger-2.tiff',k,5);
end

function[] = kMeansCluster(imageName,k)
    img = imread(imageName);
    temp_img = imread(imageName);
    r_means = zeros(k,1);
    g_means = zeros(k,1); 
    b_means = zeros(k,1);
   
    
    redPlane = img(:, :, 1);
    greenPlane = img(:, :, 2);
    bluePlane = img(:, :, 3);
    cluster_means=[];
    for i=1:k
        temp1 = randi([0,size(img,1)]);
        temp2 = randi([0,size(img,2)]);
       r_means(i) =  redPlane(temp1,temp2);
       g_means(i) = greenPlane(temp1,temp2);
       b_means(i) = bluePlane(temp1,temp2);
       cluster_means = [cluster_means;r_means(i),g_means(i),b_means(i)];
    end
      
   prev_means = zeros(size(cluster_means));
    clusters = cell(k,1);
    errors = zeros(k,1);
   
    rms_error = -1;
    while 1       
        clusters = cell(k,1);
           for l=1:size(img,1)
               for m=1:size(img,2)
                   r_val = redPlane(l,m);
                   g_val = greenPlane(l,m);
                   b_val = bluePlane(l,m);
                   point = [r_val;g_val;b_val];
                   clusterId = findNearestCluster(point,cluster_means,k);
                   clusters{clusterId} = [clusters{clusterId};point(1),point(2),point(3)];
               end
           end
           
           for i=1:k
              if size(clusters{i},1) == 0
                  point = get_random_point_from_clusters(clusters,k);
                  clusters{i} = [clusters{i};point(1),point(2),point(3)];
              end
           end
           
           for i=1:k
               cluster = clusters{i};
               temp = cluster';
               r_m = mean(temp(1,:));
               g_m = mean(temp(2,:));
               b_m = mean(temp(3,:));
               prev_means(i,:,:) = cluster_means(i,:,:);
               cluster_means(i,:,:) = [r_m,g_m,b_m];               
           end
          
           for i=1:k
              cluster = double(clusters{i});
              temp = cluster;
              cluster_mean = cluster_means(i,:,:);
              error = 0.0;
              for j=1:size(temp,1);
                  
                    p = temp(j,:);
                    error = error + sqrt(sum((p-cluster_mean).^2));
              end
              errors(i)=error;
           end
           prev_error = rms_error;
            rms_error = sum(errors);
            if prev_error~=-1 && prev_error == rms_error
               break; 
            end
    end
    
    for i=1:size(img,1)
        for j=1:size(img,2)
           pixel = [redPlane(i,j);greenPlane(i,j);bluePlane(i,j)];
           
           mean_color = get_mean_from_clusters(pixel,cluster_means,k);
           img(i,j,1) = mean_color(1);
           img(i,j,2) = mean_color(2);
           img(i,j,3) = mean_color(3);
        end        
    end
    
   
    figure;
   imshowpair(temp_img,img,'montage');
    
end

function[result] = check_if_border_pixel(img,i,j)
pixel = img(i,j,:);
left = img(i-1,j,:);
right = img(i+1,j,:);
top = img(i,j-1,:);
bottom = img(i,j+1,:);

if isequal(pixel,left) && isequal(pixel,right) && isequal(pixel,top) && isequal(pixel,bottom)
    result = 0;
else
    result=1;
end

end

function [mean_color] = get_mean_from_clusters(pixel,cluster_means,k)
    clusterId = -1;
    dist = -1;
    pixel = double(pixel);
    for i=1:k
      cl_mean = cluster_means(i,:,:);
      dst = sqrt(sum((cl_mean - pixel').^2));
      if dist == -1
          clusterId=1;
          dist = dst;
      end
      if dist > dst
         clusterId=i;
         dist= dst;
      end
    end
    mean_color = cluster_means(clusterId,:,:);
end

function[id] = findNearestCluster(point,cluster_means,k)
dist=10000000;
point = double(point');
id = -1;
    for i=1:k
       center = cluster_means(i,:);
       temp = sqrt(sum((point - center).^2));
       if temp<dist
           dist = temp;
           id = i;
       end
    end

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
