## 模型架构

该模型采用多种先进的神经网络组件来处理时间序列数据，用于预测室内温度和蒸汽压的任务。以下是模型架构各部分的详细说明：

+   门控残差网络(GRN)
+   编码器块
+   解码器块
+   多头注意力机制(MHA)

### 门控残差网络[](#gated-residual-network)

+   **GLU(门控线性单元)**: 该模块首先对输入数据`x`进行线性变换，将隐藏单元数量加倍。然后将变换后的数据分成两个相等的部分。一部分通过`tanh`激活函数，另一部分通过`sigmoid`激活函数。两者的输出进行逐元素相乘，结合了两种变换的特性。
+   **层归一化**: GLU的输出随后进行逐层归一化，以稳定学习过程并提高收敛性。
+   **残差连接**: 输入`x`也会被变换以匹配门控输出的维度，然后与门控输出相加形成残差连接。这有助于缓解梯度消失问题，并允许训练更深的网络。

```python
def gated_residual_network(self, x, hidden_units):
    # Gated Linear Unit (GLU)
    # First, transform the input x using a dense layer with twice the number of hidden units and a linear activation function
    x_transformed = layers.Dense(hidden_units * 2, activation="linear")(x)
    # Then, split the transformed input into two equal parts along the last axis
    split_gate = tf.split(x_transformed, num_or_size_splits=2, axis=-1)
    # The output of the GLU is the element-wise product of the tanh of the first part and the sigmoid of the second part
    output = tf.nn.tanh(split_gate[0]) * tf.nn.sigmoid(split_gate[1])
    # Apply layer normalization to the output
    output = layers.LayerNormalization()(output)
    # Transform the original input x to have the same shape as the output using a dense layer with a linear activation function
    x_transformed = layers.Dense(hidden_units, activation="linear")(x)
    # Add the transformed input to the output to form a residual connection
    output = x_transformed + output
    return output
```

### Encoder Block[](#encoder-block)

+   **Self-MHA (自注意力多头注意力机制)**: 这部分模型使用自注意力机制，使模型能够权衡不同输入位置的重要性。这有助于模型理解输入序列中的上下文关系。
    
+   **门控残差网络**: 自注意力层的输出会通过前面描述的门控残差网络进行处理。
    
+   **BiLSTM (双向长短期记忆网络)**: GRN的输出会输入到双向LSTM中，该网络会双向处理数据(从过去到未来和从未来到过去)。这有助于从两个方向捕捉时间模式，对时间序列预测非常有益。

```python
def encoder_block(self, input_layer):
    # Self-attention mechanism
    # Apply multi-head attention to the input layer
    self_attention_out = layers.MultiHeadAttention(
        num_heads=self.num_heads, key_dim=self.key_dim
    )(input_layer, input_layer, input_layer)
    # Apply the gated residual network to the output of the self-attention mechanism
    grn_out = self.gated_residual_network(
        self_attention_out, self.neurons_layer1)
    # Apply a bidirectional LSTM to the output of the gated residual network
    lstm_out, _, _, _, _ = layers.Bidirectional(
        layers.LSTM(self.neurons_layer2,
                    return_sequences=True, return_state=True)
    )(grn_out)
    # Apply the gated residual network to the output of the LSTM
    grn_out = self.gated_residual_network(lstm_out, self.neurons_layer1)
    return grn_out
```

### Decoder Block[](#decoder-block)

+   **查询生成(Query Generation)**: 该模块通过一个全连接层从编码器的组合输出中生成查询向量。
    
+   **自注意力机制(Self Attention)**: 对查询向量应用自注意力机制，使其能够关注输入序列的不同部分。
    
+   **交叉多头注意力(Cross-MHA)**: 这一步使用交叉注意力机制，将上一步的查询向量作为键(key)，编码器输出作为值(value)，通过多头注意力层进行处理。这使得模型能够聚焦于输入序列的相关部分。
    
+   **门控残差网络和双向LSTM**: 与编码器块类似，注意力机制的输出会先通过门控残差网络处理，然后再输入到双向LSTM层。

