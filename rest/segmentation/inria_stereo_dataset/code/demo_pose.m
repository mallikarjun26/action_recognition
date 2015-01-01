% Define data path
datasetpath = fullfile(mfilename('fullpath'), '..', '..');
frameid = 26449;
frame = sprintf('%08d.jpg', frameid);
leftpath = fullfile(datasetpath, 'poseestimation_test', 'frames', frame);
rightpath = fullfile(datasetpath, 'poseestimation_test', 'frames', [frame '.right']);
disppath = fullfile(datasetpath, 'poseestimation_test', 'disparity', [frame '_disparity.mat']);
gtpath = fullfile(datasetpath, 'poseestimation_test', 'labels', 'poses.mat');

% Load data
left = imread(leftpath);
right = imread(rightpath);
disparity = load(disppath, 'uv');
disparity = disparity.uv(:,:,1);
gt = load(gtpath, 'pos');
gt = gt.pos;

% Prepare ground truth visualization
gt_im = im2double(left);
for i = 1:numel(gt)
    if strcmp(gt(i).im, frame)
        gt_im = draw_pose(gt_im, gt(i).pose);
    end
end

% Display data
figure(1);
clf;
subplot(2, 2, 1);
imshow(left);
title('Left image');
subplot(2, 2, 2);
imshow(right);
title('Right image');
subplot(2, 2, 3);
imagesc(disparity);
axis image off;
title('Disparity');
subplot(2, 2, 4);
imshow(gt_im);
title('Ground truth');