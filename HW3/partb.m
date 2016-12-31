function[] = partb()

image = imread('IMG_0862.jpeg');
f1 = figure('Name','15 points - actual positions and projected positions')
imshow(image);
%set(imgHandle,'ButtonDownFcn',@ImageClickCallback);
%[u,v] = ginput(15);

fid = fopen('world_coords.txt');

line = fgetl(fid);
world_x=[];
world_y=[];
world_z=[];
while ischar(line)
   line = strtrim(line);
   values = strsplit(line,' ');
   world_x=[world_x,str2double(values(1))];
   world_y=[world_y,str2double(values(2))];
   world_z=[world_z,str2double(values(3))];
   line = fgetl(fid);
end

world_coords = [world_x;world_y;world_z];
world_coords = world_coords';
onestemp = ones(15,1);
world_coords =[world_coords,onestemp];

fclose(fid);

fid = fopen('image_coords.txt');
line = fgetl(fid);
image_x = [];image_y=[];
temp=[];
while ischar(line)
    line = strtrim(line);
   temp = strsplit(line,' ');
    image_x=[image_x,str2double(temp(1))];
    image_y=[image_y,str2double(temp(2))];
    line = fgetl(fid);
end
image_coords = [image_x;image_y];
image_coords = image_coords';
P=[];
zeroelem = repelem(0,4); % 1x4 0 vector for building P

for i=1:15
    world_row = world_coords(i,:);    
    image_coord = image_coords(i,:);
    img_u = image_coord(1);
    temp1 = -img_u*world_row;
    row1 = [world_row,zeroelem,temp1]; %build row 1 for point
    
    
    img_v = image_coord(2);
    temp2 = -img_v*world_row;
    row2 = [zeroelem,world_row,temp2]; %build row 2 for point
    
    P=[P;row1;row2];
end

transp_prod = P'*P;
[V,D] = eig(transp_prod);
if ~issorted(diag(D))
    [V,D] = eig(transp_prod);
    [D,I] = sort(diag(D));
    V = V(:, I);
end
%[U, S, V] = svd(P,0);
%[U, S, V] = svd(P,0);
m = V(:,1);%12x1 unit vector with norm(m)=1

M = reshape(m,4,3)';%camera_matrix
m1 = m(1:4)';
m2 = m(5:8)';
m3 = m(9:12)';


U=[];
V=[];
for i=1:15
    u1 = dot(m1,world_coords(i,:))/dot(m3,world_coords(i,:));
    v1 = dot(m2,world_coords(i,:))/dot(m3,world_coords(i,:));
    U=horzcat(U,u1);
    V = horzcat(V,v1);
end

hold on;
labels = cellstr(num2str((1:15)'));
set(0, 'CurrentFigure', f1);
plot(U,V,'r.','MarkerSize',20);
text(U(:), V(:), labels, 'VerticalAlignment','bottom', ...
                             'HorizontalAlignment','right')
hold on;
plot(image_x,image_y,'b.','MarkerSize',20);
text(image_x(:), image_y(:), labels, 'VerticalAlignment','bottom', ...
                             'HorizontalAlignment','left')
hold off;
final = [U;V];

diff = image_coords' - final;
diff = diff(:);
sum = 0;
for i=1:15
    sum = sum+diff(i)*diff(i);
end
%calculate RMS error
rms = sqrt(sum/15);

%do part C
partc(M);

%do part D
partd(M);
end
