% Define data path
datasetpath = fullfile(mfilename('fullpath'), '..', '..');
seq = '5';
frame = '00009243.jpg';
leftpath = fullfile(datasetpath, 'segmentation', 'frames', seq, frame);
rightpath = fullfile(datasetpath, 'segmentation', 'frames', seq, [frame '.right']);
disppath = fullfile(datasetpath, 'segmentation', 'disparity', seq, [frame '_disparity.mat']);
gtpath = fullfile(datasetpath, 'segmentation', 'labels', seq, [frame '_gt1.mat']);

% Load data
left = imread(leftpath);
right = imread(rightpath);
disparity = load(disppath, 'uv');
disparity = disparity.uv(:,:,1);
gt = load(gtpath, 'det_gt');
gt = gt.det_gt;

% Prepare ground truth visualization
gt_im = im2double(left);
cmap = colormap;
rand('seed', 1); % Randomize colors, but not too much
I = randperm(size(gt, 3));
for i = 1:size(gt, 3)
    color = cmap(fix(i/size(gt, 3)*size(colormap, 1)),:);
    for j = 1:3
        gt_im(:,:,j) = gt_im(:,:,j) + 0.5 * color(j) * double(gt(:,:,I(i))) / 255;
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
