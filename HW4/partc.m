function[] = partc()

I1 = imread('macbeth_syl-50MR16Q.tif');
figure('Name','syl image - canonical image');
imshow(I1);
x = [90,154];
y = [321,382];

r=[];g=[];b=[];
for i=x(1):1:x(2)
    for j=y(1):1:y(2)
        i = uint8(i);
        j = uint8(j);
        r = [r,I1(i,j,1)];
        g = [g,I1(i,j,2)];
        b = [b,I1(i,j,3)];       
    end    
end
meanR1 = mean(r);
meanG1 = mean(g);
meanB1 = mean(b);
scaleFactor = 4.8829;
meanR1 = uint8(scaleFactor*meanR1);
meanG1 = uint8(scaleFactor*meanG1);
meanB1 = uint8(scaleFactor*meanB1);


I2 = imread('macbeth_solux-4100.tif');
figure('Name','solux-4100 light');
imshow(I2);

r=[];g=[];b=[];
for i=x(1):1:x(2)
    for j=y(1):1:y(2)
        i = uint8(i);
        j = uint8(j);
        r = [r,I2(i,j,1)];
        g = [g,I2(i,j,2)];
        b = [b,I2(i,j,3)];       
    end    
end
meanR2 = mean(r);
meanG2 = mean(g);
meanB2 = mean(b);
scaleFactor = 4.6669;
meanR2 = uint8(scaleFactor*meanR2);
meanG2 = uint8(scaleFactor*meanG2);
meanB2 = uint8(scaleFactor*meanB2);

color1 = [meanR1,meanG1,meanB1];
color2 = [meanR2,meanG2,meanB2];
color1 = double(color1);
color2 = double(color2);
cos1 = dot(color1,color2)/(norm(color1)*norm(color2));
ang_error = acosd(cos1);

I3 = zeros(size(I2,1),size(I2,2),3);
I4 = zeros(size(I2,1),size(I2,2),3);
for i=1:size(I2,1)
    for j=1:size(I2,2)
        r = (meanR1/meanR2)*I2(i,j,1);
        g = (meanG2/meanG1)*I2(i,j,2);
        b = (meanB2/meanB1)*I2(i,j,3);
        [R,G,B] = scale(r,g,b);
        I3(i,j,1) = R;
        I3(i,j,2) = G;
        I3(i,j,3) = B;
    end
