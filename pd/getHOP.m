function [ hop ] = getHOP( im, setting )
%   GETHOP: [ hop ] = getHOP( im, setting )   计算图片的HOP特征
%   Depend On:  PhaseCongruency
%   Arguments:
%       im          要提取特征的图片
%       setting     特征设置
%   Returns:
%       hop         HOP特征
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
if ~isfield(setting, 'nscale')
    setting.nscale = 4;
end
if ~isfield(setting, 'norient')
	setting.norient = 6;
end

cell_h = setting.cell_h;
cell_w = setting.cell_w;
radius = setting.radius;
bin = setting.bin;
block = setting.block;
stride = setting.stride;
nscale  = setting.nscale;
norient = setting.norient;
isNormlize = setting.isNormlize;

[~, ~, ~, ~, ~, EO, ~] = phasecong3(im, nscale, norient);
pc = 0;
phase = 0;
fenmu = 0;
F = 0;
for j = 1 : norient
    sum = 0;
    for i = 1 : nscale
        sum = sum + EO{i, j};
        fenmu = fenmu + abs(EO{i, j});
        F = F + EO{i, j};
    end
    pc = pc + abs(sum);
end
pc = pc ./ (1e-5 + fenmu);
phase = angle(F);
phase(phase < 0) = phase(phase < 0) + pi;
phase = floor(phase * (bin - 1) / pi) + 1;

[rows, cols] = size(im);
block_h = block * cell_h;
block_w = block * cell_w;
block_x = floor(((rows - radius * 2) / block_h - 1) / (1 - stride) + 1);
block_y = floor(((cols - radius * 2) / block_w - 1) / (1 - stride) + 1);
block_h_delta = floor(block_h * stride);
block_w_delta = floor(block_w * stride);

hop = [];
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
        hop_block = [];
        for block_i = 1 :block
            start_cell_x = start_x + (block_i - 1) * cell_h;
            for block_j = 1 :block
                start_cell_y = start_y + (block_j - 1) * cell_w;
                hop_cell = zeros(1, bin);
                for cell_i = start_cell_x : start_cell_x + cell_h - 1
                    for cell_j = start_cell_y : start_cell_y + cell_w - 1
                        hop_cell(phase(cell_i, cell_j)) =  hop_cell(phase(cell_i, cell_j)) + pc(cell_i, cell_j);
                    end
                end
                hop_block = cat(2, hop_block, hop_cell);
            end
        end
        if isNormlize 
            hop_block = hop_block ./ (norm(hop_block) + 1e-5); 
        end
        hop = cat(2, hop, hop_block);
    end
end
end