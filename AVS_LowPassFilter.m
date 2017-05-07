function H = AVS_MLowPassFilter(h,w)

ker_siz = 50; %25 1/0.039
offset = ker_siz/2;
mid_x = w/2; mid_y = h/2;

h = zeros(h,w);

f = fspecial('gaussian',ker_siz,ker_siz);

h(mid_y-offset:mid_y+offset-1,mid_x-offset:mid_x+offset-1) = f;

H = ifftshift(h); % put zero freq in upper left corner