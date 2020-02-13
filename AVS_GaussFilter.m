function imG = AVS_GaussFilter(im,c)

im = double(im);
% if ndims(im)==3,
%    im = mean(im,3);
% end

fg = fspecial('gaussian',50,50); %25 1/0.039
imG = im;
for ic=1:c,
    imG = imfilter(imG,fg,'same');
end
