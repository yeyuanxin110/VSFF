clc;
clear all;
addpath(genpath(pwd));

fusion_method = ["VSFF"];
RGBlocation = '.\data\optical';
SARlocation = '.\data\sar';
resultlocation = '.\data\result';
RGBdir=dir(fullfile(RGBlocation,'*.tif'));
SARdir=dir(fullfile(SARlocation,'*.tif'));

RGBfileNames = {RGBdir.name};
SARfileNames = {SARdir.name};
[~,image_num] = size(RGBfileNames);
bandnum = 3;

flag = 'all';
currentFolder = pwd;

for i = 1 : image_num
    
    RGB = imread(fullfile(RGBlocation, RGBfileNames{i}));
    SAR = imread(fullfile(SARlocation, SARfileNames{i}));
    
    if ndims(RGB) > bandnum
        RGB = RGB(:,:,1:3);
    end
    
    if ndims(SAR) == bandnum
        SAR = SAR(:,:,1);
    end
    
    fusion_func = str2func(fusion_method);
    Fus_output = fusion_func(RGB,SAR);
    Fus_output = uint8(Fus_output);
    
    resultimgname = RGBfileNames{i};
    mkdir(fullfile(resultlocation, fusion_method));
    imwrite(Fus_output,char(fullfile(resultlocation, fusion_method,resultimgname)));
end
