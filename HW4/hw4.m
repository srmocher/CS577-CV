function [] = hw4()
close all;
fid = fopen('light_directions.txt');


tline = fgetl(fid);
light_x = [],light_y=[],light_z=[];
while ischar(tline)
    tline = strtrim(tline);
    values = strsplit(tline,' ');
    light_x = [light_x,str2double(values(1))];
    light_y = [light_y,str2double(values(2))];
    light_z = [light_z,str2double(values(3))];
    tline = fgetl(fid);
end
V = [light_x;light_y;light_z];
V=V';
images  = cell(7,1);
for i=1:7
    str = strcat('4-',int2str(i),'.tiff');
    img = imread(str);
    images{i} = img;
end
[I,normals] = compute_normals(images,V);
new_image = zeros(400,400,3);

g = zeros(400,400,3);
light_vec = [0 0 1];


imagesGray = zeros( 7, 400, 400 );
imagesR = zeros(7, 400, 400 );
imagesG = zeros(7, 400, 400 );
imagesB = zeros( 7, 400, 400 );
albedoR = zeros(400, 400);
albedoG = zeros(400, 400);
albedoB = zeros(400, 400);
intensity = zeros(7,1);
J = zeros(7,1);
for i=1:7
  img = images{i};
  imgR = img(:,:,1);
  imgG = img(:,:,2);
  imgB = img(:,:,3);
  imagesGray(i,:,:) = rgb2gray(img);
  imagesR(i,:,:) = imgR;
  imagesG(i,:,:) = imgG;
  imagesB(i,:,:) = imgB;
end
imagesR = im2double(imagesR);
imagesG = im2double(imagesG);
imagesB = im2double(imagesB);
light_vec = [0 0 1];
for i=1:400
    for j=1:400
        for k=1:7
            intensity(k) = imagesR(k,i,j);
            J(k) = dot(V(k,:),reshape(normals(i,j,:),1,3));
        end   
        albedo = dot(intensity,J)/dot(J,J);
        albedoR(i,j) = albedo;
    end
end
 
for i=1:400
    for j=1:400
        for k=1:7
            intensity(k) = imagesB(k,i,j);
            J(k) = dot(V(k,:),reshape(normals(i,j,:),1,3));
        end   
        albedo = dot(intensity,J)/dot(J,J);
        albedoB(i,j) = albedo;
    end
end

for i=1:400
    for j=1:400
        for k=1:7
            intensity(k) = imagesG(k,i,j);
            J(k) = dot(V(k,:),reshape(normals(i,j,:),1,3));
        end   
        albedo = dot(intensity,J)/dot(J,J);
        albedoG(i,j) = albedo;
    end
end
albedoImg = zeros(400, 400, 3);
albedoImg(:,:,1) = albedoR;
albedoImg(:,:,2) = albedoG;
albedoImg(:,:,3) = albedoB;
maxR = max(albedoR);
maxG = max(albedoG);
maxB = max(albedoB);
albedoImg = albedoImg ./ max([maxR maxG maxB]);
figure('Name','Image with uniform albedo obtained using normals');
imshow(albedoImg);

x = 0:1:399;
y = 0:1:399;

r = draw_surface_map(normals);
figure('Name','Surface depth map obtained using normals');
surf(x,y,r);

partb();
partc();
end

function[r] = draw_surface_map(normals)
Fx = size(400,400);
Fy = size(400,400);
for i=1:400
    for j=1:400
        normal = reshape(normals(i,j,:),1,3);
        deriv = normal/normal(3);
        Fx(i,j) = deriv(1);
        Fy(i,j) = deriv(2);
    end
end

r=zeros(400,400);
for i=2:400
    r(i,1)=r(i-1,1)+Fy(i,1);
end

for i=2:400
    for j=2:400
        r(i,j)=r(i,j-1)+Fx(i,j);
    end
end
end

%L - light direction vectors
%images - set of images
function [I,N] = compute_normals(images,L)
   numImages = size(images);
   I = zeros(400,400,7);
   for i=1:numImages
       img = rgb2gray(images{i});
       for j=1:400
           for k=1:400         
               I(j,k,i) =img(j,k);
           end
       end
   end
  
    N = zeros(400,400,3);
   for h = 1:400
    for w = 1:400
            
            % Intensities
            i = reshape(I(h, w, :), [7, 1]);
            %Use linear least squares to obtain 3x1 normal vector
            n = (L.'*L)\(L.'*i);
                    if n~=0
                         n=n/norm(n);
                     else
                         n = [0;0;0];
                     end
            N(h, w, :) = n;
        
    end
   end
   
end



