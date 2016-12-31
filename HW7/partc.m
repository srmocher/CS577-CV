function[] = partc()
untar('vlfeat-0.9.19-bin.tar.gz');
run('vlfeat-0.9.19/toolbox/vl_setup');
for i=1:3
   slide_img = imread(strcat('slide',int2str(i),'.pgm'));
   frame_img = imread(strcat('frame',int2str(i),'.pgm'));
   [slide_feat,slide_kp] = vl_sift(single(slide_img));
   [frame_feat,frame_kp] = vl_sift(single(frame_img));
   
   N=ceil(0.15*size(slide_kp,2));
   
   K=20;
  % [slide_pts,frame_pts]=ransac(slide_feat,frame_feat,N,K);
   slide_clr_img = imread(strcat('slide',int2str(i),'.tiff'));
   frame_clr_img = imread(strcat('frame',int2str(i),'.jpg'));
   if size(slide_clr_img,3)>3
      slide_clr_img = slide_clr_img(:,:,1:3); 
   end
   ransac_homography_matches(slide_img, frame_img,N,slide_clr_img,frame_clr_img,K,'LS');
   ransac_homography_matches(slide_img, frame_img,N,slide_clr_img,frame_clr_img,K,'DLT');
 %  figure;
%    imshowpair(slide_clr_img,frame_clr_img,'montage');
%     
%     for k=1:size(slide_pts,2)
%           
%           feature_slide = slide_pts(:,k);
%           feature_frame = frame_pts(:,k);
%           p1 = [feature_slide(1);feature_slide(2)];
%           p2 = [feature_frame(1)+size(frame_clr_img,2);feature_frame(2)];
%           h = line([p1(1) ; p2(1)], [p1(2) ; p2(2)]) ;
%          
%           set(h,'linewidth', 1, 'color', 'r') ;          
%     end
%     
%     for k=1:size(slide_pts,1)
%           feature_slide = slide_pts(:,k);
%           feature_frame = frame_pts(:,k);
%           p1 = [feature_slide(1);feature_slide(2)];
%           p2 = [feature_frame(1)+size(frame_clr_img,2);feature_frame(2)];
%           hold on;
%           plot(p1(1),p1(2),'*');
%           hold on;
%           plot(p2(1),p2(2),'*');
%     end
end
end



function [] = ransac_homography_matches(im1, im2,N,im1_clr,im2_clr,K,method)

im1 = im2single(im1) ;
im2 = im2single(im2) ;


if size(im1,3) > 1, im1g = rgb2gray(im1) ; else im1g = im1 ; end
if size(im2,3) > 1, im2g = rgb2gray(im2) ; else im2g = im2 ; end


[f1,d1] = vl_sift(im1g) ;
[f2,d2] = vl_sift(im2g) ;

[matches, scores] = vl_ubcmatch(d1,d2) ; %compute matches using Lowe's algorithm

numMatches = size(matches,2); ;

X1 = f1(1:2,matches(1,:)) ; X1(3,:) = 1 ;  %slide keypoints
X2 = f2(1:2,matches(2,:)) ; X2(3,:) = 1 ; %frame keypoints


clear H score ok ;
for t = 1:100
  % estimate homography
  subset = vl_colsubset(1:numMatches, 4) ; %take 4 keypoints for computing homography
  A = [] ;
  for i = subset
    A = cat(1, A, kron(X1(:,i)', vl_hat(X2(:,i)))) ;
  end
  if strcmp(method,'DLT')
      [U,S,V] = svd(A) ;
      H{t} = reshape(V(:,9),3,3) ;
  else
      [E,V] =eig(A'*A);
      H{t} = reshape(E(:,1),3,3);      
  end

  % compute estimated frame points
  X2_ = H{t} * X1 ;
  dx = X2_(1,:)./X2_(3,:) - X2(1,:)./X2(3,:) ;%diff in estimate and actual
  dy = X2_(2,:)./X2_(3,:) - X2(2,:)./X2(3,:) ;%diff in estimate and actual
  ok{t} = (dx.*dx + dy.*dy) < 49 ; %squared error, add to inlier if less than 49
  score(t) = sum(ok{t}) ;
end

[score, best] = max(score) ;
H = H{best} ;
ok = ok{best} ;

figure ;


imshowpair(im1_clr,im2_clr,'montage');
o = size(im1_clr,2) ;
line([f1(1,matches(1,ok));f2(1,matches(2,ok))+o], ...
     [f1(2,matches(1,ok));f2(2,matches(2,ok))],'Color','r') ;
end
 
