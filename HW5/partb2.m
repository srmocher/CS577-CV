function [] = partb2()

num = 5;
images = readImages();
image = imread('lorem_ipsum.tiff');
[H,W] = size(image);
figure;
imshow(image);

for i=1:num
    template_image = rgb2gray(images{i});
    [h,w] = size(template_image);
    
    corr_matrix = zeros(H,W);
    
    for j=1:H-h
        for k=1:W-w            
                sub_image = double(image(j:(j+h-1),k:(k+w-1)));
                if mean(sub_image(:)) == sub_image(1,1)
                    for s=1:h
                        for t=1:w
                            if mod(t,2)==0
                                sub_image(s,t) = (-1)*sub_image(s,t);
                            end
                        end
                    end
                end
                result = corr2(template_image,sub_image);
                if isnan(result)
                   result=0; 
                end
                corr_matrix(j,k)=result;
            end
        end
       % max_corr = max(abs(corr_matrix(:)));
        [maxCorrValue, maxIndex] = max(abs(corr_matrix(:)));
    [yPeak, xPeak] = ind2sub(size(corr_matrix),maxIndex(1));
        rectangle('Position',[xPeak yPeak h w],'edgecolor','r');
    end
   
    
end

% for k=1:num
%    template = rgb2gray(images{k});
%    [h,w] = size(template);
%    correlationOutput = normxcorr2(template,image);
%   [maxCorrValue, maxIndex] = max(abs(correlationOutput(:)));
% [yPeak, xPeak] = ind2sub(size(correlationOutput),maxIndex(1))
% % Because cross correlation increases the size of the image, 
% % we need to shift back to find out where it would be in the original image.
% corr_offset = [(xPeak-size(template,2)) (yPeak-size(template,1))]
% 
% figure;
% imshow(image);
% 
% hold on; % Don't allow rectangle to blow away image.
% % Calculate the rectangle for the template box.  Rect = [xLeft, yTop, widthInColumns, heightInRows]
% boxRect = [corr_offset(1) corr_offset(2) h, w]
% % Plot the box over the image.
% rectangle('position', boxRect, 'edgecolor', 'r', 'linewidth',0.5);
% % Give a caption above the image.
% title('Template Image Found in Original Image', 'FontSize', 10);
%   
% end






function[images] = readImages()

img_S = imread('S.tiff');
img_S(:,:,4)=[];
img_P = imread('P.tiff');
img_P(:,:,4)=[];
img_M = imread('M.tiff');
img_M(:,:,4)=[];
img_F = imread('F.tiff');
img_F(:,:,4)=[];
img_C = imread('C.tiff');
img_C(:,:,4)=[];
imgs = {img_S;img_P;img_M;img_F;img_C};
images = imgs;
end