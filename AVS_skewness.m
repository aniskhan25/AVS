function [ska,sa] = AVS_skewness(a)

a   = a(:);
ma  = mean(a);
sa  = std(a);
ska = mean((a-ma).^3) / sa^3;