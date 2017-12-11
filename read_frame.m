function [ I ] = read_frame( dataset, number )
% first frame is number 1.
assert(number > 0 && number <= dataset.NumberOfFrames);    
fileID = fopen(dataset.basepath + 'info/images.txt');
C = textscan(fileID,'%d %f %s', 'HeaderLines', number-1);
path = C{3}(1);
path = dataset.basepath + 'data/' + path;
I = double(imread(path{:}))/255;
I = rgb2gray(I);
end

