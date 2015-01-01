function im = draw_pose(im, centers)
    centers = centers';
    set(gca, 'YDir', 'reverse');
    partcolor = {'c','c','r','r','r','b','b','b','g','g'};
    lwidth = 10;
    % Torso
    I = [1 2 6 5 1];
    im = draw_line(im, centers(1, I), centers(2, I), [1 1 0], lwidth);
    % Other joints
    I = strcmp(partcolor, 'g');
    im = draw_line(im, centers(1, I), centers(2, I), [0 1 0], lwidth);
    I = strcmp(partcolor, 'm');
    im = draw_line(im, centers(1, I), centers(2, I), [1 0 1], lwidth);    
    I = strcmp(partcolor, 'r');
    im = draw_line(im, centers(1, I), centers(2, I), [1 0 0], lwidth);
    I = strcmp(partcolor, 'c');
    im = draw_line(im, centers(1, I), centers(2, I), [0 1 1], lwidth);
    I = strcmp(partcolor, 'b');
    im = draw_line(im, centers(1, I), centers(2, I), [0 0 1], lwidth);
end

function im = draw_line(im, X, Y, c, w)
  for i = 2:length(X)
    im = draw_single_line(im, X(i-1), Y(i-1), X(i), Y(i), [0, 0, 0], 1.5 * w);
  end
  for i = 2:length(X)
    im = draw_single_line(im, X(i-1), Y(i-1), X(i), Y(i), 255*c, w);
  end
end

function im = draw_single_line(im, x1, y1, x2, y2, c, w)
    r = im(:,:,1);
    g = im(:,:,2);
    b = im(:,:,3);
    [x y] = bresenham(x1, y1, x2, y2);
    allx = x;
    ally = y;
    for j = 1:w/2
      [xa ya] = bresenham(x1 + j, y1, x2 + j, y2);
      [xb yb] = bresenham(x1 - j, y1, x2 - j, y2);
      [xc yc] = bresenham(x1, y1 + j, x2, y2 + j);
      [xd yd] = bresenham(x1, y1 - j, x2, y2 - j);
      allx = [allx; xa; xb; xc; xd];
      ally = [ally; ya; yb; yc; yd];
    end
    index = sub2ind(size(im),...
                    max(min(round(ally), size(im,1)), 1),...
                    max(min(round(allx), size(im,2)), 1));
    r(index) = c(1);
    g(index) = c(2);
    b(index) = c(3);
    im(:,:,1) = r;
    im(:,:,2) = g;
    im(:,:,3) = b;
end
