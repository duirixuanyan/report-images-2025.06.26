The `WeatherModel` class contains a constructor that initializes various hyperparameters which are crucial for defining the model's architecture, training process, and data handling. Here's a detailed breakdown:

### Model Structure Parameters[](#model-structure-parameters)

+   `neurons_layer1`: This parameter sets the number of neurons (units) in the first layer of the neural network. In this context, it's likely used in the gated residual network and attention mechanisms to control the complexity and capacity of the model.
    
+   `neurons_layer2`: This represents the number of neurons in the second layer, possibly used within the BiLSTM layers, which suggests a lower dimensionality, potentially to capture more nuanced or abstracted features of the data.
    
+   `num_heads`: This hyperparameter specifies the number of attention heads in the Multi-Head Attention (MHA) mechanisms. Multiple heads allow the model to focus on different parts of the input sequence simultaneously, improving its ability to capture various patterns.
    
+   `key_dim`: Key dimension in MHA controls the size of each attention head. Smaller dimensions force the model to compress information, while larger ones allow for more complex representations.
    
+   `dropout_rate`: This is the fraction of the input units to drop as a form of regularization during training, which helps prevent overfitting.
    

### Training Parameters[](#training-parameters)

+   `epochs`: The number of complete passes through the entire training dataset.
    
+   `batch_size`: The number of samples that will be propagated through the network in one forward/backward pass.
    
+   `learning_rate`: The step size at each iteration while moving toward a minimum of the loss function.
    
+   `min_lr`: The minimum learning rate that the learning rate scheduler can reduce to.
    
+   `patience1`: The number of epochs with no improvement after which training will be stopped (early stopping).
    
+   `patience2`: The number of epochs with no improvement after which the learning rate will be reduced.
    

### Time Series Parameters[](#time-series-parameters)

+   `past_time_steps`: The number of previous time steps the model will look at for making predictions.
    
+   `time_step`: The interval between each time step, presumably in minutes.
    
+   `forecast_steps`: The number of future time steps the model will predict.
    
+   `window_size`: The size of the sliding window used for creating batches of data. This particular window size suggests that each window encompasses one week of data.
    
+   `prediction_days`: The number of days the model is expected to make predictions for.
    

### Loss Function Parameters[](#loss-function-parameters)

+   `lr_reduce_factor`: The factor by which the learning rate will be reduced when the `patience2` condition is met.
    
+   `quantiles`: This parameter indicates the quantiles to be used in the loss function. Quantile losses are typically used in probabilistic forecasting to estimate the distribution of the forecasted values.
    

[Data Processing](https://botanicbyte.com/Indoor_Climate_Forecasting_Model/Data_Processing "Data Processing")[Model Architecture](https://botanicbyte.com/Indoor_Climate_Forecasting_Model/Model_Architecture "Model Architecture")