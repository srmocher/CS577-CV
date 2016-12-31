
function[] = kmeansclusterwithcolorandlocation(img_color,feature_vector,filter_resp,k)
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
      x_m = mean(cluster(:,5));
      y_m = mean(cluster(:,6));
      feature_means(i,:) = double([mean_filter_val;r_m;g_m;b_m;x_m;y_m]);
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
             p = [filter_val,r,g,b,i,j];
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

