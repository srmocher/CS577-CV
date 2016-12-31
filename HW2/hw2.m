function[] = hw2()
%Homework 2 - includes Part A, B in code
%We assume that rgb_sensors.txt, light_spectra.txt and responses.txt lie in
%the same folder
%part b code is in partb.m file which is invoked from hw2.m
%We solve problem sequentially 1,2,3,4...7
close all
fid = fopen('rgb_sensors.txt');

tline = fgetl(fid);
col1 = [],col2=[],col3=[];
while ischar(tline)
    values = strsplit(tline,' ');
    col1=[col1,str2double(values(1))];
    col2=[col2,str2double(values(2))];
    col3=[col3,str2double(values(3))];
    tline = fgetl(fid);
end
fclose(fid);

sens_mat = [col1;col2;col3];
rng(477);
light_mat = rand([101 1600]);
resp_mat = sens_mat*light_mat;
k=255/max(resp_mat(:));
mod_light_mat = light_mat*k;
mod_resp_mat = sens_mat*mod_light_mat;
new_max = max(mod_resp_mat(:));
red_vec = mod_resp_mat(1,:);
green_vec = mod_resp_mat(2,:);
blue_vec = mod_resp_mat(3,:);
red_block=[];
green_block=[];
blue_block=[];

%repeat 10x10 blocks and have 40 per row
for i=1:40:1561
   red_block = [red_block;repelem(red_vec(i:i+39),10,10)];
   green_block = [green_block;repelem(green_vec(i:i+39),10,10)];
   blue_block = [blue_block;repelem(blue_vec(i:i+39),10,10)];
end
image = cat(3,red_block,green_block,blue_block);
figure('Name','400x400 Image of 1600 10x10 blocks');
imshow(uint8(image));
%Problem 1 ends here


