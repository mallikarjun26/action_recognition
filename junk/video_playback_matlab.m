% mov=VideoReader('/Users/mallikarjun/Documents/action_recognition/datasets/hmdb51/brush_hair/brushing_jrs_hair_brush_hair_u_cm_np2_le_goo_1.avi');
% mov=VideoReader('/Users/mallikarjun/Downloads/Sehwags 1st ODI Century - India vs New Zealand.mp4');
mov=VideoReader('/Users/mallikarjun/Downloads/output.mp4');
nFrames=mov.NumberOfFrames;
for i=1:nFrames
  videoFrame=read(mov,i);
  imshow(videoFrame);

end
