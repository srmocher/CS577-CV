function[]= hw3()
% Part A is about line fitting, part B about computing camera matrix
% Part C is about rendering sphere and Part D is about decomposing the
% camera matrix
close all;
fid = fopen('line_data.txt');

tline = fgetl(fid);
x = [],y=[];
while ischar(tline)
    tline = strtrim(tline);
    values = strsplit(tline,' ');
    x=[x,str2double(values(1))];
    y=[y,str2double(values(2))];
     
    tline = fgetl(fid);
end
fclose(fid);
U=[];
for i=1:100
    U=[U;x(i),1];    
end
result = pinv(U)*y';
slope = result(1,:);
intercept = result(2,:);

Y = slope*x + intercept;
figure('Name','Line fitting using non-homogenous linear least squares');
plot(x,y,'*');
hold on;
plot(x,Y);

xMean = mean(x);
yMean = mean(y);

A=[];
for i=1:size(x,2)
    A = [A;x(i) - xMean,y(i) - yMean];
end

[V,D] = eig(A'*A);
eigVec = V(:,1)
a = eigVec(1);
b = eigVec(2);

d = abs(a*xMean+b*yMean);
dist_diff=[];
sum_dist_diff = 0
for i=1:100
    temp = abs((y(i) - slope*x(i)-intercept)/(sqrt(1+slope*slope)));
    sum_dist_diff = sum_dist_diff + temp*temp;
end

dist_diff_tla=[];
sum_dist_tla=0;
for i=1:100
    temp = abs((a*x(i)+b*y(i)-d)/sqrt(a*a+b*b));
    sum_dist_tla = sum_dist_tla+temp*temp;
end

rms_dist = sqrt(sum_dist_diff/100);
rms_dist_tla = sqrt(sum_dist_tla/100);

Y_tla = [];
for i=1:size(y,2)
   temp = (-a/b)*x(i) + d/b; 
   Y_tla = [Y_tla;temp];
end

figure('Name','Line fitting with Total Least Squares');
plot(x,Y_tla);
hold on;
plot(x,y,'*');
hold off;

slope_tla = -a/b;
intercept_tla = d/b;


%find vertical RMS error
diffY = [];
diffY_tla=[];

for i=1:100
    diffY=[diffY,Y(i)-y(i)];  
    diffY_tla = [diffY_tla,Y_tla(i) - y(i)]
end

sum_Y=0;
sum_Y_tla=0;
for i=1:100
    sum_Y = sum_Y + diffY(i)*diffY(i);
    sum_Y_tla = sum_Y_tla+diffY_tla(i)*diffY_tla(i);
end

rms_Y = sqrt(sum_Y/100); %0.1250
rms_Y_tla = sqrt(sum_Y_tla/100);%3.9756

partb();
end