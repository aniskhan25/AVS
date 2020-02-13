% code based on paper: 
% O. Stretcu and M. Leordeanu, Multiple Frames Matching for Object Discovery In Video, BMVC 2015

function seg  = getSeg(BW, Ihsv)

% compute foreground soft-segmentation
%   
% [in] BW           - binary mask for foreground-background separation
% [in] Ihsv         - HSV frames 
% 
% [out] seg         - foreground soft-segmentation

[nRows, nCols, ~] = size(Ihsv);

f_fg = find(BW);
f_bg = find(BW==0);

clear BW

%get color histograms of background vs foreground -------------------------
dimH = 100;
dimS = 25;  
dimV = 10; 

%forground histogram
h = Ihsv(:,:,1);
s = Ihsv(:,:,2);
v = Ihsv(:,:,3);

h = h(f_fg);
s = s(f_fg);
v = v(f_fg);

%transform into euclidean coordinates

hx = (s.*cos(h*2*pi)+1)/2;
hy = (s.*sin(h*2*pi)+1)/2;

h = hx;
s = hy;

h = round(h*(dimH-1)+1);
v = round(v*(dimV-1)+1);
s = round(s*(dimS-1)+1);

col_fg = h + (s-1)*dimH + (v-1)*dimH*dimS;
clear h s v hx hy

histCol_fg = col_fg;
histCol_fg = hist(histCol_fg, 1:(dimH*dimS*dimV));
histCol_fg = histCol_fg/(sum(histCol_fg) +eps);

%background histogram------------------------------------------------------

h = Ihsv(:,:,1);
s = Ihsv(:,:,2);
v = Ihsv(:,:,3);

h = h(f_bg);
s = s(f_bg);
v = v(f_bg);

%transform into euclidean coordinates

hx = (s.*cos(h*2*pi)+1)/2;
hy = (s.*sin(h*2*pi)+1)/2;

h = hx;
s = hy;

%--------------------------------------


h = round(h*(dimH-1)+1);
v = round(v*(dimV-1)+1);
s = round(s*(dimS-1)+1);

col_bg = h + (s-1)*dimH + (v-1)*dimH*dimS;
clear h s v hx hy

histCol_bg = col_bg;

histCol_bg = hist(histCol_bg, 1:(dimH*dimS*dimV)) + 1;

histCol_bg = histCol_bg/(sum(histCol_bg)+eps);

%-------------------------------------------------------------------------

clear Ihsv

seg = zeros(nRows, nCols);

seg(f_fg) = histCol_fg(col_fg)./(histCol_fg(col_fg) + histCol_bg(col_fg));
clear col_fg f_fg
seg(f_bg) = histCol_fg(col_bg)./(histCol_fg(col_bg) + histCol_bg(col_bg));
clear col_bg f_bg