end
figure('Name','Improved (Corrected) image');


 red_scale = 250/max(max(double(I2(:,:,1))));
 green_scale = 250/max(max(double(I2(:,:,2))));
 blue_scale = 250/max(max(double(I2(:,:,3))));
 I3(:,:,1) = red_scale*double(I2(:,:,1));
 I3(:,:,2) = green_scale*double(I2(:,:,2));
 I3(:,:,3) = blue_scale*double(I2(:,:,3));
 I3 = uint8(I3);
 imshow(I3);
 
 figure('Name','Canonical image');
 imshow(I1);
 
 red_scale = 250/max(max(double(I1(:,:,1))));
 green_scale = 250/max(max(double(I1(:,:,2))));
 blue_scale = 250/max(max(double(I1(:,:,3))));
 I4(:,:,1) = red_scale*double(I1(:,:,1));
 I4(:,:,2) = green_scale*double(I1(:,:,2));
 I4(:,:,3) = blue_scale*double(I1(:,:,3));
 I4 = uint8(I3);
 %I2 and I1
 
 rms_1 = computeRMS(I1,I2);
 rms_2 = computeRMS(I1,I3);
 
 solux_apples2 = imread('apples2_solux-4100.tif');
 temp = solux_apples2(:,:,1)
 maxR_apples2 = max(temp(:));
 temp = solux_apples2(:,:,2)
 maxG_apples2 = max(temp(:));
 temp = solux_apples2(:,:,3)
 maxB_apples2 = max(temp(:));
 [maxR_apples2,maxG_apples2,maxB_apples2] = scale(maxR_apples2,maxG_apples2,maxB_apples2);
 apples2_color = double([maxR_apples2,maxG_apples2,maxB_apples2]);
 
 solux_ball = imread('ball_solux-4100.tif');
 temp = solux_ball(:,:,1);
 maxR_ball = max(temp(:));
  temp = solux_ball(:,:,2);
 maxG_ball = max(temp(:));
  temp = solux_ball(:,:,3);
 maxB_ball = max(temp(:));
 [maxR_ball,maxG_ball,maxB_ball] =scale(maxR_ball,maxG_ball,maxB_ball);
 ball_color = double([maxR_ball,maxG_ball,maxB_ball]);
 
 solux_blocks = imread('blocks1_solux-4100.tif');
 temp = solux_blocks(:,:,1);
 maxR_blocks = max(temp(:));
 temp = solux_blocks(:,:,2);
 maxG_blocks = max(temp(:));
 temp = solux_blocks(:,:,3);
 maxB_blocks = max(temp(:));
 [maxR_blocks,maxG_blocks,maxB_blocks] = scale(maxR_blocks,maxG_blocks,maxB_blocks);
 blocks_color = double([maxR_blocks,maxG_blocks,maxB_blocks]);
 
 ang_error_apples = compute_angular_error(apples2_color,color2);
 ang_error_ball = compute_angular_error(ball_color,color2);
 ang_error_blocks = compute_angular_error(blocks_color,color2);
 
  temp = solux_apples2(:,:,1)
 aveR_apples2 = mean(temp(:));
 temp = solux_apples2(:,:,2)
 aveG_apples2 = mean(temp(:));
 temp = solux_apples2(:,:,3)
 aveB_apples2 = mean(temp(:));
 
  temp = solux_ball(:,:,1);
 aveR_ball = mean(temp(:));
  temp = solux_ball(:,:,2);
 aveG_ball = mean(temp(:));
  temp = solux_ball(:,:,3);
 aveB_ball = mean(temp(:));
 
 temp = solux_blocks(:,:,1);
 aveR_blocks = mean(temp(:));
 temp = solux_blocks(:,:,2);
 aveG_blocks = mean(temp(:));
 temp = solux_blocks(:,:,3);
 aveB_blocks = mean(temp(:));
 
 [aveR_apples2,aveG_apples2,aveB_apples2] = scale(aveR_apples2,aveG_apples2,aveB_apples2)
 apples2_gray_color = double([aveR_apples2,aveG_apples2,aveB_apples2]);
 [aveR_ball,aveG_ball,aveB_ball] = scale(aveR_ball,aveG_ball,aveB_ball);
  ball_gray_color = double([aveR_ball,aveG_ball,aveB_ball]);
  [aveR_blocks,aveG_blocks,aveB_blocks] = scale(aveR_blocks,aveG_blocks,aveB_blocks);
   blocks_gray_color = double([aveR_blocks,aveG_blocks,aveB_blocks]);
   
  ang_error_apples = compute_angular_error(apples2_gray_color,color2);
 ang_error_ball = compute_angular_error(ball_gray_color,color2);
 ang_error_blocks = compute_angular_error(blocks_gray_color,color2);
 
 %display corrected images using grey world algorithm
 figure('Name','solux_apples2.tif');
 imshow(solux_apples2);
 figure('Name','solux_ball.tif');
 imshow(solux_ball);
 figure('Name','blocks_syl-50MR16Q.tif');
 imshow(imread('blocks1_syl-50MR16Q.tif'));
 
 figure('Name','apples2_syl-50MR16Q.tif');
 imshow(imread('apples2_syl-50MR16Q.tif'));
 figure('Name','ball_syl-50MR16Q.tif');
 imshow(imread('ball_syl-50MR16Q.tif'));
 figure('Name','solux_blocks.tif');
 imshow(solux_blocks);
 solux_apples2_corrected = display_grey_world_image(solux_apples2);
 solux_ball_corrected = display_grey_world_image(solux_ball);
 solux_blocks_corrected = display_grey_world_image(solux_blocks);
 
 rms_apples2_grey  = computeRMS(solux_apples2,solux_apples2_corrected);
 rms_ball_grey = computeRMS(solux_ball,solux_ball_corrected);
 rms_blocks_grey = computeRMS(solux_blocks,solux_blocks_corrected);
 
  solux_apples2_max_corrected = display_max_rgb_image(solux_apples2);
 solux_ball_max_corrected = display_max_rgb_image(solux_ball);
 solux_blocks_max_corrected = display_max_rgb_image(solux_blocks);
 
  rms_apples2_maxrgb  = computeRMS(solux_apples2,solux_apples2_max_corrected);
 rms_ball_maxrgb = computeRMS(solux_ball,solux_ball_max_corrected);
 rms_blocks_maxrgb = computeRMS(solux_blocks,solux_blocks_max_corrected);
