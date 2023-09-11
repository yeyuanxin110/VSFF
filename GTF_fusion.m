function GTF_result = GTF_fusion(M1,M2,T)

% Calculate the pixel-saliency map
PSM1 = pixel_saliency(M1);
PSM2 = pixel_saliency(M2.*T);

PSM1 = norm_zero(PSM1);
PSM2 = norm_zero(PSM2);

w = ceil(PSM1 - PSM2);
PSM = w.*double(M1) + (1-w).*double(M2);

% Calculate the structure-saliency map
% Multiscale gradient
layel = 2;
GN1 = MG(M1,layel);
GN2 = MG(M2,layel);

GW = sum(ceil(GN2-GN1),3)/layel;

k1 = zeros(size(M1));
k2 = zeros(size(M1));

k1(GW==1) = 1;
k1(k1==0) = 0.5;
k2(M1<M2.*T) = 1;

SSM = (2-k1.*k2).*double(M1) + (k1.*k2).*double(M2);

GTF_result = GTF(PSM, SSM);
end

function img_norm = norm_zero(img)

img_max = max(max(img));
img(img==0) = 1e10;
img_min = min(min(img));
img(img==1e10) = 0;

img_norm = (img - img_min)./(img_max - img_min);

img_norm(img_norm<0) = 0;
end
