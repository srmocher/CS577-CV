function[num_questions] = hw1(infile)
% hw1 Returns the number of questions done in homework 1
% Solutions for reading and manipulating images, matrices, solving linear
% equations and PCA. Problems 6 is related to documenting functions.
% Problem 7 deals with reading data from an image and computing RGB and
% grayscale version of it. 8 and 9 deal with visualizing matrices and
% manipulating images by changing pixel values. 10 and 11 deal with
% histograms and plotting curves. 12, 13 and 14 deal with solving linear
% equations using matrices. 15 deals with using colon notation for
% manipulating matrices. 16 and 17 deals with PCA.

close all;
num_questions = 1;
%question 7 -read image, find min, max values of R,G,B and convert to
%grayscale
image = imread(infile);
whos('image')
[num_rows,num_cols,num_channels]=size(image);
matrixRed = image(:,:,1);
matrixGreen = image(:,:,2);
matrixBlue = image(:,:,3);

minRed = min(matrixRed(:))
minGreen  = min(matrixGreen(:))
minBlue = min(matrixBlue(:))

minOverall = min(image(:))

maxRed = max(matrixRed(:))
maxGreen = max(matrixGreen(:))
maxBlue = max((matrixBlue(:)))

maxOverall = max(image(:))

grayscale = rgb2gray(image);
figure('Name','Grayscale image')
imshow(grayscale)

size(grayscale)

figure('Name','Grayscale with only red pixels')
imshow(matrixRed)
figure('Name','Grayscale with only green pixels')
imshow(matrixGreen)
figure('Name','Grayscale with only blue pixels')
imshow(matrixBlue)

newImage = cat(3,matrixGreen,matrixBlue,matrixRed);
figure('Name','Color image with channels interchanged')
imshow(newImage)
num_questions=num_questions+1;

%question 8 - 
precisionImage = (double(grayscale))./255;
tempImage = precisionImage;
figure('Name','Image with double precision and scaled values')
imagesc(precisionImage)
figure('Name','Grayscale image with colorbar')
imagesc(precisionImage)
colorbar
figure('Name','Grayscale image with gray colormap')
colormap(gray)
imagesc(precisionImage)
figure('Name','Grayscale image with distortion removed')
axis auto
imagesc(precisionImage)
colormap(gray)
figure('Name','Grayscale image using imshow')
imshow(precisionImage)
%to deal with distortion

num_questions = num_questions+1;

%question 9 - set every fifth pixel to 1
for i= 1:num_rows
    for j=1:num_cols
        if(mod(i,5)==0 || mod(j,5)==0)
            precisionImage(i,j)=1;
        end
    end   
end
figure('Name','Setting every 5th pixel to 1 and showing it using imagesc');
imagesc(precisionImage);
figure('Name','Setting every 5th pixel to 1 and showint it using imshow');
imshow(precisionImage);
num_questions = num_questions+1;
%9th ends here

%question 10 - display histograms
vectorRed = matrixRed(:);
figure('Name','Histogram with red values')
histogram(vectorRed,20)

vectorGreen = matrixGreen(:);
figure('Name','Histogram with green values')
histogram(vectorGreen,20)

vectorBlue = matrixBlue(:);
figure('Name','Histogram with blue values')
histogram(vectorBlue,20);

num_questions = num_questions + 1;

%question 11 - display sine and cosine curves
x = linspace(-pi,pi,100);
figure('Name', 'Sine and Cosine curves from -PI to PI')
plot(x,sin(x));
hold on;
plot(x,cos(x),'r');

num_questions  = num_questions + 1;
%11th ends above

%12th - solve linear equations
A=[3,4,1;2,-1,2;1,1,-1];
B=[9;8;0];
L = inv(A)*B
M = linsolve(A,B)
%diff is not 0 as while calculating L, accuracy is lost
diff = L-M

num_questions = num_questions + 1;

%13th - use moore primrose method
U=[3,4,1;3.1,2.9,0.9;2.0,-1.0,2.0;2.1,-1.1,2.0;1.0,1.0,-1.0;1.1,1.0,-0.9];
y=[9;9;8;8;0;0];
x = pinv(U)*y %solution
error = U*x - y %error vector
num_questions = num_questions + 1;

%14th
R = rand(4,4)  %# A matrix of random values between 0 and 1
result = R*R';
diff = result - result';
[V,EVals] = eig(R);
res = R*V;
num_questions = num_questions+1;

%15th
rangeX = 5:5:num_rows;
rangeY = 5:5:num_cols;
tempImage(rangeX,rangeY)=0;
figure('Name','Image created by setting every 5th pixel to 0 using colon notation')
imshow(tempImage)
[row,col] = find(tempImage>0.5);
tempImage(row,col) = 0;
figure('Name','Image created by setting every pixel which has value > 0.5 to 0')
imshow(tempImage);
num_questions = num_questions + 1;

%16th
pcaFile = fopen('pca.txt');
tline = fgetl(pcaFile);
x=[];
y=[];
while ischar(tline)
  line = strsplit(tline);
  x=[x,str2double(line(2))];
  y=[y,str2double(line(3))];
  tline = fgetl(pcaFile);    
end
fclose(pcaFile);

figure('Name','PCA plot');
plot(x',y');
covariance = cov(x',y');

xmean = mean(x);
ymean = mean(y);

figure('Name','PCA plot with X and Y axis shifted');
x_shifted=x+xmean;
y_shifted=y+ymean;
plot(x_shifted',y_shifted');
num_questions = num_questions + 1;

%17th

%Zero center data, find the covariance and the eigen vector for it
x_zero = (x - mean(x))/std(x);
y_zero = (y - mean(y))/std(y);
matrix = [x_zero',y_zero'];
covar_matrix = cov(matrix);
[W,EValuesMatrix] = eig(covar_matrix);

%W'=inv(W) which proves it is orthogonal.W is the eigen vector
diff = W' - inv(W);
EValuesMatrix = EValuesMatrix(end:-1:1);
W = W(:,end:-1:1);W=W'
pc = W*matrix';%multiply to obtain principal components
pc=pc';
figure('Name','Plot of transformed data');
plot(pc(:,2),pc(:,1))
axis([-1 1 -1 1]);%plot with same axes for X and Y from -1 to 1
cov(pc);
num_questions = num_questions + 1; %increment num_questions for each question completed.