```python
def decoder_block(self, encoder_outputs):
    combined_output = encoder_outputs
    # Generate a query by passing the combined output through a dense layer
    query = layers.Dense(combined_output.shape[-1])(combined_output)
    # Self-attention mechanism
    # Apply multi-head attention to the query
    self_attention_out = layers.MultiHeadAttention(
        num_heads=self.num_heads, key_dim=self.key_dim
    )(query, query, query)
    # Cross-attention mechanism
    # Apply multi-head attention to the output of the self-attention mechanism, using the combined output as keys and values
    cross_attention_out = layers.MultiHeadAttention(
        num_heads=self.num_heads, key_dim=self.key_dim
    )(self_attention_out, combined_output, combined_output)
    # Apply the gated residual network to the output of the cross-attention mechanism
    grn_out = self.gated_residual_network(
        cross_attention_out, self.neurons_layer1)
    # Apply a bidirectional LSTM to the output of the gated residual network
    lstm_out = layers.Bidirectional(
        layers.LSTM(self.neurons_layer2, return_sequences=False)
    )(grn_out)
    # Apply the gated residual network to the output of the LSTM
    grn_out = self.gated_residual_network(lstm_out, self.neurons_layer1)
    return grn_out
```

### Multihead Attention Module[](#multihead-attention-module)

+   **特征加权(Feature Weighting)**: 该模块首先通过对所有编码特征的拼接应用softmax函数，为每个编码特征生成权重。
    
+   **权重应用(Weight Application)**: 然后使用这些权重对编码特征进行缩放。这种加权和方法使模型能够聚焦于更重要的特征。
    
+   **多头注意力(Multihead Attention)**: 将组合后的加权特征通过另一个多头注意力层，使模型能够比较不同加权特征之间的关系。
    
+   **Dropout**: 最后在多头注意力输出上应用dropout层，通过在训练期间随机丢弃单元来防止过拟合。

这些元素的组合使模型能够基于对时间序列数据的复杂理解进行预测，同时捕捉长期依赖关系和短期变化。注意力机制的使用使模型能够聚焦于输入数据中最相关的部分，从而提高预测质量。

```python
def multihead_attention_module(self, encoded_features):
    num_features = len(encoded_features)
    # Use a dense layer to learn the weights of each feature encoder's output
    weight_generator = tf.keras.layers.Dense(
        num_features, activation="softmax")
    # Compute the weights of each feature encoder's output
    feature_weights = weight_generator(
        tf.concat(encoded_features, axis=-1))
    weighted_features = []
    for i in range(num_features):
        # Expand to (batch_size, past_time_steps, 1)
        weight = feature_weights[:, :, i: i + 1]
        weight = tf.broadcast_to(weight, tf.shape(encoded_features[i]))
        # Multiply each feature encoder's output by its weight
        weighted_feature = encoded_features[i] * weight
        weighted_features.append(weighted_feature)
    # Concatenate all the weighted feature encoder outputs
    combined_weighted_features = tf.add_n(weighted_features)
    # Apply the multi-head attention mechanism
    multihead_attention_layer = tf.keras.layers.MultiHeadAttention(
        num_heads=self.num_heads, key_dim=combined_weighted_features.shape[-1]
    )
    multihead_attention_outputs = multihead_attention_layer(
        combined_weighted_features, combined_weighted_features
    )
    # Add a dropout layer
    dropout_out = layers.Dropout(self.dropout_rate)(
        multihead_attention_outputs)
    return dropout_out
```

### 参数说明[](#parameters-description)

该模型使用多个参数来定义其架构和训练行为，以下是简要概述：

+   **`hidden_units`**: 该参数定义密集层或门控残差网络中的神经元数量，决定了网络从数据中学习复杂特征的能力。
    
+   **`num_heads`**: 在多头注意力(MHA)层中，该参数指定使用多少个不同的注意力"头"。多个头允许模型同时关注输入序列的不同部分，捕获信息的多个方面。
    
+   **`key_dim`**: 该参数表示MHA层中键和查询维度上每个注意力头的大小，影响模型处理数据的分辨率。
    
+   **`neurons_layer1`和`neurons_layer2`**: 这些参数指定网络第一层和第二层的神经元数量。`neurons_layer1`用于门控残差网络，`neurons_layer2`用于LSTM层。
    
