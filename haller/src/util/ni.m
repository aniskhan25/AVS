function I = ni(I)
    
% normalize values in matrix to range [0, 1]
% 
% [in] I        - initial matrix
%
% [out] I       - normalized matrix
   
    I = single(I);

    I = I - min(I(:));

    I = I./(max(I(:))+eps);

end