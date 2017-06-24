function [hoi] = myHOI(im, setting)
%   GETHOI: [ hoi ] = getHOI( im, setting )   计算图片的HOI特征
%   Arguments:
%       im          要提取特征的图片
%       setting     特征设置
%   Returns:
%       hoi         HOI特征

if ~isfield(setting, 'bin')
    setting.bin = 9;
end
if ~isfield(setting, 'block')
    setting.block = 2;
end
if ~isfield(setting, 'stride')
    setting.stride = 0.5;
end
if ~isa(im,'double')
    im = double(im);
end
if isfield(setting, 'isGama') && setting.isGama
    im = sqrt(im);
end
if ~isfield(setting, 'isNormlize')
    setting.isNormlize = 1;
end

cell_h = setting.cell_h;
cell_w = setting.cell_w;
radius = setting.radius;
bin = setting.bin;
block = setting.block;
stride = setting.stride;
isNormlize = setting.isNormlize;

[rows, cols] = size(im);
im_bins = ceil(im / 255 * bin);
im_bins(im_bins < 1) = 1;
im_bins(im_bins > bin) = bin;

block_h = block * cell_h;
block_w = block * cell_w;
block_x = floor(((rows - radius * 2) / block_h - 1) / (1 - stride) + 1);
block_y = floor(((cols - radius * 2) / block_w - 1) / (1 - stride) + 1);
block_h_delta = floor(block_h * stride);
block_w_delta = floor(block_w * stride);

hoi = [];
start_x = radius + 1;
for i = 1 :block_x
    if i ~=1
        start_x = start_x + block_h - block_h_delta;
    end
    start_y = radius + 1;
    for j = 1 :block_y
        if j ~=1
            start_y = start_y + block_w - block_w_delta;
        end
        hoi_block = [];
        for block_i = 1 :block
            start_cell_x = start_x + (block_i - 1) * cell_h;
            for block_j = 1 :block
                start_cell_y = start_y + (block_j - 1) * cell_w;
                hoi_cell = zeros(1,bin);
                for cell_i = start_cell_x : start_cell_x + cell_h - 1
                    for cell_j = start_cell_y : start_cell_y + cell_w - 1
                        hoi_cell(im_bins(cell_i, cell_j)) =  hoi_cell(im_bins(cell_i, cell_j)) + im(cell_i, cell_j);
                    end
                end
                hoi_block = cat(2, hoi_block, hoi_cell);
            end
        end
        if isNormlize
            hoi_block = hoi_block ./ (norm(hoi_block) + 1e-5);
        end
        hoi = cat(2, hoi, hoi_block);
    end
end
end