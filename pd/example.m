%% HOP
main_path = 'E:\data\TrainSamples';
test_path = 'E:\data\test';
disStr = {'far', 'middle', 'near'};
scale_h = [32 64 80];
scale_w = [12 24 32];
cell_h = [4 8 8];
cell_w = [3 6 8];

dis = 3;
hop = [];
imgs = [];
for i = 2 : dis
    hopSetting.bin = 9;
    hopSetting.block = 2;
    hopSetting.stride = 0.5;
    hopSetting.radius = 1;
    hopSetting.cell_h = cell_h(i);
    hopSetting.cell_w = cell_w(i);
    hopSetting.isGama = 0;
    hopSetting.isNormlize = 1;
    
    scale_size = [scale_h(i) + 2 * hopSetting.radius scale_w(i) + 2 * hopSetting.radius];
    [ instance_pos, ~ ] = makedata( [main_path '\pos\' disStr{i}], scale_size, @getHOP, hopSetting);
    [ instance_neg, ~ ] = makedata( [main_path '\neg\' disStr{i}], scale_size, @getHOP, hopSetting);
    hop(i).label = [ones(size(instance_pos, 1), 1); ones(size(instance_neg, 1), 1) * -1];
    hop(i).instance = [instance_pos; instance_neg];
    
    [ instance_pos, imgs_pos ] = makedata( [test_path '\pos\' disStr{i}], scale_size, @getHOP, hopSetting);
    [ instance_neg, imgs_neg ] = makedata( [test_path '\neg\' disStr{i}], scale_size, @getHOP, hopSetting);
    hop(i).label_test = [ones(size(instance_pos, 1), 1); ones(size(instance_neg, 1), 1) * -1];
    hop(i).instance_test = [instance_pos; instance_neg];
    imgs{i} = [imgs_pos; imgs_neg];
    
    clear instance_pos instance_neg imgs_pos imgs_neg;
    
    hop(i).model = svmtrain(hop(i).label, hop(i).instance, '-t 0');
    [result.predicted_label, result.accuracy, result.decision_values] = svmpredict(hop(i).label_test, hop(i).instance_test, hop(i).model);
    result.tp = sum(hop(i).label_test == 1 & result.predicted_label == 1);
    result.tn = sum(hop(i).label_test == -1 & result.predicted_label == -1);
    result.fp = sum(hop(i).label_test == -1 & result.predicted_label == 1);
    result.fn = sum(hop(i).label_test == 1 & result.predicted_label == -1);
    result.recall = result.tp / (result.tp + result.fn);
    result.fpr = result.fp / (result.fp + result.tn);
    hop(i).result = result;
    
    clear result;
end