### 6MatlabFuncs：一些Matlab函数

**./**：当前目录

- **cellmachine.m**：生成细胞自动机
- **makeGaussian.m**：根据行人数据集标注数据生成密度图


**pd/**：与行人检测算法相关,调用关系：example -> makeData -> (getHOG, getHOP -> PhaseCongruency, getHLID, getHOI)

- **PhaseCongruency**：计算相位一致性的函数库——[MATLAB and Octave Functions for Computer Vision and Image Processing](http://www.peterkovesi.com/matlabfns/)
- **getHOG.m**：计算图片的HOG特征
- **getHOP.m**：计算图片的HOP特征
- **getHLID.m**：计算图片的HLID特征
- **getHOI.m**：计算图片的HOI特征
- **makeData.m**：提提取文件夹下所有图片的特征矩阵
- **example.m**：实例使用程序，注意传递的参数setting结构体，它包含以下一些域：


|     域      |    属性     |            含义            |
| :--------: | :-------: | :----------------------: |
|    bin     |  可选，默认为9  |      cell直方图投影的分块数量      |
|   block    |  可选，默认为2  |  每个block水平和垂直方向cell的数量   |
|   stride   | 可选，默认为0.5 | block间的重叠区域占一个block大小的比例 |
|   radius   |   必须传入    |      计算特征时四周忽略的像素值       |
|   cell_h   |   必须传入    |         cell的高度          |
|   cell_w   |   必须传入    |         cell的宽度          |
|   isGama   |  可选，默认为0  |         是否进行伽马校正         |
| isNormlize |  可选，默认为1  |        是否正则化block        |
|   nscale   |  可选，默认为4  | log-Gabor的尺度数量（仅用于HOP特征） |
|  norient   |  可选，默认为6  | log-Gabor的方向数量（仅用于HOP特征） |