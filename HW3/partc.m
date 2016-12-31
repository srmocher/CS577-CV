function[] = partc(camera_matrix)

image = imread('IMG_0861.jpeg');

phi = linspace(-pi/2,pi/2,100); %generate input values for phi
theta = linspace(0,2*pi,100);%generate input values for theta

[phi,theta] = meshgrid(phi,theta);%obtain grid points as x,y,z are functions of two variables

R=0.5; %radius
x = 3 + cos(phi).*cos(theta)*R; 
y = 2 + cos(phi).*sin(theta)*R;
z = 3 + sin(phi)*R;



P=[9,14,11]; % camera position

[nx,ny,nz] = surfnorm(x,y,z); %generate surface normal coordinates


X = x(:);
Y = y(:);
Z = z(:);
Nx = nx(:);
Ny = ny(:);
Nz = nz(:);
visible_points = [];%matrix to store visible points
points = [X,Y,Z];
N = [Nx,Ny,Nz];
for i=1:size(X,1)
    temp = points(i,:,:);
    diff = P -temp;
   
    if dot(diff,N(i,:,:))> 0 %condition to find point is visible
        visible_points = [visible_points;temp];
    end
end

tempOnes = ones(size(visible_points,1),1); % append 1 to make the coordinates homogeneous
temp = visible_points;
visible_points = [visible_points,tempOnes];
proj_points = camera_matrix*visible_points';%map visible 3D coordinates to 2D points using the camera matrix obtained in Part B
proj_points = proj_points';
f2= figure('Name','Image with sphere projected on it');
imshow(image);

hold on;
set(0, 'CurrentFigure', f2);
sphere_u=[];
sphere_v=[];
%Map 3D coordinates to 2D image coordinates
for i=1:size(proj_points,1)
    U = proj_points(i,1);
    V = proj_points(i,2);
    W = proj_points(i,3);
    u = U/W;
    v = V/W ;
    sphere_u = [sphere_u;u];
    sphere_v = [sphere_v;v];
end

   plot(sphere_u,sphere_v,'y.');
 hold on;
 light_dir = [33,29,44];
 shading_points = [];
for i=1:size(visible_points,1)
    intensity = dot(N(i,:,:),light_dir); %Lambertian dot product of normal and light direction gives intensity at that point
    if intensity <=0
        point = visible_points(i,:,:);
        img_point = camera_matrix*point';
        img_point(1:2) = img_point(1:2)/img_point(3);
        shading_points = [shading_points;img_point(1),img_point(2)];
    end
end
  
plot(shading_points(:,1),shading_points(:,2),'k.'); %shade the sphere at points based on intensity determined by Lambertian reflectance
hold off;
end