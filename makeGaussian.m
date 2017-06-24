function [ result ] = makeGaussian( size, matPath, width, sigma )
%   MAKEGAUSSIAN:	[ result ] = makeGaussian( size, matPath, width, sigma )    世博会行人数据库计算密度图
%   Arguments:
%       size        图片大小
%       matPath     标注mat文件的位置
%       width       高斯核宽度
%       sigma       高斯核标准差
%   Return:
%       result      密度图
%   Usage: result = makeGaussian([576,720],'100158_A02IndiaSW-04-S20100626080000000E20100626233000000_new.split.116.ts_2.mat',49,49);

mat = load(matPath);
result = zeros(size);
for i = 1 : mat.point_num
    x = mat.point_position(i,2);
    y = mat.point_position(i,1);
    result(x, y) = 1;
end
h = fspecial('gaussian',width, sigma);
result = imfilter(result,h);
mesh(result);
end