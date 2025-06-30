## Model Architecture

The model is constructed using several advanced neural network components to process time-series data for the task of predicting indoor temperature and vapor pressure. Below is a detailed explanation of each part of the model's architecture:

+   Gated Residual Networks (GRN)
+   Encoder Block
+   Decoder Block
+   Multi-Head Attention (MHA)

### Gated Residual Network[](#gated-residual-network)

+   **GLU (Gated Linear Unit)**: This block starts with a linear transformation of the input data `x`, doubling the number of hidden units. It then splits this transformed data into two equal parts. One part is passed through a `tanh` activation function and the other through a `sigmoid`. The outputs of both are multiplied element-wise, combining the properties of both transformations.
+   **Layer Normalization**: The output from the GLU is then normalized on a per-layer basis to stabilize the learning process and improve convergence.
+   **Residual Connection**: The input `x` is also transformed to match the dimensions of the gated output and then added to the gated output to form a residual connection. This helps in mitigating the vanishing gradient problem and allows the training of deeper networks.

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

+   **Self-MHA (Self Multi-Head Attention)**: This part of the model uses a self-attention mechanism that allows the model to weigh the importance of different input positions. It is useful for the model to understand the context within the input sequence.
    
+   **Gated Residual Network**: The output of the self-attention layer is passed through a gated residual network as described above.
    
+   **BiLSTM (Bidirectional Long Short-Term Memory)**: The output from the GRN is fed into a bidirectional LSTM, which processes the data in both directions (past to future and future to past). This helps in capturing patterns over time from both directions, which can be very beneficial for time-series forecasting.
    

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

+   **Query Generation**: This block generates a query from the combined output of the encoder using a dense layer.
    
+   **Self Attention**: A self-attention mechanism is applied to the query to focus on different parts of the input sequence.
    
+   **Cross-MHA (Cross Multi-Head Attention)**: This step involves a cross-attention mechanism where the query from the previous step and the encoder outputs are used as key and value in a multi-head attention layer. This allows the model to focus on relevant parts of the input sequence.
    
+   **Gated Residual Network and BiLSTM**: Similar to the encoder block, the outputs of the attention mechanisms are passed through a gated residual network and then a BiLSTM layer.
    

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

+   **Feature Weighting**: This block starts by generating weights for each encoded feature using a softmax function on the concatenation of all encoded features.
    
+   **Weight Application**: The weights are then used to scale the encoded features. This weighted sum approach allows the model to focus on more important features.
    
+   **Multihead Attention**: The combined weighted features are passed through another multi-head attention layer, which allows the model to compare different weighted features against each other.
    
+   **Dropout**: Finally, a dropout layer is applied to the multi-head attention outputs to prevent overfitting by randomly dropping out units during training.
    

The combination of these elements allows the model to make predictions based on a complex understanding of time-series data, capturing both long-term dependencies and short-term variations. The use of attention mechanisms enables the model to focus on the most relevant parts of the input data, improving the quality of the predictions.

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

### Parameters Description[](#parameters-description)

The model uses several parameters to define its architecture and training behavior. Here's a brief overview:

+   **`hidden_units`**: This parameter defines the number of neurons in a dense layer or a gated residual network. It determines the capacity of the network to learn complex features from the data.
    
+   **`num_heads`**: In multi-head attention (MHA) layers, this parameter specifies how many different attention "heads" are used. Multiple heads allow the model to focus on different parts of the input sequence simultaneously, capturing various aspects of the information.
    
+   **`key_dim`**: This parameter denotes the size of each attention head for key and query dimensions in MHA layers. It influences the resolution at which the model processes the data.
    
+   **`neurons_layer1` and `neurons_layer2`**: These parameters specify the number of neurons in the first and second layers of the network. `neurons_layer1` is used in the gated residual network and `neurons_layer2` in the LSTM layers.
    
+   **`dropout_rate`**: This parameter controls the dropout rate applied after the MHA layers. Dropout is a regularization technique that helps prevent overfitting by randomly setting a fraction of the input units to 0 during training.
    
+   **`past_time_steps`**: This parameter defines how many past time steps are used as input to the model. It is crucial for the model to capture the temporal dependencies in the data.
    
+   **`forecast_steps`**: This parameter determines how many future steps the model should predict. It defines the output shape of the model's predictions.
    

### Building Model[](#building-model)

The `build_model` function constructs the deep learning model using Keras functional API:

+   **Input Layer Creation**: For each feature dimension, an input layer is created. These layers take sequences of length equal to `self.past_time_steps` as input, which is the historical data used to predict future conditions.
    
+   **Feature Encoding**: Each input feature is encoded separately. The `encoder_block` method applies a series of transformations to extract relevant patterns from the input data. This process includes self-attention mechanisms, gated residual networks (GRN), and bidirectional LSTMs to capture both forward and backward dependencies in the data.
    
+   **Multihead Attention Module**: After encoding, the features are combined using a multihead attention mechanism. This allows the model to focus on different parts of the input sequence and learn the importance of different features at different time steps.
    
+   **Output Decoder**: The decoder block processes the combined features to prepare for the final prediction. This block may use additional attention mechanisms and gated residual networks to refine the features before making predictions.
    
+   **Dropout Layer**: A dropout layer follows the decoder output, providing regularization by randomly setting a fraction of the input units to 0 at each update during training. This prevents overfitting.
    
+   **Output Layer**: The final dense layer produces the predictions. It has twice the number of units as the forecast steps, with a 'linear' activation function. The output is then reshaped to the desired output format, which typically includes the forecast horizon and the predicted variables (e.g., indoor temperature and vapor pressure).
    
+   **Model Compilation**: The model is compiled with the Adam optimizer and a custom loss function tailored for quantile regression, allowing the model to predict a range of possible outcomes rather than a single point estimate.
    

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

This model architecture leverages temporal patterns and dependencies within the data, making it suitable for time-series forecasting tasks such as predicting indoor conditions based on historical weather data. The combination of attention mechanisms and recurrent neural networks allows it to handle both short-term and long-term dependencies, while dropout and custom loss functions help improve generalization and performance on unseen data.

[Hyperparameters](https://botanicbyte.com/Indoor_Climate_Forecasting_Model/hyperparameters "Hyperparameters")[Model Training](https://botanicbyte.com/Indoor_Climate_Forecasting_Model/Model_Training_Process "Model Training")