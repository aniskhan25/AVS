function g = AVS_MGaussFilterFreq(f,H,c)

F = fft2(f);

G = F;
for ic=1:c,
    G = G .* H;
end
g = abs(real(ifft2(G)));