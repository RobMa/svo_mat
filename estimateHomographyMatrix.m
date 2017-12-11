function [ H, R, T, N ] = estimateHomographyMatrix( frame1_features, frame2_features, matchPairs, Kf )
%UNTITLED16 Summary of this function goes here
%   Detailed explanation goes here

datatype = whos('frame1_features');
if datatype.class == string('SURFPoints')
    frame1_features = frame1_features(:).Location;
    frame2_features = frame2_features(:).Location;
end

% transform into homogenous coordinates
frame1_features = [frame1_features ones(size(frame1_features,1),1) ];
frame2_features = [frame2_features ones(size(frame2_features,1),1) ];

% transform from pixel coordinates into image coordinates
frame1_features = (Kf \ frame1_features.').';
frame2_features = (Kf \ frame2_features.').';

NUMBER_OF_MATCHES = size(matchPairs,1);
X = zeros(3*NUMBER_OF_MATCHES, 9);

for i = 1 : NUMBER_OF_MATCHES
    a = kron(frame1_features(matchPairs(i,1),:).',...
        skew(frame2_features(matchPairs(i,2),:).'));
    X( 1+(i-1)*3 : i*3, :) = a.';
end
% solve the optimization problem: min ||Xh=0||^2 <=> h is the right side singular vector
% corresponding to the smallest singular value of X^T*X.
[~,~,V] = svd(X);
fprintf('SVD residual %f\n', norm(X*V(:,9)));
% undo the stacking and yield a 3x3 matrix.
H_L = [V(1:3,9) V(4:6,9) V(7:9,9)];
% Correct the scale of H by dividing through second signular value
[~,S,~] = svd(H_L);
H = H_L / S(2,2);
% Determine the correct sign of H by using positive depth constraint.
X1 = frame1_features(matchPairs(:,1),:);
X2 = frame2_features(matchPairs(:,2),:);
l = X2 * H * X1.';
l = diag(l);
l(l>=0) = 1;
l(l<0) = -1;
sgn = sum(l);
fprintf('%.2f%% of features match in positive depth test.\n', 100 * abs(sgn) / NUMBER_OF_MATCHES);
if sgn ~= 0
    H = sign(sgn) * H;
else
    fprintf('Warning: ambiguity in +- H, positive depth test failed.\n');
    H = -H; %TODO implement code to handle this case.
end

H_repr_err = 0;
for i = 1 : NUMBER_OF_MATCHES
    x2_repr = H * X1(i,:).'; x2_repr = x2_repr / x2_repr(3);
    H_repr_err = H_repr_err + norm(X2(i,:).'-x2_repr);
end
fprintf('H reprojection error %f\n', H_repr_err);

[Ra,Ta,Rb,Tb,Na,Nb] = decomposeHomographyMatrix(H,X1,X2)
[R,T,N] = selectBestHomographyDecomposition(Ra, Ta, Na, Rb, Tb, Nb, X1, X2);
