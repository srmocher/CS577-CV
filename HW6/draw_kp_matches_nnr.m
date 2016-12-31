function[] = draw_kp_matches_nnr(frame_image_color,slide_img,slide_feature,frame_feature,N,slide_kp,frame_kp,threshold)
 slide_kp_rows = size(slide_kp,2);
    frame_kp_rows = size(frame_kp,2);
    dist = zeros(frame_kp_rows,slide_kp_rows);
 
   
    for k=1:frame_kp_rows
       for l=1:slide_kp_rows
           dist(k,l) = sqrt(sum((slide_kp(:,l)-frame_kp(:,k).^2)));
       end
    end
    
      min_frame_dist = zeros(frame_kp_rows,1);
      second_min_frame_dist = zeros(frame_kp_rows,1);
    min_frame_slide_index = zeros(frame_kp_rows,1);
    second_min_frame_slide_index = zeros(frame_kp_rows,1);
    for j=1:frame_kp_rows
       [minVal,index] = min(dist(j,:));
         min_frame_dist(j) = minVal;
       min_frame_slide_index(j)=index;
       if index>1 && index < slide_kp_rows
           [temp1,index1] = min(dist(j,1:index-1));
           [temp2,index2] = min(dist(j,index+1:end));
       elseif index==1
          [second_min,index3] = min(dist(j,2:end));
          second_min_frame_dist(j) = second_min;
           second_min_frame_slide_index(j) = index3;
           continue;
       elseif index==slide_kp_rows
            [second_min,index4] = min(dist(j,1:end-1));
          second_min_frame_dist(j) = second_min;
           second_min_frame_slide_index(j) = index4;
           continue;
       end
       if temp1<temp2
            second_min_frame_dist(j) = temp1;
            second_min_frame_slide_index(j) = index1;
       else
           second_min_frame_dist(j) = temp2;
           second_min_frame_slide_index(j) = index2;
       end
     
    end
    
   for j=1:frame_kp_rows
       ratio = min_frame_dist(j)/second_min_frame_dist(j);
       if ratio < threshold
           min_frame_dist(j)=-1;
           second_min_frame_dist(j)=-1;
       end
   end
   
     figure;
    imshowpair(slide_img, frame_image_color, 'montage')
    hold on;
    for j=1:3:N 
        if min_frame_dist(j)~=-1
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
        
        end
      % set(gca, 'XLim', [1 10], 'YLim', [1 10]);
       
      end
    for j=1:3:N       
       if min_frame_dist(j)~=-1
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
      
    end
    
   hold off;
   
   
    
    figure;
    imshowpair(slide_img, frame_image_color, 'montage')
    hold on;
    for k=1:3:N
        if min_frame_dist(k)~=-1
          min_index = min_frame_slide_index(k);
          feature_slide = slide_feature(:,min_index);
          feature_frame = frame_feature(:,k);
          p1 = [feature_slide(1);feature_slide(2)];
          p2 = [feature_frame(1)+size(frame_image_color,2);feature_frame(2)];
          h = line([p1(1) ; p2(1)], [p1(2) ; p2(2)]) ;
         
          set(h,'linewidth', 1, 'color', 'r') ;    
        end
    end
    
    for k=1:3:N
        if min_frame_dist(k)~=-1
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
    end
    hold off;
   
end