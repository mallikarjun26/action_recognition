%% Test frames

% Define data path
datasetpath = fullfile(mfilename('fullpath'), '..', '..');
frameid = 10192;
frame = sprintf('%08d.jpg', frameid);
leftpath = fullfile(datasetpath, 'persondetection_test', 'frames', frame);
rightpath = fullfile(datasetpath, 'persondetection_test', 'frames', [frame '.right']);
disppath = fullfile(datasetpath, 'persondetection_test', 'disparity', [frame '_disparity.mat']);
gtpath = fullfile(datasetpath, 'persondetection_test', 'labels', 'gt_person.txt');

% Load data
left = imread(leftpath);
right = imread(rightpath);
disparity = load(disppath, 'uv');
disparity = disparity.uv(:,:,1);
gt = load(gtpath);

% Prepare ground truth visualization
gt_im = im2double(left);
for i = 1:size(gt, 1)
    if gt(i,1) == frameid
        gt_im = draw_rectangle_on_image(gt_im, gt(i,3), gt(i,4), gt(i,5), gt(i,6), [0, 0.99, 0]);
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

%% Training frames

% Define data path
datasetpath = fullfile(mfilename('fullpath'), '..', '..');
frameid = 56382;
frame = sprintf('%08d.jpg', frameid);
leftpath = fullfile(datasetpath, 'persondetection_train', 'frames', frame);
rightpath = fullfile(datasetpath, 'persondetection_train', 'frames', [frame '.right']);
disppath = fullfile(datasetpath, 'persondetection_train', 'disparity', [frame '_disparity.mat']);
gtpath = fullfile(datasetpath, 'persondetection_train', 'labels', 'boundingboxes.mat');

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
        gt_im = draw_rectangle_on_image(gt_im, gt(i).x1, gt(i).y1, gt(i).x2, gt(i).y2, [0, 0.99, 0]);
    end
end

% Display data
figure(2);
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