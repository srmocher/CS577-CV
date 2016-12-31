function[] = hw7()
close all;
fid  = fopen('line_data_2.txt');
line = fgetl(fid);

x=[];y=[];
while ischar(line)
   line = strtrim(line);
   values = strsplit(line);
   x=[x;str2double(values{1})];
   y=[y;str2double(values{2})];
   line = fgetl(fid);
end
fclose(fid);
scatter(x,y);
data=[x,y];
points = fit_line_ransac(data,2,100,0.3,75);
y_coords = points(:,2);
x_coords = points(:,1);
one = ones(size(x_coords,1),1);
A = [x_coords,y_coords,one];
[E,V]= eig(A'*A);
vals = E(:,1);
a = vals(1);
b = vals(2);
c = vals(3);
y_est=[];
for i=1:size(x_coords,1)
   val = (-a*x_coords(i)-c)/b;
   y_est = [y_est;val];
end
hold on;
plot(x_coords,y_est);
diff=sqrt(sum((y_est-y_coords).^2));
partb();
partc();
end

%Fit set of points to a line using RANSAC - 
% data - set of points
% n - sample size
function[inliers] = fit_line_ransac(data,n,k,threshold,d)
sample = zeros(n,2);
indices = zeros(n,1);
points = data;
close_points = [];

index = randi([1 size(data,1)]);
sample(1:2,:) = data(1:2,:);
indices(1:2) = 1:2;
   
for i=1:k
    
    [m,c] = fitLine(sample);
    for j=1:size(data,1);
        if ismember(j,indices)==0
            point = data(j,:);
            distance = findDistance(m,c,point);
            if distance <=threshold
               close_points = [close_points;point];              
            end
        end
    end 
    if size(close_points,1) >=d
        data = [];
        data = close_points;
        inliers = close_points;
        close_points=[];
        indices=[];
        
        indices = zeros(size(data,1),1);
    else
        data = points;
        close_points = [];
        indices = zeros(size(data,1),1);
    end
    for j=1:n
           index = randi([1 size(data,1)]);
           sample(j,:) = data(index,:);
           indices(j) = index;
    end
    for j=1:n
           index = randi([1 size(data,1)]);
           sample(j,:) = data(index,:);
           indices(j) = index;
    end
end


end


function[m,b] = fitLine(sample)
point1 = sample(1,:);
point2 = sample(2,:);

m = (point2(2)-point1(2))/(point2(1)-point1(1));
b = point1(2) - m*point1(1);
end

function[distance] = findDistance(m,c,point)
 x = point(1);
 y = point(2);
 distance = abs((m*x-y+c))/(sqrt(m.^2+1));
end