end

function [output] = display_max_rgb_image(I)
m = size(I,1);
n = size(I,2);
temp_R = double(I(:,:,1));
temp_G = double(I(:,:,2));
temp_B = double(I(:,:,3));
output = zeros(m,n,3);
    Rmax     = max(temp_R(:));
    Gmax      = max(temp_G(:));
Bmax      = max(temp_B(:));
            Max        = max([Rmax Gmax Bmax]);
            Kr         = Max/Rmax;
            Kg         = Max/Gmax;
            Kb         = Max/Bmax;
            output(:,:,1) = Kr*double(I(:,:,1));
            output(:,:,2) = Kg*double(I(:,:,2));
            output(:,:,3) = Kb*double(I(:,:,3));
            output = uint8(output);
            figure('Name','Displaying image using MaxRGB algorithm');
            imshow(output);
end
function [output] = display_grey_world_image(I)
m = size(I,1);
n = size(I,2);
output = zeros(m,n,3);
    Ravg     = sum(sum(I(:,:,1)))/(m*n);
    Gavg      = sum(sum(I(:,:,2)))/(m*n);
Bavg      = sum(sum(I(:,:,3)))/(m*n);
            Avg        = mean([Ravg Gavg Bavg]);
            Kr         = Avg/Ravg;
            Kg         = Avg/Gavg;
            Kb         = Avg/Bavg;
            output(:,:,1) = Kr*double(I(:,:,1));
            output(:,:,2) = Kg*double(I(:,:,2));
            output(:,:,3) = Kb*double(I(:,:,3));
            output = uint8(output);
            figure('Name','Displaying image using greyworld algorithm');
            imshow(output);
end

function [R,G,B] = scale(r,g,b)
maxVal = max(r,max(g,b));
if maxVal == r
    K = 250/double(r);
end
if maxVal ==g
        K = 250/double(g);
end
if maxVal == b
            K = 250/double(b);
 end
    R = K*r;
    G = K*g;
    B = K*b;
end

function [rms] = computeRMS(I1,I2)

 
 r_chr_vals_1=[];r_chr_vals_2=[];
 g_chr_vals_1=[];g_chr_vals_2=[];
for i=1:size(I2,1)
    for j=1:size(I2,2)
        r_pix_1 = I1(i,j,1);
        r_pix_2 = I2(i,j,1);
        
        g_pix_1 = I1(i,j,2);
        g_pix_2 = I2(i,j,2);
        
        b_pix_1 = I1(i,j,3);
        b_pix_2 = I2(i,j,3);
        
        r_chr_1 = double(r_pix_1)/(double(r_pix_1+g_pix_1+b_pix_1));
        r_chr_2 = double(r_pix_2)/(double(r_pix_2+g_pix_2+b_pix_2));
        
        g_chr_1 = double(g_pix_1)/(double(r_pix_1+g_pix_1+b_pix_1));
        g_chr_2 = double(g_pix_2)/(double(r_pix_2+g_pix_2+b_pix_2));
        
        if (r_pix_1 + g_pix_1 + b_pix_1 >=10) && (r_pix_2 + g_pix_2 + b_pix_2 >=10)
            r_chr_vals_1 = [r_chr_vals_1;r_chr_1];
            g_chr_vals_1 = [g_chr_vals_1;g_chr_1];
       
            r_chr_vals_2 = [r_chr_vals_2;r_chr_2];
            g_chr_vals_2 = [g_chr_vals_2;g_chr_2];
        end
    end
end

r_diff = (r_chr_vals_2 - r_chr_vals_1).^2;
g_diff = (g_chr_vals_2 - g_chr_vals_1).^2;
 
r_rms = sqrt(sum(r_diff)/size(r_diff,1));
g_rms = sqrt(sum(g_diff)/size(g_diff,1));

rg_rms = sqrt((r_rms.^2 + g_rms.^2)/2);
rms = rg_rms;
end

function [error] = compute_angular_error(vec1,vec2)
cosine = dot(vec1,vec2)/((norm(vec1)*norm(vec2)));
error = acosd(cosine);
end


