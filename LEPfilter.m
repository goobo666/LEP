function o = LEPfilter(I,r)

%   - input image: I (should be a gray-scale/single channel image)
%   - local window radius: r
%   - filtered output image: o

[h, w] = size(I);
N = boxfilter(ones(h, w), r); % the size of each local window; N=(2r+1)^2 except for boundary pixels.

mean_I = boxfilter(I, r) ./ N;
% mean_p = boxfilter(p, r) ./ N;
% mean_Ip = boxfilter(I.*p, r) ./ N;
% cov_Ip = mean_Ip - mean_I .* mean_p; % this is the covariance of (I, p) in each local patch.

mean_II = boxfilter(I.*I, r) ./ N;
var_I = mean_II - mean_I .* mean_I;

dx = diff(I,1,2);dy = diff(I,1,1); 
gr = 0.1.*(((dx(1:h-1,1:w-1)).^2+(dy(1:h-1,1:w-1)).^2).^0.5);
gr = padarray(gr,[1 1],'post');
mean_g = boxfilter(gr,r)./N;

a = var_I ./ (var_I + mean_g+eps);
b = mean_I - a .* mean_I; 

mean_a = boxfilter(a, r) ./ N;
mean_b = boxfilter(b, r) ./ N;

o = mean_a .* I + mean_b; 
end