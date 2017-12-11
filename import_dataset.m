clearvars dataset;
dataset.basepath = string('rpg_vfr_pinhole/');

%% Import Kf
fileID = fopen(dataset.basepath + string('info/intrinsics.txt'));
C = textscan(fileID,'%s', 'HeaderLines', 1, 'Delimiter', '\n');
fclose(fileID);
row1 = C{1}(1);
row1 = textscan(row1{:},'[[%f,%f,%f]');
row2 = C{1}(2);
row2 = textscan(row2{:},'[%f,%f,%f]');
row3 = C{1}(3); 
row3 = textscan(row3{:},'[%f,%f,%f]]');
dataset.Kf = [row1{1}(1) row1{2}(1) row1{3}(1) 
      row2{1}(1) row2{2}(1) row2{3}(1) 
      row3{1}(1) row3{2}(1) row3{3}(1)];
clearvars row1 row2 row3 C fileID

%% Import trajectory
fileID = fopen(dataset.basepath + string('info/groundtruth.txt'));
C = textscan(fileID, '%d %f %f %f %f %f %f %f');
fclose(fileID);
dataset.Positions = [C{2} C{3} C{4}];
% dataset : qx qy qz qw
% quat2rotm  w x y z
dataset.Quaternions = [ C{8} C{5} C{6} C{7}];
dataset.Rotations = quat2rotm(dataset.Quaternions);
dataset.NumberOfFrames = size(dataset.Positions,1);
dataset.TrajectoryTl = dataset.Positions(2:end,:) - dataset.Positions(1: (end-1),:);
for i = 2 : dataset.NumberOfFrames
    dataset.TrajectoryR(:,:,i-1) = dataset.Rotations(:,:,i) * dataset.Rotations(:,:,i-1).';
end
clearvars C fileID i selected ans

