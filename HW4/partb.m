function [] = partb()

fid = fopen('color_light_directions_1.txt');


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
V = V';

fclose(fid);
fid = fopen('color_light_colors_1.txt');
tline = fgetl(fid);
light_r = [];light_g=[];light_b=[];
while ischar(tline)
    tline = strtrim(tline);
    values = strsplit(tline,' ');
    light_r = [light_r,str2double(values(1))];
    light_g = [light_g,str2double(values(2))];
    light_b = [light_b,str2double(values(3))];
    tline = fgetl(fid);
end
I = imread('color_photometric_stereo_1.tiff');
images = cell(1,1);
images{1} = I;
compute_surface_map(images,V,size(I,1),size(I,2));


I = imread('color_photometric_stereo_2.tiff');
images = cell(1,1);
images{1} = I;

fid = fopen('color_light_directions_1.txt');


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
V = V';
compute_surface_map(images,V,size(I,1),size(I,2));
end

function [] = compute_surface_map(images,V,height,width)
imagesGray = zeros( 1, height, width );
imagesR = zeros(1, height, width );
imagesG = zeros(1, height, width );
imagesB = zeros(1, height, width );

J = zeros(5,1);
  img = images{1};
  imgR = img(:,:,1);
  imgG = img(:,:,2);
  imgB = img(:,:,3);
  imagesGray(1,:,:) = rgb2gray(img);
  imagesR(1,:,:) = imgR;
  imagesG(1,:,:) = imgG;
  imagesB(1,:,:) = imgB;

imagesR = im2double(imagesR);
imagesG = im2double(imagesG);
imagesB = im2double(imagesB);

[intensities,normals] = compute_normals(images,V,height,width);

%figure('Name','Image with uniform albedo obtained using normals');
%imshow(albedoImg);
x = 0:1:399;
y = 0:1:399;
z = draw_surface_map(normals);
figure('Name','Surface map');
surf(x,y,z);
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

function [I,N] = compute_normals(images,L,height,width)
   numImages = size(images);
   I = zeros(height,width,5);
   for i=1:numImages
       img = images{i};
       for j=1:height
           for k=1:width   
              r = img(j,k,1);
              g = img(j,k,2);
              b = img(j,k,3);
              intens = norm(double([r g b]));
               I(j,k,i) =intens;
           end
       end
   end
  
    N = zeros(height,width,3);
   for h = 1:height
    for w = 1:width
            
            % Intensities
            i = reshape(I(h, w, :), [5, 1]);
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