function [ array ] = cellmachine( rule, m )
%   CELLMACHINE:   [ array ] = cellmachine( rule, m )   ����ϸ���Զ���
%   Arguments:
%       rule        ϸ���Զ�������0~255
%       m           ��������
%   Returns:
%       array       ��������������
%   Usage:  cellmachine( 110, m )

n = 2 * m + 1 + 2;
table = dec2bin(rule, 8);
array = zeros(m, n);
array(1, 1 : n) = floor(rand(1, n) + 0.5);
for i = 2 : m
    for j = 2 : n - 1
        array(i, j) = str2double(table(8 - array(i - 1, j - 1) * 4 - array(i - 1, j) * 2 - array(i - 1, j + 1)));
    end
end
array = array(:, 2 : n - 1);
colormap('gray')
imagesc(array);
end