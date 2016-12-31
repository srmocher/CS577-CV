function [] = partb1()
   
image = rgb2gray(imread('climber.tiff'));
filter = fspecial('gaussian',3,6);
smoothed_image = conv2(double(image),filter,'same');

figure;
imshow(uint8(smoothed_image));
hx = [0.5 0 -0.5];
hy = [0.5;0;-0.5];
Fx = conv2(double(smoothed_image),hx,'same');
Fy = conv2(double(smoothed_image),hy,'same');
Gmag = zeros(size(image,1),size(image,2));
Gdir = zeros(size(image,1),size(image,2));

for i=1:size(image,1)
    for j=1:size(image,2)
        Gmag(i,j) = sqrt(Fx(i,j).^2+Fy(i,j).^2);
        Gdir(i,j) = atand(Fy(i,j)/Fx(i,j));        
    end
end

m = size(image,1) - 1;
n = size(image,2) - 1;

vals = isnan(Gdir);

threshold = 12;
for i=2:m
    for j=2:n
        if vals(i,j) == 0
            dir = Gdir(i,j);        
            rounded_angle = findRoundedAngle(dir);
            if rounded_angle==0
                left = Gmag(i-1,j);
                right = Gmag(i+1,j);
                max_val = max(Gmag(i,j),max(left,right));
                if max_val ~= Gmag(i,j) || Gmag(i,j)<threshold
                    Gmag(i,j)=0;
                end
            elseif rounded_angle==90
                up = Gmag(i,j-1);
                down = Gmag(i,j+1);
                max_val = max(Gmag(i,j),max(up,down));
                 if max_val ~= Gmag(i,j) || Gmag(i,j)<threshold
                    Gmag(i,j)=0;
                 end

            elseif rounded_angle==135
                northwest = Gmag(i-1,j-1);
                southeast = Gmag(i+1,j+1);
                max_val = max(Gmag(i,j),max(northwest,southeast));
                 if max_val ~= Gmag(i,j) || Gmag(i,j)<threshold
                    Gmag(i,j)=0;
                 end
            elseif rounded_angle==45
                northeast = Gmag(i+1,j-1);
                southwest = Gmag(i-1,j+1);
                max_val = max(Gmag(i,j),max(northeast,southwest));
                 if max_val ~= Gmag(i,j) || Gmag(i,j)<threshold
                    Gmag(i,j)=0;
                 end
            end
        end
     end
end

max_val = max(Gmag(:));
Gmag = (255/max_val)*Gmag;
figure;
imshow(uint8(Gmag));


    

end

function [angle] = findRoundedAngle(dir)
    diff1 = abs(dir-0);
    diff2 = abs(dir-45);
    diff3 = abs(dir-90);
    diff4 = abs(dir-135);
    min_res = min(diff1,min(diff2,min(diff3,diff4)));
    if min_res == diff1
        rounded_angle = 0;
    elseif min_res == diff2
        rounded_angle = 45;
    elseif min_res == diff3
        rounded_angle = 90;
    elseif min_res == diff4
        rounded_angle = 135;
    end
    angle = rounded_angle;
end



