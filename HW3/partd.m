function[] = partd(camera_matrix)

M=camera_matrix;
% Since the norm of camera matrix M is equal to 1, we can calculate the
% scale factor
scaling_const=sqrt(M(3,1)^2 + M(3,2)^2 + M(3,3)^2);
% Scale the Matrix with the scale factor - as actual norm of M will vary
M = M / scaling_const;

%Assuming the camera is in front
s = sign(M(3,4));
% Translation along the Z direction
T(3) = s*M(3,4);

% Create a 3x3 Rotation matrix and fill it with zeros
R = zeros(3,3);

% Last row of the rotation matrix is the same as the first
% three elements of the last row of the calibration matrix
R(3,:)=s*M(3,1:3);

% Matrix M can be written as:
% M=( m1'   )
%   ( m2' m4)
%   ( m3'   )
% We can now calculate mi, where mi is a 3 element vector
m1 = M(1,1:3)';
m2 = M(2,1:3)';
m3 = M(3,1:3)';
m4 = M(1:3,4);

% Now, we can calculate the centres of projection u0 and v0 which will be
% centre of image
u0 = m1'*m3;
v0 = m2'*m3;
% Calculating the focal length in X and Y directions,
alpha=sqrt( m1'*m1 - u0^2 );
beta=sqrt( m2'*m2 - v0^2 );
% We can now calculate the first and second rows of the rotation matrix
R(1,:) = s*(u0*M(3,1:3) - M(1,1:3) ) / alpha;
R(2,:) = s*(v0*M(3,1:3) - M(2,1:3) ) / beta;

% We can also calculate the first and second elements of the Translation
% vector
T(1) = s*(u0*M(3,4) - M(1,4) ) / alpha;
T(2) = s*(v0*M(3,4) - M(2,4) ) / beta;
T = T';
translationVector=T;

%The rotation matrix R obtained so far may not be guaranteed to be
%orthonormal so using SVD to recompute an accurate estimate

[U,D,V] = svd(R);
R = U*V';
rotationMatrix=R;
temp = [R,T];
temp = [temp;0,0,0,1];
projection_mat = [1,0,0,0;0,1,0,0;0,0,1,0];
K = [alpha,0,u0;0,beta,v0;0,0,1];
M_est = K*projection_mat*temp;

C= -R'*T;%equation to obtain camera postion
O = R'*[0;0;1];%equation to obtain camera orientation
end

