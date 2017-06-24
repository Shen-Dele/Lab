function [hlid] = myHLID(im, setting)
%   GETHLID: [ hlid ] = getHLID( im, setting )   计算图片的HLID特征
%   Arguments:
%       im          要提取特征的图片
%       setting     特征设置
%   Returns:
%       hlid         HLID特征

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
angle_delta = 360 / bin / 180 * pi;
magnit = zeros(rows, cols);
angle = zeros(rows, cols);

for i = radius + 1 : rows - radius
    for j = radius + 1 : cols - radius
        max_magnit = -inf;
        max_angle = -1;
        for z = 1 : bin
            pos_x = i + cos(angle_delta * z) * radius;
            pos_y = j + sin(angle_delta * z) * radius;
            x1 = floor(pos_x);
            x2 = ceil(pos_x);
            y1 = floor(pos_y);
            y2 = ceil(pos_y);
            if x1 == x2
                r1 = im(x1, y1);
                r2 = im(x2, y2);
            else
                r1 = (x2 - pos_x) * im(x1, y1) + (pos_x - x1) * im(x2, y1);
                r2 = (x2 - pos_x) * im(x1, y2) + (pos_x - x1) * im(x2, y2);
            end
            if y1 == y2
                result = r1;
            else
                result = (y2 - pos_y) * r1 + (pos_y - y1) * r2;
            end
            diff = abs(result - im(i, j));
            if(diff > max_magnit)
                max_magnit = diff;
                max_angle = z;
            end
        end
        magnit(i, j) = max_magnit;
        angle(i, j) = max_angle;
    end
end

block_h = block * cell_h;
block_w = block * cell_w;
block_x = floor(((rows - radius * 2) / block_h - 1) / (1 - stride) + 1);
block_y = floor(((cols - radius * 2) / block_w - 1) / (1 - stride) + 1);
block_h_delta = floor(block_h * stride);
block_w_delta = floor(block_w * stride);

hlid = [];
start_x = radius + 1;
for i = 1 : block_x
    if i ~=1
        start_x = start_x + block_h - block_h_delta;
    end
    start_y = radius + 1;
    for j = 1 : block_y
        if j ~=1
            start_y = start_y + block_w - block_w_delta;
        end
        hlid_block = [];
        for block_i = 1 :block
            start_cell_x = start_x + (block_i - 1) * cell_h;
            for block_j = 1 :block
                start_cell_y = start_y + (block_j - 1) * cell_w;
                hlid_cell = zeros(1,bin);
                for cell_i = start_cell_x : start_cell_x + cell_h - 1
                    for cell_j = start_cell_y : start_cell_y + cell_w - 1
                        hlid_cell(angle(cell_i, cell_j)) =  hlid_cell(angle(cell_i, cell_j)) + magnit(cell_i, cell_j);
                    end
                end
                hlid_block = cat(2, hlid_block, hlid_cell);
            end
        end
        if isNormlize
            hlid_block = hlid_block ./ (norm(hlid_block) + 1e-5);
        end
        hlid = cat(2, hlid, hlid_block);
    end
end
end