+   **`dropout_rate`**: 该参数控制MHA层后应用的dropout率。Dropout是一种正则化技术，通过在训练期间随机将部分输入单元设置为0来防止过拟合。
    
+   **`past_time_steps`**: 该参数定义模型使用多少个过去时间步作为输入，对于模型捕获数据中的时间依赖性至关重要。
    
+   **`forecast_steps`**: 该参数决定模型应该预测多少个未来步，定义了模型预测的输出形状。

### 模型构建[](#building-model)

`build_model`函数使用Keras函数式API构建深度学习模型：

+   **输入层创建**: 为每个特征维度创建一个输入层。这些层接收长度等于`self.past_time_steps`的序列作为输入，这是用于预测未来条件的历史数据。
    
+   **特征编码**: 每个输入特征被单独编码。`encoder_block`方法应用一系列转换从输入数据中提取相关模式，包括自注意力机制、门控残差网络(GRN)和双向LSTM，以捕获数据中的前向和后向依赖关系。
    
+   **多头注意力模块**: 编码后，使用多头注意力机制组合特征。这使模型能够关注输入序列的不同部分，并学习不同时间步上不同特征的重要性。
    
+   **输出解码器**: 解码器块处理组合后的特征以准备最终预测。该块可能使用额外的注意力机制和门控残差网络来在预测前细化特征。
    
+   **Dropout层**: 在解码器输出后添加dropout层，通过在训练期间每次更新时随机将部分输入单元设置为0来提供正则化，防止过拟合。
    
+   **输出层**: 最终的密集层产生预测结果。它的单元数是预测步数的两倍，使用'linear'激活函数。输出被重塑为所需的输出格式，通常包括预测范围和预测变量(如室内温度和蒸汽压力)。
    
+   **模型编译**: 模型使用Adam优化器和为分位数回归定制的损失函数进行编译，使模型能够预测一系列可能的结果，而不是单一的点估计。
    

```python
def build_model(self, input_dim):
    # Define the model inputs. Multiple inputs are created based on the number of features.
    input_layers = [
        layers.Input(shape=(self.past_time_steps, 1)) for _ in range(input_dim)
    ]  # Past 7 days of weather data
 
    # Encode each feature
    encoded_features = []
    for i in range(input_dim):
        # Input Encoder
        encoder_out = self.encoder_block(
            input_layers[i],
        )
        # The output of the encoder is considered as the encoded result of this feature
        encoded_feature = encoder_out
        encoded_features.append(encoded_feature)
 
    # Use the multi-head attention module
    multihead_attention_outputs = self.multihead_attention_module(
        encoded_features,
    )
 
    # Output Decoder
    decoder_out = self.decoder_block(
        multihead_attention_outputs,
    )
 
    # Dropout layer
    dropout_out = layers.Dropout(self.dropout_rate)(decoder_out)
 
    # Output layer
    output_layer = layers.Dense(2 * self.forecast_steps, activation="linear")(
        dropout_out
    )
 
    output_layer = layers.Reshape((self.forecast_steps, 2))(output_layer)
 
    # Create the model
    model = models.Model(
        inputs=input_layers, outputs=output_layer
    )  # Here, inputs need to be changed to input_layers
 
    # Compile the model...
    # loss=quantile_loss,loss='mean_squared_error'
    model.compile(
        optimizer=tf.optimizers.Adam(learning_rate=self.learning_rate),
        loss=self.quantiles_loss,
    )
    return model
```

该模型架构充分利用了数据中的时间模式和依赖关系，使其特别适合时间序列预测任务，例如基于历史天气数据预测室内环境状况。通过结合注意力机制和循环神经网络，该模型能够同时处理短期和长期依赖关系，而dropout层和自定义损失函数则有助于提升模型在未见数据上的泛化能力和预测性能。

[超参数](https://botanicbyte.com/Indoor_Climate_Forecasting_Model/hyperparameters "Hyperparameters")[模型训练](https://botanicbyte.com/Indoor_Climate_Forecasting_Model/Model_Training_Process "Model Training")