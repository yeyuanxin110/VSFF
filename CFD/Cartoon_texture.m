
%% ======================================================================
% brief   Cartoon + texture decomposition for a single channel image
%% ======================================================================

function [u,v] = Cartoon_texture(img, sigma)

img = double(img);

% Low-pass filter image
LTV_sigma_f = wiener2(img,[sigma sigma]);
LTV_sigma_f = double(LTV_sigma_f);

% Local total variation
result_1 = LTV_sigma(img, sigma);
result_2 = LTV_sigma(LTV_sigma_f, sigma);

% Relative reduction rate
lamda = (result_1 - result_2) ./ result_1;
lamda = double(lamda);

u = w(lamda) .* (LTV_sigma_f - img) + img;
v = img - u;

u = uint8(u);
v = uint8(v);

end