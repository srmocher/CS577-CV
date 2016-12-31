function[] = partb(act_sensors)
fid = fopen('light_spectra.txt');
tline = fgetl(fid);
spectra=[];
while ischar(tline)
    values = strsplit(tline,' ');
    spectra = [spectra,str2double(values(:))];
    tline = fgetl(fid);
end
spectra = spectra';
fclose(fid);

fid = fopen('responses.txt');
tline = fgetl(fid);
col1=[],col2=[],col3=[];
while ischar(tline)
    tline = strtrim(tline);
    values = strsplit(tline,' ');
    disp(values)
    col1=[col1,str2double(values(1))];
    col2=[col2,str2double(values(2))];
    col3=[col3,str2double(values(2))];
    
    tline = fgetl(fid);
end
fclose(fid);

resp_mat = [col1;col2;col3];
resp_mat=resp_mat';
est_sens = pinv(spectra)*resp_mat;

red_sens_actual = act_sensors(1,:);
green_sens_actual = act_sensors(2,:);
blue_sens_actual = act_sensors(3,:);

red_est = est_sens(:,1);
green_est = est_sens(:,2);
blue_est = est_sens(:,3);
wavelengths = 380:4:780;
figure('Name','Plot of actual sensor values vs. estimated sensor values with real light energy spectra')
p1=plot(wavelengths,red_sens_actual,'r',wavelengths,red_est,'r--');
p1(2).LineWidth=1;
hold on;
p2=plot(wavelengths,green_sens_actual,'g',wavelengths,green_est,'g--');
p2(2).LineWidth=1;
hold on;
p3=plot(wavelengths,blue_sens_actual,'b',wavelengths,blue_est,'b--');
p3(2).LineWidth=1;
axis([350 800 0 2.5*(10.^5)]);
legend('Actual sensor(red)','Estimated sensor(red)','Actual sensor(green)','Estimated sensor(green)','Actual sensor(blue)','Estimated sensor(blue)');


red_diff = red_sens_actual'-red_est;
green_diff = green_sens_actual' - green_est;
blue_diff = blue_sens_actual' - blue_est;
red_sum =0;green_sum=0;blue_sum=0;

for i=1:101
    red_sum=red_sum+red_diff(i)*red_diff(i);
    green_sum=green_sum+green_diff(i)*green_diff(i);
    blue_sum = blue_sum+blue_diff(i)*blue_diff(i);
end
red_rms = sqrt((red_sum/101));
green_rms = sqrt((green_sum/101));
blue_rms = sqrt((blue_sum/101));

overall_rms = sqrt((red_rms*red_rms+green_rms*green_rms+blue_rms*blue_rms)/3);
rand_mat = rand(598,101);
disp(cond(spectra));
disp(cond(rand_mat));

%6th problem - define parameters for quadprog
H = spectra'*spectra;
f = -spectra' * resp_mat;
red_f = f(:,1);
green_f = f(:,2);
blue_f = f(:,3);

A = -eye(101);
b = -zeros(101,1);
red_sensor = quadprog(H,red_f,A,b);
green_sensor = quadprog(H,green_f,A,b);
blue_sensor = quadprog(H,blue_f,A,b);
figure('Name','Plot of actual sensor values vs. estimated sensor values with real light energy spectra')
p1=plot(wavelengths,red_sens_actual,'r',wavelengths,red_sensor,'r--');
p1(2).LineWidth=1.5;
hold on;
p2=plot(wavelengths,green_sens_actual,'g',wavelengths,green_sensor,'g--');
p2(2).LineWidth=1.5;
hold on;
p3=plot(wavelengths,blue_sens_actual,'b',wavelengths,blue_sensor,'b--');
p3(2).LineWidth=1.5;
axis([350 800 0 2.5*(10.^5)]);
legend('Actual sensor(red)','Estimated sensor(red)','Actual sensor(green)','Estimated sensor(green)','Actual sensor(blue)','Estimated sensor(blue)');

red_new_rms = computeRms(red_sens_actual,red_sensor',101);
green_new_rms = computeRms(green_sens_actual,green_sensor',101);
blue_new_rms = computeRms(blue_sens_actual,blue_sensor',101);

%problem 7
sens_positive_mat = [red_sensor,green_sensor,blue_sensor];
D = diff(sens_positive_mat);
differencing_mat=[];


end
function[rms] = computeRms(vector1,vector2,size)
vectordiff = vector1 - vector2;
sum=0;
for j=1:size
    sum=sum+vectordiff(j)*vectordiff(j);    
end
rms = sqrt(sum/size);
end
