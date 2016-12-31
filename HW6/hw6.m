function [] = hw6()
close all;
untar('vlfeat-0.9.20-bin.tar.gz');
run('vlfeat-0.9.20/toolbox/vl_setup');
for i=1:3
    slide_image = imread(strcat('slide',int2str(i),'.pgm'));
    frame_image = imread(strcat('frame',int2str(i),'.pgm'));
    [slide_feature,slide_kp] = vl_sift(single(slide_image));
    [frame_feature,frame_kp] = vl_sift(single(frame_image));
    
     frame_image_color = imread(strcat('frame',int2str(i),'.jpg'));
    slide_image_color = imread(strcat('slide',int2str(i),'.tiff'));
    slide_img = [];
    if size(slide_image_color,3)==4
     slide_img = slide_image_color(:,:,1:3);
    else
        slide_img = slide_image_color;
    end
  
   % slide_kp = transpose(vl_sift(single(slide_image),'verbose','firstoctave',-1));
   % frame_kp = transpose(vl_sift(single(frame_image),'verbose','firstoctave',-1));
    N = ceil(0.20*size(slide_kp,2));
     draw_kp_matches(i,'euclid',slide_feature,frame_feature,N,slide_kp,frame_kp);
  draw_kp_matches(i,'angle',slide_feature,frame_feature,N,slide_kp,frame_kp);
% %     
% %     
% %     
%    %  draw_kp_matches_nnr(i,slide_feature,frame_feature,N,slide_kp,frame_kp);
%     
     draw_kp_matches_nnr(frame_image_color,slide_img,slide_feature,frame_feature,N,slide_kp,frame_kp,0.7);
end

for i=1:3
   for j=1:3
        slide_image = imread(strcat('slide',int2str(i),'.pgm'));
        frame_image = imread(strcat('frame',int2str(j),'.pgm'));
        
        
          [slide_feature,slide_kp] = vl_sift(single(slide_image));
    [frame_feature,frame_kp] = vl_sift(single(frame_image));
  
  
    
    frame_image_color = imread(strcat('frame',int2str(i),'.jpg'));
    slide_image_color = imread(strcat('slide',int2str(j),'.tiff'));
    slide_img = [];
    if size(slide_image_color,3)==4
     slide_img = slide_image_color(:,:,1:3);
    else
        slide_img = slide_image_color;
    end
    
    
  %   draw_kp_matches_nnr(frame_image_color,slide_img,slide_feature,frame_feature,N,slide_kp,frame_kp,0.7);
   end
end
  partb();
   partc();
   partd();
   parte();
end

function[angle] =computeAngle(u,v)
angle = acos(dot(single(u'), single(v')) / (norm(single(u)) * norm(single(v))));
end

function[] = draw_kp_matches(i,metric,slide_feature,frame_feature,N,slide_kp,frame_kp)
  slide_kp_rows = size(slide_kp,2);
    frame_kp_rows = size(frame_kp,2);
 dist = zeros(frame_kp_rows,slide_kp_rows);
 if strcmp(metric,'euclid')==1
    for k=1:frame_kp_rows
       for l=1:slide_kp_rows
           dist(k,l) = sqrt(sum((slide_kp(:,l)-frame_kp(:,k).^2)));
       end
    end
 elseif strcmp(metric,'angle')==1
     
      for k=1:frame_kp_rows
       for l=1:slide_kp_rows
           dist(k,l) = computeAngle(slide_kp(:,l),frame_kp(:,k));
       end
     end
 end
    
    min_frame_dist = zeros(frame_kp_rows,1);
    min_frame_slide_index = zeros(frame_kp_rows,1);
    for j=1:frame_kp_rows
       [minVal,index] = min(dist(j,:));
       min_frame_dist(j) = minVal;
       min_frame_slide_index(j)=index;
    end
    
    frame_image_color = imread(strcat('frame',int2str(i),'.jpg'));
   
   
   
    x=[];y=[];
    frame_points=[];slide_points=[];
   
    
    
    
    slide_image_color = imread(strcat('slide',int2str(i),'.tiff'));
    slide_img = [];
    if size(slide_image_color,3)==4
     slide_img = slide_image_color(:,:,1:3);
    else
        slide_img = slide_image_color;
    end
   
    
    
    
    
    

 figure;
      imshowpair(slide_img, frame_image_color, 'montage')
     hold on;
     
     
      for j=1:3:N     
       feature = frame_feature(:,j);
       x = feature(1);
    y = feature(2);
       u = feature(3) * cos(feature(4)); % convert polar (theta,r) to cartesian
       v = feature(3) * sin(feature(4));
       h=quiver(x,y,u,v);
        h.Color = 'red';
        h.LineWidth=6;
          x(1) = feature(1);
       y(1) = feature(2);
       x(2) = x(1) + 10*feature(3) * cos(feature(4));
        y(2) = y(1) + 10*feature(3) * sin(feature(4));
       
       plot(x, y,'Color','y','LineWidth',2);
        
     
      % set(gca, 'XLim', [1 10], 'YLim', [1 10]);
       
      end
    for j=1:3:N      
       
       min_index = min_frame_slide_index(j);
       feature = slide_feature(:,min_index);
       
        x = feature(1)+size(frame_image_color,2);
    y = feature(2);
       u = feature(3) * cos(feature(4)); % convert polar (theta,r) to cartesian
       v = feature(3) * sin(feature(4));
       h=quiver(x,y,u,v);
        h.Color = 'red';
        h.LineWidth=6;
        
       x(1) = feature(1);
       y(1) = feature(2);
       x(2) = x(1) + 10*feature(3) * cos(feature(4));
        y(2) = y(1) + 10*feature(3) * sin(feature(4));
       
       plot(x+size(frame_image_color,2), y,'Color','y','LineWidth',3);
     
      
    end
    hold off;
    
    figure;
    imshowpair(slide_img, frame_image_color, 'montage')
    hold on;
    for k=1:3:N
          min_index = min_frame_slide_index(k);
          feature_slide = slide_feature(:,min_index);
          feature_frame = frame_feature(:,k);
          p1 = [feature_slide(1);feature_slide(2)];
          p2 = [feature_frame(1)+size(frame_image_color,2);feature_frame(2)];
          h = line([p1(1) ; p2(1)], [p1(2) ; p2(2)]) ;
         
          set(h,'linewidth', 1, 'color', 'r') ;          
    end
    
    for k=1:3:N
          min_index = min_frame_slide_index(k);
          feature_slide = slide_feature(:,min_index);
          feature_frame = frame_feature(:,k);
          p1 = [feature_slide(1);feature_slide(2)];
          p2 = [feature_frame(1)+size(frame_image_color,2);feature_frame(2)];
          hold on;
          plot(p1(1),p1(2),'*');
          hold on;
          plot(p2(1),p2(2),'*');
    end
    
   hold off;
 
end