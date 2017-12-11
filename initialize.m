%% This script takes the first and second frame and computes the homography.
clear all;
import_dataset;

%% Extract features of first frame
frame1 = read_frame(dataset, 1);
padding = 0;
region_of_interest = [padding+1,padding+1, size(frame1,2)-padding*2, size(frame1,1) - padding*2];
frame1_detected_features = detectSURFFeatures(frame1, 'NumOctaves', 3, 'ROI', region_of_interest);
[frame1_features_descriptor,frame1_features] = extractFeatures(frame1,frame1_detected_features);

%% Extract features of second frame
frame2 = read_frame(dataset, 2);
frame2_detected_features = detectSURFFeatures(frame2, 'NumOctaves', 3, 'ROI', region_of_interest);
[frame2_features_descriptor,frame2_features] = extractFeatures(frame2,frame2_detected_features);

%% Match features
matchPairs = matchFeatures(frame1_features_descriptor, frame2_features_descriptor, 'Unique', true, 'MaxRatio', 0.3);
frame1_matched = frame1_features(matchPairs(:,1));
frame2_matched = frame2_features(matchPairs(:,2));
figure; showMatchedFeatures(frame1,frame2,frame1_matched(1:10),frame2_matched(1:10), 'montage');

%% Estimate Homography Matrix
[H_est, R_est, T_est, N_est] = estimateHomographyMatrix(frame1_features,frame2_features,matchPairs,dataset.Kf)
T_est0 = ( dataset.Rotations(:,:,1) * R_est.' * -T_est ).'
( dataset.TrajectoryTl(1,:).').'
