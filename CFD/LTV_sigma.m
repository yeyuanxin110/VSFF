function [LTV_f] = LTV_sigma(img, sigma)                     
 
img = double(img);
[m,n] = size(img);
img_x = zeros(m,n);
img_y = zeros(m,n);

for i = 1 : m-1
    for j = 1 : n-1
        img_x(i,j) = img(i+1,j) - img(i,j);
        img_y(i,j) = img(i,j+1) - img(i,j);
    end
end

delta_img = sqrt(img_x.^2 + img_y.^2);

LTV_f = wiener2(delta_img,[sigma sigma]);

end