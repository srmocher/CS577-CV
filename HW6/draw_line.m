%
% function new_img = draw_line(img, p1, p2, width, r, g, b)
%
% The function draw_line creates an image based on the argument "img" and
% returns a new image with a line drawn into it. We assume that "img" is a three
% channel, RGB, image. The line goes from p1 to p2, where p1 and p2 are
% coordinates in Matlab "ij" image space. The width of the line is 1+2*width
% pixels. The color is specified by the last three arguments r,g,b, which are
% assumed to be a reasonalble type and range for "img". 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function new_img = draw_line(img, p1, p2, width, r, g, b)

   [ i j ] = bresenham ( p1(1), p1(2), p2(1), p2(2) );
   new_img = draw_points(img, [ i j ], width, r, g, b);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function new_img = draw_points (img, points, box_size, r, g, b)
   new_img = img;

   count = size(points, 1);

   for i = 1:count
       new_img = draw_box (new_img, points(i,1), points(i,2), box_size, r, g, b);
   end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function new_img = draw_box (img, ci, cj, box_size, r, g, b)

    new_img = img;

    [ m n d ] = size(img);

    i_min = max(1, round(ci) - box_size);
    i_max = min(m, round(ci) + box_size);

    j_min = max(1, round(cj) - box_size);
    j_max = min(n, round(cj) + box_size);

    for i =  i_min:i_max
        for j =  j_min:j_max
            new_img(i, j, 1) = r;
            new_img(i, j, 2) = g;
            new_img(i, j, 3) = b;
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Nice code from the web provided by  Aaron Wetzler. 
%

function [x y]=bresenham(x1,y1,x2,y2)

%Matlab optmized version of Bresenham line algorithm. No loops.
%Format:
%               [x y]=bham(x1,y1,x2,y2)
%
%Input:
%               (x1,y1): Start position
%               (x2,y2): End position
%
%Output:
%               x y: the line coordinates from (x1,y1) to (x2,y2)
%
%Usage example:
%               [x y]=bham(1,1, 10,-5);
%               plot(x,y,'or');
x1=round(x1); x2=round(x2);
y1=round(y1); y2=round(y2);
dx=abs(x2-x1);
dy=abs(y2-y1);
steep=abs(dy)>abs(dx);
if steep t=dx;dx=dy;dy=t; end

%The main algorithm goes here.
if dy==0 
    q=zeros(dx+1,1);
else
    q=[0;diff(mod([floor(dx/2):-dy:-dy*dx+floor(dx/2)]',dx))>=0];
end

%and ends here.

if steep
    if y1<=y2 y=[y1:y2]'; else y=[y1:-1:y2]'; end
    if x1<=x2 x=x1+cumsum(q);else x=x1-cumsum(q); end
else
    if x1<=x2 x=[x1:x2]'; else x=[x1:-1:x2]'; end
    if y1<=y2 y=y1+cumsum(q);else y=y1-cumsum(q); end
end

end

