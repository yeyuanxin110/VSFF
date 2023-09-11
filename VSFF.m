function Fus_res = VSFF(RGB,SAR)

addpath(genpath('.\CFD'));
addpath(genpath('.\GTF'));
fullpath = mfilename('fullpath');
[file_path] = fileparts( fullpath);
currentFolder = file_path;

imageRGB = double(RGB);
imageSAR = double(SAR);

%% Image preprocessing
% Intensity Component
I = mean(imageRGB,3);
% Equalization PAN component
imageSAR = (imageSAR - mean2(imageSAR)).*(std2(I)./std2(imageSAR)) + mean2(I);
% SAR low backscattered signal
T = mean2(imageSAR);
sar_lbs = uint8(ones(size(imageSAR))); 
sar_lbs(imageSAR<T) = 0;

%% Complementary feature decomposition
[MSF1,DTF1] = Cartoon_texture(I, 3);
[MSF2,DTF2] = Cartoon_texture(imageSAR, 3);

%% MSF fusion
MSF_fusion = GTF_fusion(MSF1, MSF2, sar_lbs);

%% DTF fusion
DTF_fusion = texture_fusion(DTF1, DTF2, sar_lbs);

%% Complementary feature fusion
I_Fus = MSF_fusion + DTF_fusion;

%% IHS transform
I_Fus = double(I_Fus);
D = I_Fus - I;
Fus_res = imageRGB + repmat(D,[1 1 size(RGB,3)]);
Fus_res = uint8(Fus_res);
 
end