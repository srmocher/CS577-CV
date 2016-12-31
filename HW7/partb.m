function[] = partb()
for i=1:3
    slide_image = imread(strcat('slide',int2str(i),'.tiff'));
    frame_image = imread(strcat('frame',int2str(i),'.jpg'));
    if size(slide_image,3)>3
       slide_image = slide_image(:,:,1:3); 
    end
    
%     imshowpair(slide_image,frame_image,'montage');
%     [slide_x,slide_y] = ginput(8)
%     
%      
%      [frame_x,frame_y] = ginput(8)
% 
%      hold on;
%      plot(slide_x,slide_y,'*r');
%      plot(frame_x,frame_y,'*y');
compute_homography(i,slide_image,frame_image,'LS');
compute_homography(i,slide_image,frame_image,'DLT');

end
end

function[] = compute_homography(i,slide_image,frame_image,method)
fid = fopen(strcat('slide',int2str(i),'.txt'));
        slide_points=[];
        line = fgetl(fid);
        while ischar(line)
           vals = strsplit(line)
           slide_points = [slide_points;str2double(vals(1)),str2double(vals(2))];
           line = fgetl(fid);
        end
        
        fid = fopen(strcat('frame',int2str(i),'.txt'));
        frame_points=[];
        line = fgetl(fid);
        while ischar(line)
           vals = strsplit(line)
           frame_points = [frame_points;str2double(vals(1)),str2double(vals(2))];
           line = fgetl(fid);
        end
        slide_subset = slide_points(1:4,:); %Take 4 points
        frame_subset = frame_points(1:4,:); %Take 4 points
        
        A=[];
        for j=1:4
            slide_p = slide_subset(j,:);
            frame_p = frame_subset(j,:);
            val1 = [slide_p(1) slide_p(2) 1 0 0 0 -slide_p(1)*frame_p(1) -slide_p(2)*frame_p(1) -frame_p(1)];
            val2 = [0 0 0 slide_p(1) slide_p(2) 1 -slide_p(1)*frame_p(2) -slide_p(2)*frame_p(2) -frame_p(2)];
            A =[A;val1];
            A = [A;val2]; %form 2nx9 matrix
        end
        if strcmp(method,'LS')
           [E,V] = eig(A'*A); %Least square solution
           H = E(:,1);
        else
            [U,S,V] = svd(A);%DLT method
            H = V(:,9);
        end
        H = reshape(H,3,3);
        fclose(fid);
        
        actual_frame_points = zeros(8,2);
        for j=1:8
           slide_p = slide_points(j,:);
           X = [slide_p(1);slide_p(2);1];
           F = H'*X;
           F = (F./F(3));%compute estimated points
           actual_frame_points(j,:) = [F(1) F(2)];
        end
        figure;
        imshowpair(slide_image,frame_image,'montage');
        hold on;
        plot(slide_points(:,1),slide_points(:,2),'*r');
        hold on;
       
        plot(frame_points(:,1),frame_points(:,2),'dr');
         plot(actual_frame_points(:,1),actual_frame_points(:,2),'oy');
end