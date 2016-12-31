function[] = partd()
images = readImages();
W=3;
h1 = fspecial('gaussian', W, 0.62);

h2 = fspecial('gaussian', W, 1);
h3 = fspecial('gaussian', W, 1.6);

filter_responses = cell(3,1);
vectors_rgb = cell(3,1);
features_rgb_location = cell(3,1);
for i=1:3
    img = images{i};
    grayImg =rgb2gray(images{i});
    vector = cell(size(grayImg,1),size(grayImg,2));
    vector_rgb = cell(size(grayImg,1),size(grayImg,2));
    vector_rgb_location = cell(size(grayImg,1),size(grayImg,2));
    r1 = conv2(double(grayImg),h1,'same');
    r2 = conv2(double(grayImg),h2,'same');
    r3 = conv2(double(grayImg),h3,'same');

    for l=1:size(grayImg,1)
        for m=1:size(grayImg,2)
        %   vector{l,m} = [r1(l,m),r2(l,m),r3(l,m)];
        %   vector_rgb = [r1(l,m),r2(l,m),r3(l,m),img(l,m,1),img(l,m,2),img(l,m,3)];
           vector_rgb_location{l,m} = [r1(l,m),r2(l,m),r3(l,m),img(l,m,1),img(l,m,2),img(l,m,3),l,m];
        end
    end
   % filter_responses{i} = vector;
    features_rgb_location{i} = vector_rgb_location;
end

k=5;
global_clusters = cell(3,1);
textons = cell(3,1);
for i=1:3
    vector = features_rgb_location{i};
   [clusters,means] = kmeansCluster(vector,k);
   global_clusters{i} = clusters;
   textons{i} = means;
end

textonDictionary = cell(k*3,1);
j=1;
for i=1:3
    textonVal = textons{i};
    for l=1:size(textonVal,1)
       textonDictionary{j} =textonVal(l,:);
       j=j+1;
    end
end

textonHistograms= zeros(k*2,1);
 
for i=1:3
    img = images{i};
    vector = features_rgb_location{i};
    textonMap = zeros(size(img,1),size(img,2),3);
    for l=1:size(img,1)
       for m=1:size(img,2)
           textonId = find_closest_texton(vector{l,m},textonDictionary,k);
           textonHistograms(textonId) = textonHistograms(textonId)+1;
           texton_val = textonDictionary{textonId};
           textonMap(l,m,1:3) = texton_val(1:3);
       end
    end
    imshow(uint8(textonMap));
end


end

function[textonId]=find_closest_texton(vector,textons,k)
    dist = 100000;
    vector = double(vector);
    textonId=-1;
    for i=1:2
        texton_lib = textons{i};
        dst = sqrt(sum((vector - texton_lib).^2));
        if dst<dist
           dist=dst;
           textonId = i;
        end
    end

end

function[clusters,means] = kmeansCluster(feature_vector,k)
means = zeros(k,8);

for i=1:k
    temp1 = randi([1 size(feature_vector,1)]);
    temp2 = randi([1 size(feature_vector,2)]);
    temp = feature_vector{temp1,temp2};
    means(i,:) = temp;
    
end
errors = zeros(k,1);
prev_error = -1;
rms_error = -1;

l=0;
while l<1
   clusters = cell(k,1);
   for i=1:size(feature_vector,1)
       for j=1:size(feature_vector,2)
           point = feature_vector{i,j};
           clusterId = get_nearest_cluster(point,means,k);
           clusters{clusterId} = [clusters{clusterId};point];
       end
   end
    
   for i=1:k
      if size(clusters{i},1)==0
         point = get_random_point_from_clusters(clusters,k);
         clusters{i} = [clusters{i};point];
      end
   end
   
   for i=1:k
       cluster = clusters{i};
       error=0.0;
       mean_val = double(means(i,:));
       for j=1:size(cluster,1)
           point = double(cluster(j,:));
           point = point;
           error = error+sqrt(sum((point-mean_val).^2));
       end
       errors(i)=error;
   end
   prev_error = rms_error;
   rms_error = sum(error);
   
  l=l+1;
   
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

function[clusterId] = get_nearest_cluster(point,means,k)
    dist = 100000;
    clusterId = -1;
    point = double(point);
    for i=1:k
        mean_val = means(i,:);
        dst = sqrt(sum((mean_val -point).^2));
        if dst<dist
            dist = dst;
            clusterId = i;
        end
    end
end


function[images] = readImages()
images = cell(2,1);
for i=1:3
   images{i} = imread(strcat('sample-',int2str(i),'.jpg')); 
end
end