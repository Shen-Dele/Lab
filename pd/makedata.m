function [ instance, img_list ] = makedata( path, getfeature, setting, format)
%   MAKEDATA:   [ instance, img_list ] = makedata( path, getfeature, setting, format)   计算文件夹下所有图片的特征
%   Arguments:
%       path            文件路径
%       getfeature      计算特征函数
%       setting         特征设置
%       format          文件夹下图片格式，默认'*.jpg'
%   Returns:
%       instance        特征数组
%       img_list        特征数组每一行对应的原始图片路径
%   Usage:	[ instance, img_list ] = makedata( 'E:\data\test\neg\far', @getHOG, setting, '*.jpg');

if ~exist('format', 'var') || isempty(format)
    format = '*.jpg';
end
img_dir = dir([path '\' format]);
length = numel(img_dir);
img_list = cell(length, 1);
instance = [];
for frame = 1 : length
    if mod(frame, ceil(length / 10)) == 0
        fprintf('%.2d%% finished...\n', frame / length * 100);
    end
    img_path = [path '\' img_dir(frame).name];
    img_list{frame} = img_path;
    im = double(rgb2gray(imread(img_path)));
    im = imresize(im, [setting.scale_h setting.scale_w], 'bilinear');
    hop = getfeature(im, setting);
    instance = cat(1, instance, hop);
end
end