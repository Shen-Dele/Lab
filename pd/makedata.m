function [ instance, img_list ] = makedata( path, getfeature, setting, format)
%   MAKEDATA:   [ instance, img_list ] = makedata( path, getfeature, setting, format)   �����ļ���������ͼƬ������
%   Arguments:
%       path            �ļ�·��
%       getfeature      ������������
%       setting         ��������
%       format          �ļ�����ͼƬ��ʽ��Ĭ��'*.jpg'
%   Returns:
%       instance        ��������
%       img_list        ��������ÿһ�ж�Ӧ��ԭʼͼƬ·��
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