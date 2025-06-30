### Model Evaluation:[](#model-evaluation)

1.  **Model Loading**:
    
    +   The method begins by constructing the path to the trained model file based on the roof type, quantiles, past time steps, forecast steps, and city name.
2.  **Data Loading and Preprocessing**:
    
    +   Data for features and labels are loaded using the `load_data` method.
    +   The features and labels are converted to NumPy arrays and then transformed into a dataset suitable for prediction using the `create_dataset` method.
    +   The data is then reshaped for scaling, and the scaler objects for features and labels are loaded using the `joblib` library.
    +   All the data is transformed using the respective scalers to match the distribution the model was trained on.
3.  **Model Prediction**:
    
    +   The features are reshaped again to fit the model input requirements.
    +   A random index is chosen to select a data window equivalent to 7 days for testing.
    +   Predictions are made using the model's `predict` method on the selected test features.
4.  **Data Post-processing**:
    
    +   Predictions and labels are reshaped to a 2D format for inverse scaling.
    +   The scaler is used to reverse the normalization of predictions and labels to obtain their original scale.
    +   The inverse-transformed data is reshaped back to its original dimensions.
5.  **Metrics Calculation**:
    
    +   The `calculate_metrics` method is called with the inverse-transformed labels and predictions to evaluate the model's performance.
    +   The calculated metrics are printed out, displaying the model's performance in percentage terms.
6.  **Visualization**:
    
    +   Finally, the `visualize_results` method is called to create visual representations of the model's predictions compared to the actual values.

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

[Evaluation Metrics](https://botanicbyte.com/Indoor_Climate_Forecasting_Model/Evaluation_Metrics "Evaluation Metrics")