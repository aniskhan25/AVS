function gaussFiltered = gaussFilter1D(m, sigma)
  cutoff = ceil(3*sigma);
  
  h = fspecial('gaussian',[1,2*cutoff+1],sigma); % 1D filter
  gaussFiltered = conv2(h,h,m,'same');