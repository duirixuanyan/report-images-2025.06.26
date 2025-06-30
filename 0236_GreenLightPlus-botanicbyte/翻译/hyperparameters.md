`WeatherModel` 类包含一个构造函数，用于初始化各种对模型架构、训练过程和数据处理至关重要的超参数。以下是详细说明：

### 模型结构参数[](#model-structure-parameters)

+   `neurons_layer1`: 该参数设置神经网络第一层的神经元(单元)数量。在此上下文中，它可能用于门控残差网络和注意力机制，以控制模型的复杂性和容量。
    
+   `neurons_layer2`: 表示第二层的神经元数量，可能用于BiLSTM层中，较低的维度可能用于捕捉数据更细微或更抽象的特征。
    
+   `num_heads`: 该超参数指定多头注意力(MHA)机制中的注意力头数量。多个头允许模型同时关注输入序列的不同部分，提高捕捉各种模式的能力。
    
+   `key_dim`: MHA中的键维度控制每个注意力头的大小。较小的维度迫使模型压缩信息，而较大的维度允许更复杂的表示。
    
+   `dropout_rate`: 训练期间作为正则化手段丢弃的输入单元比例，有助于防止过拟合。
    

### 训练参数[](#training-parameters)

+   `epochs`: 完整遍历整个训练数据集的次数。
    
+   `batch_size`: 单次前向/后向传播通过网络处理的样本数量。
    
+   `learning_rate`: 在向损失函数最小值移动时每次迭代的步长大小。
    
+   `min_lr`: 学习率调度器可以降低到的最小学习率。
    
+   `patience1`: 训练停止前允许没有改进的epoch数(早停机制)。
    
+   `patience2`: 学习率降低前允许没有改进的epoch数。
    

### 时间序列参数[](#time-series-parameters)

+   `past_time_steps`: 模型用于预测时参考的历史时间步数。
    
+   `time_step`: 每个时间步之间的间隔，推测以分钟为单位。
    
+   `forecast_steps`: 模型需要预测的未来时间步数。
    
+   `window_size`: 用于创建数据批次的滑动窗口大小。此特定窗口大小表明每个窗口包含一周的数据。
    
+   `prediction_days`: 模型需要预测的天数。
    

### 损失函数参数[](#loss-function-parameters)

+   `lr_reduce_factor`: 当满足`patience2`条件时，学习率将按此因子降低。
    
+   `quantiles`: 该参数表示损失函数中使用的分位数。分位数损失通常用于概率预测中，以估计预测值的分布。
    

[Data Processing](https://botanicbyte.com/Indoor_Climate_Forecasting_Model/Data_Processing "Data Processing")[Model Architecture](https://botanicbyte.com/Indoor_Climate_Forecasting_Model/Model_Architecture "Model Architecture")