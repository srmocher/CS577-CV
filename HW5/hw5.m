function[] = hw5()
close all;
image = rgb2gray(imread('climber.tiff'));
figure('Name','Original image');

imshow(image);
hx = [0.5 0 -0.5]; %X mask
hy = [0.5;0;-0.5]; %Y mask
Fx = conv2(double(image),hx,'same'); %Find gradient in X direction
Fy = conv2(double(image),hy,'same'); %Find gradient in Y direction

grad_mag = zeros(size(image,1),size(image,2));
grad_dir = zeros(size(image,1),size(image,2));
for i=1:size(image,1)
    for j=1:size(image,2)
       grad_mag(i,j) = sqrt(Fx(i,j).^2+Fy(i,j).^2); %Gradient magnitude at each pixe
       grad_dir(i,j) = atan(Fy(i,j)/Fx(i,j)); %Gradient direction at each pixel
    end
end

maxVal = max(grad_mag(:));
grad_mag = (255/maxVal)*grad_mag;
figure('Name','Gradient magnitude');
imshow(uint8(grad_mag));

maxVal = max(Fx(:));
Fx = (255/maxVal)*Fx;
figure('Name','X gradient');
imshow(uint8(Fx));

maxVal = max(Fy(:));
Fy = (255/maxVal)*Fy
figure('Name','Y gradient');
imshow(uint8(Fy));


new_image = zeros(size(image,1),size(image,2));
threshold = 60;
for i=1:size(image,1)
    for j=1:size(image,2)
        gradient = sqrt(Fx(i,j).^2+Fy(i,j).^2);
        if gradient > threshold
           new_image(i,j)=255; 
        end
    end
end

figure('Name','Edges using gradient magnitude')
imshow(new_image);
n=9; %range -4 to 4
coords = -floor(n/2):floor(n/2);
[x,y] = meshgrid(coords,coords);
sig =2;
h = exp(-(x.^2+y.^2)/(2*sig*sig)); %use gaussian function
h = h/sum(h(:)); %filter should sum to 1
h_temp = h;
figure('Name','Surface plot of gaussian filter');
surf(x,y,h);

tic
result3 = conv2(double(image),h);
toc
figure('Name','Gaussian filter with sigma 2');
imshow(uint8(result3));


%problem 4
hx_4 = [0.5 0 -0.5];
hy_4 = [0.5;0;-0.5];
Fx_4 = conv2(double(result3),hx_4,'same');
Fy_4 = conv2(double(result3),hy_4,'same');

new_image_4 = zeros(size(result3,1),size(result3,2));
threshold = 8;
for i=1:size(result3,1)
    for j=1:size(result3,2)
        gradient = sqrt(Fx_4(i,j).^2+Fy_4(i,j).^2);
        if gradient > threshold
           new_image_4(i,j)=255; 
        end
    end
end

figure('Name','Edge detection after blurring using gaussian filter');
imshow(new_image_4);

%problem 5
n=9;
coords = -floor(n/2):floor(n/2);
[x,y] = meshgrid(coords,coords);
sig =4;
h = exp(-(x.^2+y.^2)/(2*sig*sig));
h = h/sum(h(:));
image_5_x = conv2(conv2(double(image),hx,'same'),h,'same');%applying smoothing and finite difference filter in X direction
image_5_y = conv2(conv2(double(image),hy,'same'),h,'same');%applying smooting and finite difference filter in Y direction

new_result_5 = zeros(size(image,1),size(image,2));
threshold = 8; %threshold
for i=1:size(image,1)
    for j=1:size(image,2)
        gradient = sqrt(image_5_x(i,j).^2+image_5_y(i,j).^2);
        if gradient > threshold
           new_result_5(i,j)=255; 
        end
    end
end
figure('Name','Problem 5');
imshow(new_result_5);

%problem 6
[A,B,C] = svd(h_temp);
K1 = A(:,1)*sqrt(B(1,1));
K2 = C(:,1)*sqrt(B(1,1));
tic
result_1d = conv2(K1,K2,double(image),'same');
toc
figure('Name','Gaussian filter using combination of 1-D convolutions');
imshow(uint8(result_1d));
partb1();
partb2();
end
