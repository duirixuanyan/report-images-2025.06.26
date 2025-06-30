### 模型评估:[](#model-evaluation)

1.  **模型加载**:
    
    +   该方法首先根据屋顶类型、分位数、过去时间步长、预测步长和城市名称构建训练好的模型文件路径。
2.  **数据加载与预处理**:
    
    +   使用`load_data`方法加载特征和标签数据。
    +   将特征和标签转换为NumPy数组，然后使用`create_dataset`方法转换为适合预测的数据集。
    +   为缩放操作重塑数据形状，并使用`joblib`库加载特征和标签的缩放器对象。
    +   使用相应的缩放器转换所有数据，使其匹配模型训练时的数据分布。
3.  **模型预测**:
    
    +   再次重塑特征形状以满足模型输入要求。
    +   随机选择一个索引来选取相当于7天数据的测试窗口。
    +   使用模型的`predict`方法对选定的测试特征进行预测。
4.  **数据后处理**:
    
    +   将预测值和标签重塑为2D格式以便进行逆缩放。
    +   使用缩放器对预测值和标签进行反归一化，恢复其原始尺度。
    +   将逆变换后的数据重塑回原始维度。
5.  **指标计算**:
    
    +   调用`calculate_metrics`方法，使用逆变换后的标签和预测值评估模型性能。
    +   打印计算出的指标，以百分比形式显示模型性能。
6.  **可视化**:
    
    +   最后调用`visualize_results`方法，创建模型预测值与实际值的可视化对比图。

```python
def evaluate_prediction(self):
    # Define the path to the saved model
    model_pth = f"data/pth/{self.roof_type}_{self.quantiles}_{self.past_time_steps}_{self.forecast_steps}_{self.city_name}.h5"
 
    print(f"Loading model from : {model_pth} ...")
 
    # Load your data
    features, labels = self.load_data()
    
    print(f"evaluate_prediction features shape: {features.shape}")
    print(f"evaluate_prediction labels shape: {labels.shape}")
 
    # Convert the features and labels to numpy arrays
    features = features.to_numpy()
    labels = labels.to_numpy()
 
    # Create the dataset
    features, labels = self.create_dataset(features, labels)
    
    print(f"evaluate_prediction features shape1: {features.shape}")
    print(f"evaluate_prediction labels shape1: {labels.shape}")
 
    # Reshape the features and labels to fit the scaler
    features = features.reshape(-1, features.shape[-1])
    labels = labels.reshape(-1, labels.shape[-1])
 
    print(f"evaluate_prediction features shape2: {features.shape}")
    print(f"evaluate_prediction labels shape2: {labels.shape}")
 
    # Load the scalers
    scaler_labels = load("data/pth/scaler_labels.joblib")
    scaler_features = load("data/pth/scaler_features.joblib")
 
    # Transform all the data
    features = scaler_features.transform(features)
    labels = scaler_labels.transform(labels)
 
    # Reshape the features and labels to fit the model input
    features = features.reshape(-1, self.past_time_steps, features.shape[-1])
    labels = labels.reshape(-1, self.forecast_steps, labels.shape[-1])
 
    # Load the model
    model = models.load_model(f"{model_pth}", custom_objects={"quantiles_loss": self.quantiles_loss})
 
    # Randomly select a window of 7 days of data for prediction
    idx = random.randint(0, len(features) - int(self.prediction_days * 12 * 24))
    idx = 34648
    print(f"idx: {idx}")
    features_test = [features[idx: idx + int(self.prediction_days * 12 * 24), :, i: i + 1] for i in range(features.shape[-1])]
    labels_test = labels[idx: idx + int(self.prediction_days * 12 * 24)]
 
    # Make predictions
    predictions = model.predict(features_test)
 
    # Reshape the data for inverse normalization
    predictions_2D = predictions.reshape(-1, predictions.shape[-1])
    labels_test_2D = labels_test.reshape(-1, labels_test.shape[-1])
 
    # Inverse normalize the predictions and actual values
    predictions_inverse_2D = scaler_labels.inverse_transform(predictions_2D)
    labels_inverse_2D = scaler_labels.inverse_transform(labels_test_2D)
 
    # Reshape the inverse normalized data to its original shape
    predictions_inverse = predictions_inverse_2D.reshape(predictions.shape)
    labels_inverse = labels_inverse_2D.reshape(labels_test.shape)
 
    # Calculate the metrics
    metrics = self.calculate_metrics(labels_inverse, predictions_inverse)
    for name, value in metrics.items():
        print(f"{name}: {value * 100:.2f}%")
 
    # Visualize the results
    self.visualize_results(predictions_inverse, labels_inverse)
 
```

[评估指标](https://botanicbyte.com/Indoor_Climate_Forecasting_Model/Evaluation_Metrics "Evaluation Metrics")