%Problem 2 starts here
sens_estimated = pinv(mod_light_mat')*mod_resp_mat';
resp_est = sens_estimated' * mod_light_mat;

red_sens_estimated = sens_estimated(:,1);
green_sens_estimated = sens_estimated(:,2);
blue_sens_estimated = sens_estimated(:,3);
red_sens_actual = sens_mat(1,:);
green_sens_actual = sens_mat(2,:);
blue_sens_actual = sens_mat(3,:);
wavelengths = 380:4:780;
figure('Name','Plot of actual sensor values vs. estimated sensor values')
p1=plot(wavelengths,red_sens_actual,'r',wavelengths,red_sens_estimated,'r--');
p1(2).LineWidth=1.5;
hold on;
p2=plot(wavelengths,green_sens_actual,'g',wavelengths,green_sens_estimated,'g--');
p2(2).LineWidth=1.5;
hold on;
p3=plot(wavelengths,blue_sens_actual,'b',wavelengths,blue_sens_estimated,'b--');
p3(2).LineWidth=1.5;
legend('Actual sensor(red)','Estimated sensor(red)','Actual sensor(green)','Estimated sensor(green)','Actual sensor(blue)','Estimated sensor(blue)');

red_sens_diff = red_sens_actual - red_sens_estimated';
green_sens_diff = green_sens_actual - green_sens_estimated';
blue_sens_diff = blue_sens_actual - blue_sens_estimated';

red_sens_sum=0;
green_sens_sum=0;
blue_sens_sum=0;
for i=1:101
    red_sens_sum=red_sens_sum+red_sens_diff(i)*red_sens_diff(i);
    green_sens_sum=green_sens_sum+green_sens_diff(i)*green_sens_diff(i);
    blue_sens_sum=blue_sens_sum+blue_sens_diff(i)*blue_sens_diff(i);
end
red_sens_rms = sqrt(red_sens_sum/101);
green_sens_rms = sqrt(green_sens_sum/101);
blue_sens_rms = sqrt(blue_sens_sum/101);

red_actual = mod_resp_mat(1,:);
green_actual = mod_resp_mat(2,:);
blue_actual = mod_resp_mat(3,:);

red_est = resp_est(1,:);
green_est = resp_est(2,:);
blue_est = resp_est(3,:);

red_diff = red_actual - red_est;
green_diff = green_actual - green_est;
blue_diff = blue_actual - blue_est;

red_sum=0;green_sum=0;blue_sum=0;
for i=1:1600
    red_sum = red_sum+red_diff(i)*red_diff(i);
    green_sum = green_sum + green_diff(i)*green_diff(i);
    blue_sum = blue_sum + blue_diff(i)*blue_diff(i);
end
red_rms = sqrt(red_sum/1600);
green_rms = sqrt(green_sum/1600);
blue_rms = sqrt(blue_sum/1600);
%end of problem 2

%Problem 3
noise_mat = rand(3,1600)*10;
resp_err_mat = mod_resp_mat + noise_mat;
sens_err_mat = pinv(mod_light_mat')*resp_err_mat';
red_sens_err_estimated = sens_err_mat(:,1);
green_sens_err_estimated = sens_err_mat(:,2);
blue_sens_err_estimated = sens_err_mat(:,3);
figure('Name','Plot of actual sensor values vs. estimated sensor values after noise of order 10')
plot(wavelengths,red_sens_actual,'r',wavelengths,red_sens_err_estimated,'r--');
hold on;
plot(wavelengths,green_sens_actual,'g',wavelengths,green_sens_err_estimated,'g--');
hold on;
plot(wavelengths,blue_sens_actual,'b',wavelengths,blue_sens_err_estimated,'b--');
legend('Actual sensor(red)','Estimated sensor(red)','Actual sensor(green)','Estimated sensor(green)','Actual sensor(blue)','Estimated sensor(blue)');

rgb_err_mat = mod_light_mat'*sens_err_mat;
k_const = 255/max(rgb_err_mat(:));
light_err_mat = k_const*mod_light_mat; %determine scaling factor
sens_err_mod_mat = pinv(light_err_mat')*rgb_err_mat;
rgb_err_mod_mat = light_err_mat'*sens_err_mod_mat;
red_err_mod_sense = sens_err_mod_mat(:,1);
green_err_mod_sense = sens_err_mod_mat(:,2);
blue_err_mod_sense = sens_err_mod_mat(:,3);

red_err_mod = rgb_err_mod_mat(:,1);
green_err_mod = rgb_err_mod_mat(:,2);
blue_err_mod = rgb_err_mod_mat(:,3);


figure('Name','Plot of actual sensor values vs. estimated sensor values after noise of order 10 and clipping')
plot(wavelengths,red_sens_actual,'r',wavelengths,red_err_mod_sense,'r--');
hold on;
plot(wavelengths,green_sens_actual,'g',wavelengths,green_err_mod_sense,'g--');
hold on;
plot(wavelengths,blue_sens_actual,'b',wavelengths,blue_err_mod_sense,'b--');
legend('Actual sensor(red)','Estimated sensor(red)','Actual sensor(green)','Estimated sensor(green)','Actual sensor(blue)','Estimated sensor(blue)');

red_clipped_sens_rms = computeRms(red_sens_actual,red_err_mod_sense',101);
green_clipped_sens_rms = computeRms(green_sens_actual,green_err_mod_sense',101);
blue_clipped_sens_rms = computeRms(blue_sens_actual,blue_err_mod_sense',101);

overall_clipped_sens_rms = sqrt((red_clipped_sens_rms*red_clipped_sens_rms+green_clipped_sens_rms*green_clipped_sens_rms+blue_clipped_sens_rms*blue_clipped_sens_rms)/3);

red_clipped_rms = computeRms(red_actual,red_err_mod',1600);
green_clipped_rms = computeRms(green_actual,green_err_mod',1600);
blue_clipped_rms= computeRms(blue_actual,blue_err_mod',1600);

overall_clipped_rms = sqrt((red_clipped_rms*red_clipped_rms+green_clipped_rms*green_clipped_rms+blue_clipped_rms*blue_clipped_rms)/3);

overall_rms_mat=[];
%Problem 4
for i=0:10
    noise_mat = rand(3,1600)*10*i;
    resp_err_mat = mod_resp_mat + noise_mat;
    sens_err_mat = pinv(mod_light_mat')*resp_err_mat';
    
    red_sens_err_estimated = sens_err_mat(:,1);
    green_sens_err_estimated = sens_err_mat(:,2);
    blue_sens_err_estimated = sens_err_mat(:,3);
    
    red_sens_rms = computeRms(red_sens_actual,red_sens_err_estimated',101);
    green_sens_rms = computeRms(green_sens_actual,green_sens_err_estimated',101);
    blue_sens_rms = computeRms(blue_sens_actual,blue_sens_err_estimated',101);
    
    overall_sens_rms = sqrt((red_sens_rms*red_sens_rms+green_sens_rms*green_sens_rms+blue_sens_rms*blue_sens_rms)/3);
    
    
    %RMS with clippings
    rgb_err_mat = mod_light_mat'*sens_err_mat;
    k_const = 255/max(rgb_err_mat(:));
    light_err_mat = k_const*mod_light_mat; %determine scaling factor
    sens_err_mod_mat = pinv(light_err_mat')*rgb_err_mat;
    rgb_err_mod_mat = light_err_mat'*sens_err_mod_mat;
    red_err_mod_sense = sens_err_mod_mat(:,1);
    green_err_mod_sense = sens_err_mod_mat(:,2);
    blue_err_mod_sense = sens_err_mod_mat(:,3);
    
    red_clipped_sens_rms = computeRms(red_sens_actual,red_err_mod_sense',101);
    green_clipped_sens_rms = computeRms(green_sens_actual,green_err_mod_sense',101);
    blue_clipped_sens_rms = computeRms(blue_sens_actual,blue_err_mod_sense',101);
    
    overall_clipped_rms = sqrt((red_clipped_sens_rms*red_clipped_sens_rms+green_clipped_sens_rms*green_clipped_sens_rms+blue_clipped_sens_rms*blue_clipped_sens_rms)/3);
    
    overall_rms_mat = [overall_rms_mat;overall_sens_rms,overall_clipped_rms];
    
    if i==5 || i==10
        if i==5
         figure('Name','Plot of actual sensor values vs. estimated sensor values after noise of order 5*10(i=5) and clipping')
        else
                figure('Name','Plot of actual sensor values vs. estimated sensor values after noise of order 10*10(i=10) and clipping')
        end
        plot(wavelengths,red_sens_actual,'r',wavelengths,red_err_mod_sense,'r--');
        hold on;
        plot(wavelengths,green_sens_actual,'g',wavelengths,red_err_mod_sense ,'g--');
        hold on;
        plot(wavelengths,blue_sens_actual,'b',wavelengths,blue_err_mod_sense,'b--');
        axis([350 800 -0.5 2.5*(10.^4)])
        legend('Actual sensor(red)','Estimated sensor(red)','Actual sensor(green)','Estimated sensor(green)','Actual sensor(blue)','Estimated sensor(blue)');
    end
end

%Part B is in this function
partb(sens_mat)
end

function[rms] = computeRms(vector1,vector2,size)
vectordiff = vector1 - vector2;
sum=0;
for j=1:size
    sum=sum+vectordiff(j)*vectordiff(j);    
end
rms = sqrt(sum/size);
end



    




