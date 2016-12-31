% Apply constants
d   = 3;
f   = 5;
res = 100;
% Define axis
ax = linspace(-0.06,0.06,1128);
ay = linspace(-pi/4,pi/4,60);
az = linspace(-pi/4,pi/4,60);
% Load image and rename 
load('IMG_0861.jpeg')
im = HRI_3D;
% Make meshgrid (first step of creating sampling points)
xgrid = linspace(-0.1,0.1,res);
ygrid = linspace(-0.1,0.1,res);
zgrid = linspace(-0.1,0.1,res);
[XI, YI, ZI] = meshgrid(xgrid, ygrid, zgrid);
% Calculate view lines (second step of creating sampling points)
XO = (-XI/f).*(d+YI);
ZO = (-ZI/f).*(d+YI);
% Create rotation matrin (used to change viewpoint). 
% When a and b is both 0, no rotation is applied.
a = 0; b = 0;
R = [cosd(b)               sind(a)*sind(b)          cosd(a)*sind(b)
     0                     cosd(a)                  -sind(a)
     -sind(b)              cosd(b)*sind(a)          cosd(a)*cosd(b)];
% Gather in 3xN array
XYZ =  [XO(:) YI(:) ZO(:)];
% Rotating samplepoints
XYZ = R * XYZ';
% Translating samplepoints
x = XYZ(1,:);
y = XYZ(2,:);
z = XYZ(3,:);
% Making the transformed Vectors to 3- Matrix's  
xpts = reshape(x(:), res, res, res);
ypts = reshape(y(:), res, res, res);
zpts = reshape(z(:), res, res, res);
% Transform from cartesian coords to double circular coords
zy_sp = atan2(ypts,zpts);
zx_sp = atan2(xpts,zpts);
r_sp  = sqrt(xpts.^2 + ypts.^2 + zpts.^2);
% Interpolate image using the above information
int_img = interp3(ay, ax, az, im, zy_sp, r_sp, zx_sp);
int_img(isnan(int_img)) = -120;
img  = squeeze(max(int_img,[],1));